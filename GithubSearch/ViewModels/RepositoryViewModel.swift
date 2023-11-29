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
    @Published var showAlert: Bool = false
    var alertMessage: String = ""
    
    func searchRepositories() {
        if searchText.count < 3 {
            DispatchQueue.main.async {
                self.alertMessage = "Search input has to be more than 2 characters"
                self.showAlert = true

            }
            return
        }
        
        isLoading = true
        GitHubAPIManager.shared.searchRepositories(query: searchText) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let repositories):
                    DispatchQueue.main.async {
                        self.repositories = repositories
                    }
                case .failure(let error):
                    print("Error searching users: \(error)")
                    self.alertMessage = "Failed to fetch repositories.: \(error)"
                    self.showAlert = true
                }
            }
        }
    }
}
