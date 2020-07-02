//
//  RequestManager.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/28/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

protocol RequestManagerDelegate {
    func didReceiveData(_ requestManager : RequestManager, data : Data, type requestType : RequestType)
    func didFailWithError(_ requestManager : RequestManager, error : Error, type requestType : RequestType)
}

enum RequestError : Error {
    case json, image
}

final class RequestManager {
    var delegate : RequestManagerDelegate?
    private let session : URLSession
    
    init() {
        session = URLSession(configuration: .default)
        session.configuration.urlCache = URLCache()
    }
    
    func makeRequest(with urlString : String?, type requestType : RequestType) {
        guard let urlString = urlString else {
            if requestType == .image {
                delegate?.didFailWithError(self, error: RequestError.image, type: .image)
            }
            return
        }
        guard let url = URL(string: urlString) else { print("Burh2")
            return }
        let urlRequest = URLRequest(url: url)
        
        if let cachedResponse = session.configuration.urlCache?.cachedResponse(for: urlRequest) {
            self.delegate?.didReceiveData(self, data: cachedResponse.data, type: requestType)
        }
        else {
            let task = session.dataTask(with: urlRequest) {
                [unowned self] (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(self, error: error, type: requestType)
                }
                
                if let data = data, let response = response {
                    self.session.configuration.urlCache?.storeCachedResponse(CachedURLResponse(response: response, data: data), for: urlRequest)
                    self.delegate?.didReceiveData(self, data: data, type: requestType)
                }
            }
            task.resume()
        }
    }
}
