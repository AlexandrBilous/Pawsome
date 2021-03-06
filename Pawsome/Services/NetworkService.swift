//
//  NetworkService.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - POSTRequestModel
struct PostRequest : Codable {
    let imageID : String
    let userID : String
    let likeValue : Int
    
    enum CodingKeys : String, CodingKey {
        case imageID = "image_id"
        case userID = "sub_id"
        case likeValue = "value"
    }
}

protocol NetworkServiceHolder {
    var networkService : NetworkService { get }
}

protocol NetworkService {
    /// Dowload list of breeds and its description from server
    func fetchAllBreeds(onSuccess : @escaping ([Breed]) -> (), onFailure : @escaping () -> Void)
    /// Return array of image urls from server with given amount of elements
    func getRandomCatImages(category : Int?, imgCount : Int, onSuccess: @escaping ([Image]) -> (), onFailure : @escaping () -> Void)
    /// Load data from given url and return UIImage and Data via callback clousure
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?, Data) -> (), onFailure : @escaping () -> Void)
    /// Post users like to server with unique UUID
    func postLike(_ value : Int, _ imageID : String)
    /// Return actual image's categories on success
    func fetchImageCategories(onSuccess : @escaping ([Category]) -> (), onFailure : @escaping () -> Void)
}

final class NetworkServiceImplementation : NetworkService {
    private let urlSession : URLSession
    
    init (urlSession : URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchAllBreeds(onSuccess : @escaping ([Breed]) -> (), onFailure : @escaping () -> Void) {
        let dataTask = urlSession.dataTask(with: makeRequest(with: Constants.breedsUrl)) { (data, response, error) in
            guard let allData = data, error == nil, let breeds = Serializer.deserialize(from: allData, value: [Breed].self) else {
                DispatchQueue.main.async {
                    onFailure()
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess(breeds)
            }
        }
        dataTask.resume()
    }
    
    func getRandomCatImages(category : Int?, imgCount : Int, onSuccess: @escaping ([Image]) -> (), onFailure : @escaping () -> Void) {
        let urlName = category == nil ? "images/search?limit=\(imgCount)&order=\(ImagesOrder.random)&size=small" : "images/search?category_ids=\(category ?? 0)&limit=\(imgCount)&order=\(ImagesOrder.random)&size=small"
        let dataTask = urlSession.dataTask(with: makeRequest(with: urlName)) { (data, response, error) in
            guard let allData = data, error == nil, let images = Serializer.deserialize(from: allData, value: [Image].self) else {
                DispatchQueue.main.async {
                    onFailure()
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess(images)
            }
        }
        dataTask.resume()
    }
    
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?, Data) -> (), onFailure : @escaping () -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        let dataTask = urlSession.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                onFailure()
                return
            }
            DispatchQueue.main.async {
                onSuccess(UIImage(data: data), data)
            }
        })
        dataTask.resume()
    }
    
    func postLike(_ value : Int, _ imageID : String) {
        let requestBody = PostRequest(imageID: imageID,
                                      userID: UIDevice.uniqID(),
                                      likeValue: value)
        guard let postedData = Serializer.serialize(value: requestBody) else { return }
        let request = makeRequest(with: Constants.likes,
                                      httpMethod: HTTPMethods.post,
                                      data: postedData,
                                      header: Constants.postHeader)
        let task = urlSession.dataTask(with: request) { (_, _, error) in
            guard error == nil else { return }
        }
        task.resume()

    }
    
    func fetchImageCategories(onSuccess : @escaping ([Category]) -> (), onFailure : @escaping () -> Void) {
        let dataTask = urlSession.dataTask(with: makeRequest(with: Constants.categories)) { (data, response, error) in
            guard let allData = data, error == nil, let categories = Serializer.deserialize(from: allData, value: [Category].self) else {
                onFailure()
                return
            }
            DispatchQueue.main.async {
                onSuccess(categories)
            }
        }
        dataTask.resume()
    }
}

private extension NetworkServiceImplementation {
    func makeRequest(with url: String,
                     httpMethod : String = HTTPMethods.get,
                     data : Data? = nil,
                     header : [String : String] = Constants.getHeader) -> URLRequest {
        guard let url = URL(string: "\(Constants.host)\(url)") else {
            fatalError()
        }
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = header
        if let postedData = data {
            request.httpBody = postedData
        }
        return request as URLRequest
    }
    
    enum Constants {
        static let getHeader = ["x-api-key": "b8148468-b823-4b33-b6ca-4a6c994d0635"]
        static let postHeader = ["x-api-key": "b8148468-b823-4b33-b6ca-4a6c994d0635", "content-type": "application/json"]
        static let host = "https://api.thecatapi.com/v1/"
        static let breedsUrl = "breeds"
        static let likes = "votes"
        static let categories = "categories"
    }
    
    enum ImagesOrder {
        static let random = "RAND"
        static let ascending = "ASC"
        static let descending = "DESC"
    }
    
    enum HTTPMethods {
        static let get = "GET"
        static let post = "POST"
    }
}

// MARK: Images
struct Image : Codable, Equatable {
    let height, width : Int
    let imageID, imageUrl : String
    
    enum CodingKeys : String, CodingKey {
        case height, width
        case imageID = "id"
        case imageUrl = "url"
    }
    
}

