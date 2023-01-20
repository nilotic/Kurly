//
//  ImageView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

struct ImageView<Placeholder>: View where Placeholder: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var image: Image? = nil
    @State private var task: Task<Void, Never>? = nil
    @State private var isProgressing = false
    
    private let url: URL?
    private let placeholder: () -> Placeholder?
    
    private let threshold: CGFloat = 64
    
    
    // MARK: - Initializer
    init(url: URL?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder
    }
    
    init(url: URL?) where Placeholder == Color {
        self.init(url: url, placeholder: { Color("neutral7") })
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                placholderView
                imageView
                
                progressView
                    .scaleEffect(proxy.size.width < threshold ? 1 - ((threshold - proxy.size.width) / threshold) : 1)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .task {
                task?.cancel()
                task = Task.detached(priority: .background) {
                    await MainActor.run { isProgressing = true }
                    
                    do {
                        let image = try await ImageManager.shared.download(url: url)
                        
                        await MainActor.run {
                            isProgressing = false
                            self.image = image
                        }
                        
                    } catch {
                        await MainActor.run { isProgressing = false }
                    }
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var imageView: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFill()
        }
    }
    
    @ViewBuilder
    private var placholderView: some View {
        if image == nil {
            placeholder()
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if isProgressing {
            ProgressView()
                .progressViewStyle(.circular)
            
        }
    }
}

#if DEBUG
struct ImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = VStack {
            ImageView(url: URL(string: "https://wallpaperset.com/w/full/d/2/b/115638.jpg"))
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            
            ImageView(url: URL(string: "https://wallpaperset.com/w/full/d/2/b/115638")) {
                Text("⚠️")
                    .font(.system(size: 20))
            }
            .frame(width: 100, height: 100)
            .cornerRadius(20)
            .border(.gray)
            
            
            ImageView(url: URL(string: "https://wallpaperset.com/w/full/d/2/b/115638.jpg"))
                .frame(width: 120, height: 120)
                .cornerRadius(120 / 2)
                .padding(.top, 76)
            
            ImageView(url: URL(string: "https://wallpaperset.com/w/full/d/2/b/115638.jpg"))
                .frame(width: 80, height: 80)
                .cornerRadius(80 / 2)
            
            ImageView(url: URL(string: "https://wallpaperset.com/w/full/d/2/b/115638.jpg"))
                .frame(width: 40, height: 40)
                .cornerRadius(40 / 2)
        }
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.light)
    }
}
#endif
