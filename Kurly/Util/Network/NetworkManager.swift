//
//  NetworkManager.swift
//  Kurly
//
//  Created by Den Jo on 2023/01/17.
//

import Combine
import UIKit

final class NetworkManager: NSObject {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    
    
    // MARK: - Value
    // MARK: Private
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request(urlRequest: URLRequest) async throws -> Response {
        log(.info, urlRequest.debugDescription)
        
        // Request
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        urlSession.configuration.allowsConstrainedNetworkAccess = false
        urlSession.configuration.allowsExpensiveNetworkAccess   = true
        
        let (data, urlResponse) = try await urlSession.data(for: urlRequest)
        return try handle(data: data, urlResponse: urlResponse)
    }
    
    func request<T: Encodable>(urlRequest: URLRequest, requestData: T) async throws -> Response {
        guard let request = encode(urlRequest: urlRequest, requestData: requestData) else { throw URLError(.badURL) }
        log(.info, request.debugDescription)
        
        // Request
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        urlSession.configuration.allowsConstrainedNetworkAccess = false
        urlSession.configuration.allowsExpensiveNetworkAccess   = true
        
        let (data, urlResponse) = try await urlSession.data(for: request)
        return try handle(data: data, urlResponse: urlResponse)
    }
    
    // MARK: Private
    private func encode<T: Encodable>(urlRequest: URLRequest, requestData: T) -> URLRequest? {
        var request = urlRequest
        
        guard let httpMethod = HTTPMethod(request: request) else {
            log(.error, "HTTP method is invalid.")
            return nil
        }
        
        switch httpMethod {
        case .get:
            guard let urlComponets = urlComponets(from: request.url, data: requestData) else {
                log(.error, "Failed to get a query.")
                return nil
            }
            
            request.url = urlComponets.url  // Insert parameters to the url
    
        case .put:
            if let contentType = request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) {
                if contentType.range(of: HTTPHeaderValue.application(.urlEncoded).rawValue) != nil {
                    request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
                    
                } else if contentType.hasPrefix(HTTPHeaderValue.application(.json).rawValue) {
                    do { request.httpBody = try encoder.encode(requestData) } catch { return nil }
                
                } else if contentType.hasPrefix(HTTPHeaderValue.multipart(.formData("")).rawValue) {
                    request.httpBody = requestData as? Data
                }
                
            } else {
                request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8)
            }
            
        case .post:
            if let contentType = request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) {
                if contentType.range(of: HTTPHeaderValue.application(.urlEncoded).rawValue) != nil {
                    request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
                    
                } else if contentType.hasPrefix(HTTPHeaderValue.application(.json).rawValue) {
                    do { request.httpBody = try encoder.encode(requestData) } catch { return nil }
                
                } else if contentType.hasPrefix(HTTPHeaderValue.multipart(.formData("")).rawValue) {
                    request.httpBody = requestData as? Data
                }
                
            } else {
                request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8)
            }
            
        case .delete:
            if let contentType = request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) {
                if contentType.range(of: HTTPHeaderValue.application(.urlEncoded).rawValue) != nil {
                    request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
                    
                } else if contentType.hasPrefix(HTTPHeaderValue.application(.json).rawValue) {
                    do { request.httpBody = try encoder.encode(requestData) } catch { return nil }
                
                } else if contentType.hasPrefix(HTTPHeaderValue.multipart(.formData("")).rawValue) {
                    request.httpBody = requestData as? Data
                }
                
            } else {
                request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8)
            }
        }
    
        return request
    }
    
    private func urlComponets<T: Encodable>(from url: URL?, data: T) -> URLComponents? {
        guard let string = url?.absoluteString, var urlComponent = URLComponents(string: string) else { return nil }
        
        do {
            guard var jsonData = try JSONSerialization.jsonObject(with: encoder.encode(data), options: .mutableContainers) as? [String: Any] else { return nil }
            
            // Remove null container
            for key in jsonData.keys.filter({ jsonData[$0] is NSNull }) { jsonData.removeValue(forKey: key) }
            
            var queryItems = [URLQueryItem]()
            for (key, value) in jsonData {
                switch value {
                case let list as [Any]:     list.forEach { queryItems.append(URLQueryItem(name: key, value: "\($0)")) }
                default:                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            
            urlComponent.queryItems = queryItems.isEmpty ? nil : queryItems
            return urlComponent
            
        } catch {
            return nil
        }
    }
    
    private func handleSSL(_ session: Foundation.URLSession, challenge: URLAuthenticationChallenge) -> Bool {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            log(.error, "Failed to get a authenticationMethod.")
            return false
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            log(.error, "Failed to set trust policies.")
            return false
        }
        
        var error: CFError? = nil
        guard SecTrustEvaluateWithError(serverTrust, &error), error == nil else {
            log(.error, "Failed to check the server trust. \(error?.localizedDescription ?? "")")
            return false
        }
        
        return true
    }
    
    private func handle(data: Data?, urlResponse: URLResponse?) throws -> Response {
        let response = try Response(data: data, urlResponse: urlResponse)
        log(response.statusCode == .ok ? .info : .error, response.debugDescription)
        
        switch response.statusCode {
        case .ok, .created, .accepted, .nonAuthoritativeInformation, .noContent, .resetContent, .partialContent, .multiStatus, .alreadyReported, .imUsed:
            break
            
        case .unauthorized:
            // Log Out
            throw response.error ?? URLError(.badServerResponse)
    
        default:
            throw response.error ?? URLError(.badServerResponse)
        }
        
        return response
    }
}


// MARK: - NSURLSession Delegate
extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        guard handleSSL(session, challenge: challenge), let trust = challenge.protectionSpace.serverTrust else { return (.cancelAuthenticationChallenge, nil) }
        return (.useCredential, URLCredential(trust: trust))
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        session.invalidateAndCancel()
    }
}
