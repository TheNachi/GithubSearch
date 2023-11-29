//
//  GitHubAPIManager.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import Foundation
import SwiftUI

class GitHubAPIManager {
    static let shared = GitHubAPIManager()

    enum APIError: Error {
        case invalidURL
        case decodingError
        case networkError(Error)
    }

    // MARK: - Search Repositories

    func searchRepositories(query: String, page: Int = 1, completion: @escaping (Result<[Repository], APIError>) -> Void) {
        let endpoint = "/search/repositories"
        let parameters = ["q": query, "page": "\(page)", "per_page": APIConstants.perPage]

        performRequest(endpoint: endpoint, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let repositories = try JSONDecoder().decode(SearchResult<Repository>.self, from: data)
                    completion(.success(repositories.items))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Search Users

    func searchUsers(query: String, page: Int = 1, completion: @escaping (Result<[User], APIError>) -> Void) {
        let endpoint = "/search/users"
        let parameters = ["q": query, "page": "\(page)", "per_page": APIConstants.perPage]

        performRequest(endpoint: endpoint, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let users = try JSONDecoder().decode(SearchResult<User>.self, from: data)
                    completion(.success(users.items))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Get User Details

    func getUserDetails(url: URL, completion: @escaping (Result<User, APIError>) -> Void) {
        performRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    print("Error fetching user details: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get Repositories

    func getRepositories(url: String, completion: @escaping (Result<[Repository], APIError>) -> Void) {
        guard let reposURL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        performRequest(url: reposURL) { result in
            switch result {
            case .success(let data):
                do {
                    let repositories = try JSONDecoder().decode([Repository].self, from: data)
                    completion(.success(repositories))
                } catch {
                    print("Error decoding repositories: \(error)")
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private Methods

    private func performRequest(endpoint: String, parameters: [String: String], completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = makeURL(endpoint: endpoint, parameters: parameters) else {
            completion(.failure(.invalidURL))
            return
        }

        performRequest(url: url, completion: completion)
    }

    private func performRequest(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        setupCommonHeaders(for: &request)

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else if let data = data {
                completion(.success(data))
            }
        }.resume()
    }

    private func makeURL(endpoint: String, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: APIConstants.baseURL + endpoint)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents?.url
    }

    private func setupCommonHeaders(for request: inout URLRequest) {
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
    }
}

struct SearchResult<T: Codable>: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [T]
}


struct APIConstants {
    static let baseURL = "https://api.github.com"
    static let perPage = "100"
}
