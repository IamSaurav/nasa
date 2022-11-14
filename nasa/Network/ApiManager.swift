//
//  ApiManager.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation

enum Method: String {
    case get
}

final class ApiManager {
    
    private let session: URLSession
    private static let apiKeyValue = "q1ZieewTN1twP1nEcTFmfBtoupSVY2uFVZvjNB5N"
    private static let apiKey = "api_key"
    private static let date = "date"
    private static let baseURL = "https://api.nasa.gov"
    private let plantoryPodEndPoint = "\(baseURL)/planetary/apod?"
    static let appJson = "application/json"
    static let contentType = "Content-Type"
    
    private let noNetwork = "Not internet connection! Please check and try again"
    private let somethingWentWrong = "Something Went Wrong"
    
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
        self.session.configuration.waitsForConnectivity = true
    }
    
    func sendPodRequest(date: String, completion: @escaping (Result<PlanatoryPod, NasaError>) -> Void) {
        var urlComponents = URLComponents(string: plantoryPodEndPoint)!
        urlComponents.queryItems = [
            URLQueryItem(name: ApiManager.apiKey, value: ApiManager.apiKeyValue),
            URLQueryItem(name: "date", value: date)
        ]
        let request = URLRequest.init(url: urlComponents.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        sendRequest(request: request, completion: completion)
    }
    
    func sendRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NasaError>) -> Void) {
        guard NetworkManager.shared.isConnected else {
            completion(.failure(.network(noNetwork)))
            return
        }

        session.dataTask(with: request) { (data, response, error) in
            let nasaError = (error as? NasaError) ?? NasaError.other(self.somethingWentWrong)
            if !self.isStatusCodeValid(response) {
                completion(.failure(nasaError))
                return
            }
            switch (data, error) {
            case(let data?, _):
                do {
                    let decordModel = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decordModel))
                } catch {
                    completion(.failure(NasaError.parser))
                }
                break
            case(_, let error?):
                completion(.failure(.network(error.localizedDescription)))
                break
            default: break
            }
        }.resume()
    }
    
    func isStatusCodeValid(_ urlResponse: URLResponse?) -> Bool {
        guard let response = urlResponse as? HTTPURLResponse else { return  false }
        let statusCode = response.statusCode
        return statusCode < 400
    }
    
}

enum NasaError: Error, Equatable, Hashable, LocalizedError {
    case network(String)
    case parser
    case other(String)
    
    var errorDescription: String? {
        switch self {
        case .network(let message):
            return message
        case .parser:
            return "Unable to process data, please try again"
        case .other(let message):
            return message
        }
    }
}
