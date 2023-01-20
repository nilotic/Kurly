//
//  GitHubRepositoryProgressView.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/20.
//

import SwiftUI

struct GitHubRepositoryProgressView: View {
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
    }
}

#if DEBUG
struct GitHubRepositoryProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = GitHubRepositoryProgressView()
                    .border(.gray)
        
        view
            .previewDevice("iPhone 11 Pro")
            .preferredColorScheme(.light)
    }
}
#endif
