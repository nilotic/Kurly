//
//  GitHubRepositoryView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

struct GitHubRepositoryView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: GitHubRepository
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        HStack(spacing: 16) {
            thumbnailView
            
            VStack(spacing: 3) {
                nameView
                logInView
            }
        }
        .frame(height: 72)
    }
    
    // MARK: Private
    private var thumbnailView: some View {
        ZStack {
            if let avatarURL = data.owner.avatarURL {
                ImageView(url: avatarURL)
                    .frame(width: 40, height: 40)
            }
        }
        .frame(width: 40, height: 40)
        .cornerRadius(20)
        .padding(.leading, 20)
    }
    
    private var nameView: some View {
        Text(data.name)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color("neutral0"))
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var logInView: some View {
        Text(data.owner.logIn)
            .font(.system(size: 12))
            .foregroundColor(Color("neutral2"))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct GitHubRepositoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = GitHubRepositoryView(data: .placeholder)
        
        view
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.dark)
    }
}
#endif
