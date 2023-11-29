//
//  RepositoryView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct RepositoryView: View {
    @StateObject var viewModel = RepositoryViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Repositories")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                
                SearchBarView(searchText: $viewModel.searchText,
                              placeholder: "Search for repositories...",
                              action: viewModel.searchRepositories)
                
                if viewModel.isLoading {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.repositories, id: \.id) { repo in
                            RepositoryCell(repository: repo)
                        }
                    }
                }
                
                Spacer()
            }
            
            if viewModel.repositories.isEmpty && !viewModel.isLoading {
                InformationMessageView(imageName: "searchImage", message: "Search Github for repositories, issues and pull requests!")
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .navigationBarHidden(true)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { _ in
                if viewModel.searchText.count < 3 && viewModel.repositories.count > 0 {
                    viewModel.repositories.removeAll()
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
