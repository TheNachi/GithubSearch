//
//  UserView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct UsersView: View {
    @StateObject var viewModel = UserViewModel()
    
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


struct UserCell: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                if let url = URL(string: user.avatar_url) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        case .failure(_):
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    EmptyView()
                }
                
                Text(user.login)
                    .font(.system(size: 12))
                    .lineLimit(1)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
    }
}
