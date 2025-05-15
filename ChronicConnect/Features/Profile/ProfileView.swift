import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Back button and settings
                    HStack {
                        Button(action: {
                            // Go back
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Text("Profile")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            // Open settings
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Profile header
                    VStack(alignment: .center, spacing: 12) {
                        // Profile image
                        if let profileImage = viewModel.user?.profileImage, let uiImage = UIImage(data: profileImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        // User name and bio
                        Text(viewModel.user?.name ?? "User Name")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.user?.bio ?? "Living life one day at a time")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("Edit Profile") {
                            // Edit profile action
                        }
                        .font(.footnote)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    
                    // Stats
                    HStack(spacing: 0) {
                        Spacer()
                        
                        VStack {
                            Text("\(viewModel.userPosts.count)")
                                .font(.headline)
                            Text("Posts")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80)
                        
                        Spacer()
                        
                        VStack {
                            Text("2.4k")
                                .font(.headline)
                            Text("Supporters")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80)
                        
                        Spacer()
                        
                        VStack {
                            Text("892")
                                .font(.headline)
                            Text("Supporting")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    // Conditions section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Conditions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(viewModel.user?.chronicIllnesses as? Set<ChronicIllness> ?? []), id: \.id) { illness in
                                    Text("#\(illness.name)")
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .cornerRadius(16)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Posts section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Posts")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ForEach(viewModel.userPosts) { post in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.content)
                                    .font(.body)
                                    .padding(.horizontal)
                                
                                // Post media if available
                                if let mediaData = post.media, let uiImage = UIImage(data: mediaData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 150)
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                }
                                
                                HStack {
                                    Label("\(post.likes)", systemImage: "heart")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(timeAgo(from: post.createdAt))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6).opacity(0.5))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchUserProfile()
                viewModel.fetchUserPosts()
            }
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
