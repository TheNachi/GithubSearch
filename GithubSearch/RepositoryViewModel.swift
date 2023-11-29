//
//  RepositoryViewModel.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import Foundation

class RepositoryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false

    func searchRepositories() {
        if searchText.count < 3 {
            return
        }
        
        isLoading = true
        GitHubAPIManager.shared.searchRepositories(query: searchText) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let repositories):
                    self.repositories = repositories
                case .failure(let error):
                    print("Error searching users: \(error)")
                }
            }
        }
    }
}
