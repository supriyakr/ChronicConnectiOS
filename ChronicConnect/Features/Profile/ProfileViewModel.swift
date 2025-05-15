import Foundation
import CoreData
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var userPosts: [Post] = []
    
    private let coreDataStack = CoreDataStack.shared
    
    func fetchUserProfile() {
        // For demo purposes, we'll get the first user
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let users = try coreDataStack.viewContext.fetch(fetchRequest)
            if let user = users.first {
                self.user = user
            }
        } catch {
            print("Error fetching user profile: \(error)")
        }
    }
    
    func fetchUserPosts() {
        guard let user = user else { return }
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author == %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Post.createdAt, ascending: false)]
        
        do {
            userPosts = try coreDataStack.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching user posts: \(error)")
        }
    }
}
