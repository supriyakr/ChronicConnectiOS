import Foundation
import CoreData
import UIKit

class PostCreationViewModel: ObservableObject {
    @Published var selectedIllnesses: [ChronicIllness] = []
    @Published var availableIllnesses: [ChronicIllness] = []
    @Published var selectedMood: String = "😊"
    @Published var isPrivate: Bool = false
    
    private let coreDataStack = CoreDataStack.shared
    
    func fetchAvailableIllnesses() {
        let fetchRequest: NSFetchRequest<ChronicIllness> = ChronicIllness.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ChronicIllness.name, ascending: true)]
        
        do {
            availableIllnesses = try coreDataStack.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching illnesses: \(error)")
        }
    }
    
    func toggleIllnessSelection(_ illness: ChronicIllness) {
        if selectedIllnesses.contains(where: { $0.id == illness.id }) {
            selectedIllnesses.removeAll { $0.id == illness.id }
        } else {
            selectedIllnesses.append(illness)
        }
    }
    
    func createPost(content: String, image: UIImage?) {
        guard !content.isEmpty else { return }
        
        // Get the current user (for demo purposes, we'll get the first user)
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.fetchLimit = 1
        
        do {
            let users = try coreDataStack.viewContext.fetch(userFetchRequest)
            guard let currentUser = users.first else {
                print("No user found")
                return
            }
            
            // Create new post
            let post = Post(context: coreDataStack.viewContext)
            post.id = UUID()
            post.content = selectedMood + " " + content
            post.createdAt = Date()
            post.isPrivate = isPrivate
            post.likes = 0
            post.comments = 0
            post.author = currentUser
            
            // Add selected illnesses to post
            post.chronicIllnesses = NSSet(array: selectedIllnesses)
            
            // Add image if available
            if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
                post.media = imageData
            }
            
            // Save to Core Data
            coreDataStack.saveContext()
            
        } catch {
            print("Error creating post: \(error)")
        }
    }
}
