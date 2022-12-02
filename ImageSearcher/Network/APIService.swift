//
//  APIService.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//

import Alamofire
import RxSwift
import RxCocoa

enum URLAddress: String {
    case base = "https://api.giphy.com/v1/gifs/"
    case search = "search?api_key="
    case apiKey = "KZEGYsikekh16bUz5eISfk4w5Gghdays"
}

enum NetworkError: Error {
    case badUrl(message: String)
    case noData(message: String)
    case unknownErr(message: String)
    case error404(message: String)
    case decodingErr(message: String)
}

class APIService {
    static let shared = APIService()
    
    //https://api.giphy.com/v1/gifs/search?api_key=KZEGYsikekh16bUz5eISfk4w5Gghdays&q=moon
    
    private func getQuery(query: String) -> String {
        return "&q=\(query)"
    }
    
    func fetchGifs(query: String) -> Single<[Giphy]> {
        let urlString = URLAddress.base.rawValue + URLAddress.search.rawValue + URLAddress.apiKey.rawValue + getQuery(query: query)
        guard let url = URL(string: urlString) else { return Observable.error(NSError(domain: "Non URL ..", code: 404, userInfo: nil)).asSingle() }
        
        return self.fetchImage(url: url)
    }
    
    func fetchGifs2(query: String) -> Single<GiphyResponse> {
        let urlString = URLAddress.base.rawValue + URLAddress.search.rawValue + URLAddress.apiKey.rawValue + getQuery(query: query)
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedUrlString) else { return Observable.error(NSError(domain: "Non URL ..", code: 404, userInfo: nil)).asSingle() }
        
        return fetchImage2(url: url)
    }
    
    private func fetchImage(url: URL) -> Single<[Giphy]> {
        return Single<[Giphy]>.create { single in
            let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: GiphyResponse.self) { response in
                switch response.result {
                case .success(let data):
                    guard let giphy = data.data else { return }
                    single(.success(giphy))
                case .failure(let error):
                    print("err: \(error)")
                    single(.failure(NetworkError.error404(message: "\(error)")))
                }
            }
            return Disposables.create() {
                request.cancel()
            }
        }
    }
    
    private func fetchImage2<T: Decodable>(url: URL) -> Single<T> {
        return Single<T>.create { single in
            let request = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseData { response in
                switch response.result {
                case .success(let jsonData):
                    do {
                        let giphy = try JSONDecoder().decode(T.self, from: jsonData)
                        single(.success(giphy))
                    } catch let error {
                        print(NetworkError.decodingErr(message: "\(error.localizedDescription)"))
                        single(.failure(error))
                    }
                case .failure(let error):
                    print(NetworkError.noData(message: "\(error)"))
                }
            }
            return Disposables.create() {
                request.cancel()
            }
        }
    }
}
