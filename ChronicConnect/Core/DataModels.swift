import Foundation
import CoreData

// MARK: - Base Classes
@objc(User)
public class User: NSManagedObject, Identifiable {
}

@objc(Post)
public class Post: NSManagedObject, Identifiable {
}

@objc(ChronicIllness)
public class ChronicIllness: NSManagedObject, Identifiable {
}

@objc(Comment)
public class Comment: NSManagedObject, Identifiable {
}

@objc(Like)
public class Like: NSManagedObject, Identifiable {
}

// MARK: - User
extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var bio: String?
    @NSManaged public var profileImage: Data?
    @NSManaged public var posts: NSSet
    @NSManaged public var chronicIllnesses: NSSet
    @NSManaged public var comments: NSSet
    @NSManaged public var likes: NSSet
    
    // Posts relationship helpers
    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)
    
    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)
    
    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)
    
    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)
    
    // ChronicIllnesses relationship helpers
    @objc(addChronicIllnessesObject:)
    @NSManaged public func addToChronicIllnesses(_ value: ChronicIllness)
    
    @objc(removeChronicIllnessesObject:)
    @NSManaged public func removeFromChronicIllnesses(_ value: ChronicIllness)
    
    @objc(addChronicIllnesses:)
    @NSManaged public func addToChronicIllnesses(_ values: NSSet)
    
    @objc(removeChronicIllnesses:)
    @NSManaged public func removeFromChronicIllnesses(_ values: NSSet)
    
    // Comments relationship helpers
    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)
    
    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)
    
    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)
    
    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)
    
    // Likes relationship helpers
    @objc(addLikesObject:)
    @NSManaged public func addToLikes(_ value: Like)
    
    @objc(removeLikesObject:)
    @NSManaged public func removeFromLikes(_ value: Like)
    
    @objc(addLikes:)
    @NSManaged public func addToLikes(_ values: NSSet)
    
    @objc(removeLikes:)
    @NSManaged public func removeFromLikes(_ values: NSSet)
}

// MARK: - Post
extension Post {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var media: Data?
    @NSManaged public var isPrivate: Bool
    @NSManaged public var likes: Int16
    @NSManaged public var comments: Int16
    @NSManaged public var author: User
    @NSManaged public var chronicIllnesses: NSSet
    @NSManaged public var commentsList: NSSet
    @NSManaged public var likesList: NSSet
    
    // ChronicIllnesses relationship helpers
    @objc(addChronicIllnessesObject:)
    @NSManaged public func addToChronicIllnesses(_ value: ChronicIllness)
    
    @objc(removeChronicIllnessesObject:)
    @NSManaged public func removeFromChronicIllnesses(_ value: ChronicIllness)
    
    @objc(addChronicIllnesses:)
    @NSManaged public func addToChronicIllnesses(_ values: NSSet)
    
    @objc(removeChronicIllnesses:)
    @NSManaged public func removeFromChronicIllnesses(_ values: NSSet)
    
    // CommentsList relationship helpers
    @objc(addCommentsListObject:)
    @NSManaged public func addToCommentsList(_ value: Comment)
    
    @objc(removeCommentsListObject:)
    @NSManaged public func removeFromCommentsList(_ value: Comment)
    
    @objc(addCommentsList:)
    @NSManaged public func addToCommentsList(_ values: NSSet)
    
    @objc(removeCommentsList:)
    @NSManaged public func removeFromCommentsList(_ values: NSSet)
    
    // LikesList relationship helpers
    @objc(addLikesListObject:)
    @NSManaged public func addToLikesList(_ value: Like)
    
    @objc(removeLikesListObject:)
    @NSManaged public func removeFromLikesList(_ value: Like)
    
    @objc(addLikesList:)
    @NSManaged public func addToLikesList(_ values: NSSet)
    
    @objc(removeLikesList:)
    @NSManaged public func removeFromLikesList(_ values: NSSet)
}

// MARK: - ChronicIllness
extension ChronicIllness {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChronicIllness> {
        return NSFetchRequest<ChronicIllness>(entityName: "ChronicIllness")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var users: NSSet
    @NSManaged public var posts: NSSet
    
    // Users relationship helpers
    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)
    
    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)
    
    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)
    
    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)
    
    // Posts relationship helpers
    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)
    
    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)
    
    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)
    
    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)
}

// MARK: - Comment
extension Comment {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var author: User
    @NSManaged public var post: Post
}

// MARK: - Like
extension Like {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var user: User
    @NSManaged public var post: Post
}

// MARK: - Convenience Extensions
extension User {
    var postsArray: [Post] {
        let set = posts as? Set<Post> ?? []
        return set.sorted { $0.createdAt > $1.createdAt }
    }
    
    var chronicIllnessesArray: [ChronicIllness] {
        let set = chronicIllnesses as? Set<ChronicIllness> ?? []
        return set.sorted { $0.name < $1.name }
    }
}

extension Post {
    var chronicIllnessesArray: [ChronicIllness] {
        let set = chronicIllnesses as? Set<ChronicIllness> ?? []
        return set.sorted { $0.name < $1.name }
    }
    
    var commentsArray: [Comment] {
        let set = commentsList as? Set<Comment> ?? []
        return set.sorted { $0.createdAt > $1.createdAt }
    }
}

extension ChronicIllness {
    var usersArray: [User] {
        let set = users as? Set<User> ?? []
        return set.sorted { $0.name < $1.name }
    }
    
    var postsArray: [Post] {
        let set = posts as? Set<Post> ?? []
        return set.sorted { $0.createdAt > $1.createdAt }
    }
}
