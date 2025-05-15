import Foundation
import CoreData
import Combine

class HomeFeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let coreDataStack = CoreDataStack.shared
    
    func fetchPosts() {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Post.createdAt, ascending: false)]
        
        do {
            posts = try coreDataStack.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
}

class PostCardViewModel: ObservableObject {
    @Published var isLiked = false
    private let coreDataStack = CoreDataStack.shared
    
    func checkIfLiked(_ post: Post) {
        // In a real app, you would check if the current user has liked this post
        // For demo purposes, we'll just set a random value
        isLiked = Bool.random()
    }
    
    func likePost(_ post: Post) {
        if isLiked {
            // Unlike post
            post.likes = max(0, post.likes - 1)
        } else {
            // Like post
            post.likes += 1
        }
        
        isLiked.toggle()
        coreDataStack.saveContext()
    }
}

// Note: Post and ChronicIllness already conform to Identifiable in DataModels.swift
