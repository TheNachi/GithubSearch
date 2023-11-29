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



struct InformationMessageView: View {
    var imageName: String
    var message: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 67)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
        }
    }
}

struct RepositoryCell: View {
    var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 8) {
                if let ownerAvatarURL = repository.owner?.avatar_url, let url = URL(string: ownerAvatarURL) {
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
                
                RepositoryNameView(repositoryName: repository.full_name)
                
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .frame(width: 10, height: 10)
                    Text("\(repository.stargazers_count)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
                if let language = repository.language {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Text(language)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
            
            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            if let lastUpdated = Date().formattedDateString(from: repository.updated_at) {
                Text("Updated \(lastUpdated) ago")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
    }
}

struct RepositoryNameView: View {
    var repositoryName: String
    
    var body: some View {
        let parts = repositoryName.components(separatedBy: "/")
        if parts.count == 2 {
            return AnyView(
                HStack {
                    Text(parts[0])
                        .font(.system(size: 12))
                        .foregroundColor(.purple)
                        .lineLimit(1)
                    Text("/")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, -6)
                    Text(parts[1])
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.leading, -9)
                }
            )
        } else {
            return AnyView(
                Text(repositoryName)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .lineLimit(1)
            )
        }
    }
}


struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image("searchIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField(placeholder, text: $searchText)
                .font(.system(size: 14))
                .padding(.vertical, 8)
            
            Button(action: action) {
                Text("Search")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.black))
            }
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
    }
}

extension Date {
    func formattedDateString(from dateString: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return "\(year) " + (year == 1 ? "year" : "years")
            } else if let month = components.month, month > 0 {
                return "\(month) " + (month == 1 ? "month" : "months")
            } else if let day = components.day, day > 0 {
                return "\(day) " + (day == 1 ? "day" : "days")
            } else if let hour = components.hour, hour > 0 {
                return "\(hour) " + (hour == 1 ? "hour" : "hours")
            } else if let minute = components.minute, minute > 0 {
                return "\(minute) " + (minute == 1 ? "minute" : "minutes")
            } else if let second = components.second, second > 0 {
                return "\(second) " + (second == 1 ? "second" : "seconds")
            } else {
                return "just now"
            }
        }
        return nil
    }
}

class AlertManager: ObservableObject {
    static let shared = AlertManager()

    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
