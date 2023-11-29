//
//  UserDetailView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/28/23.
//

import SwiftUI


struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: UserDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                if let ownerAvatarURL = viewModel.user?.avatar_url, let url = URL(string: ownerAvatarURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
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
                
                VStack(alignment: .leading) {
                    Text(viewModel.user?.name ?? "")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(viewModel.user?.login ?? "")
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text(viewModel.user?.bio ?? "NO BIO")
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                if let location = viewModel.user?.location {
                    Image("locationIcon")
                        .frame(width: 10, height: 10)
                    Text(location)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                        .lineLimit(1)
                }
                
                if !(viewModel.user?.blog ?? "").isEmpty {
                    Image("linkIcon")
                        .frame(width: 10, height: 10)
                    Text(viewModel.user?.blog ?? "")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                Image("peopleIcon")
                    .frame(width: 10, height: 10)
                Text("\(viewModel.user?.followers ?? 0) followers   .")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                Text("\(viewModel.user?.following ?? 0) following")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
            
            Text("Repositories  \(viewModel.repositories.count)")
                .font(.system(size: 10))
                .fontWeight(.semibold)
            
            Divider()
            
            Spacer()
            
            if !viewModel.repositories.isEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.repositories, id: \.id) { repo in
                        RepositoryCell(repository: repo)
                        
                    }
                }
            }
            
            if viewModel.repositories.isEmpty {
                InformationMessageView(imageName: "noRepoIcon", message: "This user  doesn’t have repositories yet, come back later :-)")
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding(.horizontal, 20)
        .onAppear {
            if let reposURL = viewModel.user?.repos_url {
                viewModel.loadRepositories(url: reposURL)
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
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Users")
            }
        }
    }
}
