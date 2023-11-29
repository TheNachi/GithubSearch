//
//  UserDetailViewModel.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import Foundation

class UserDetailViewModel: ObservableObject {
    @Published var user: User?
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    var alertMessage: String = ""

    init(user: User) {
        self.user = user
    }
    
    init() {
    }
    
    func loadRepositories(url: String) {
        isLoading = true
        GitHubAPIManager.shared.getRepositories(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repos):
                    self.repositories = repos
                case .failure(let error):
                    print("Error loading repositories: \(error)")
                    self.alertMessage = "Failed to fetch repositories.: \(error)"
                    self.showAlert = true
                }
                self.isLoading = false
            }
        }
    }
}
