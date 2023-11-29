//
//  UserViewModel.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var selectedUser: User?
    @Published var userDetailViewModel = UserDetailViewModel()
    @Published var isUserDetailActive: Bool = false
    
    func findUsers() {
        if username.count < 3 {
            return
        }
        
        isLoading = true
        GitHubAPIManager.shared.searchUsers(query: username) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let users):
                    self.users = users
                case .failure(let error):
                    print("Error searching users: \(error)")
                }
            }
        }
    }
    
    func getUserDetails() {
        if let selectedUser = selectedUser, let url = URL(string: selectedUser.url) {
            GitHubAPIManager.shared.getUserDetails(url: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.selectedUser = user
                        self.userDetailViewModel = UserDetailViewModel(user: user)
                        self.isUserDetailActive = true
                    case .failure(let error):
                        print("Error fetching user details: \(error)")
                    }
                }
            }
        }
    }
}
