import SwiftUI

struct HomeFeedView: View {
    @StateObject private var viewModel = HomeFeedViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // App header
                HStack {
                    Text("ChronicConnect")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Post feed
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.posts) { post in
                            PostCardView(post: post)
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}

struct PostCardView: View {
    let post: Post
    @StateObject private var viewModel = PostCardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User info and post time
            HStack {
                // User avatar
                if let profileImage = post.author.profileImage, let uiImage = UIImage(data: profileImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.author.name)
                        .font(.headline)
                    
                    // Illness tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(post.chronicIllnesses as? Set<ChronicIllness> ?? []), id: \.id) { illness in
                                Text("#\(illness.name)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Text(timeAgo(from: post.createdAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Post content
            Text(post.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            // Post media if available
            if let mediaData = post.media, let uiImage = UIImage(data: mediaData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
            }
            
            // Engagement stats
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.likePost(post)
                }) {
                    Label("\(post.likes)", systemImage: viewModel.isLiked ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(viewModel.isLiked ? .red : .gray)
                }
                
                Button(action: {
                    // Show comments
                }) {
                    Label("\(post.comments)", systemImage: "bubble.left")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.checkIfLiked(post)
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}
