//
//  ImageManager.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/19.
//

import SwiftUI

final class ImageManager {
    
    // MARK: - Singleton
    static let shared = ImageManager()
    
    
    // MARK: - Value
    // MARK: Private
    private lazy var imageCache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "ImageManagerQueue")
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 90
        configuration.timeoutIntervalForRequest     = 90
        configuration.timeoutIntervalForResource    = 90
        configuration.multipathServiceType          = .handover
        
        return URLSession(configuration: configuration)
    }()
    
    
    // MARK: - Initializer
    private init() {}
    
    
    // MARK: - Function
    // MARK: Public
    func download(url: URL?) async throws -> Image {
        guard let url = url else { throw URLError(.badURL) }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return Image(uiImage: cachedImage)
        }
        
        let data = (try await downloadSession.data(from: url)).0
        
        guard let image = UIImage(data: data) else { throw URLError(.badServerResponse) }
        queue.async { self.imageCache.setObject(image, forKey: url.absoluteString as NSString) }
        
        return Image(uiImage: image)
    }
}

