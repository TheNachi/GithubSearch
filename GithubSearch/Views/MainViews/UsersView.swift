//
//  UserView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Users")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                    
                    SearchBarView(searchText: $viewModel.username,
                                  placeholder: "Search for users...",
                                  action: viewModel.findUsers)
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.users, id: \.id) { user in
                                UserCell(user: user)
                                    .onTapGesture {
                                        viewModel.selectedUser = user
                                        viewModel.getUserDetails()
                                    }
                            }
                        }
                        .background(
                            NavigationLink(
                                destination: UserDetailView(viewModel: viewModel.userDetailViewModel),
                                isActive: $viewModel.isUserDetailActive
                            ) {
                                EmptyView()
                            }
                                .hidden()
                        )
                    }
                    
                    Spacer()
                }
                
                if viewModel.users.isEmpty && !viewModel.isLoading {
                    InformationMessageView(imageName: "searchImage", message: "Search Github for users...")
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            .navigationBarHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) { _ in
                    if viewModel.username.count < 3 && viewModel.users.count > 0 {
                        viewModel.users.removeAll()
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
}
