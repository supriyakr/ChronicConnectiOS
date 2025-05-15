import Foundation
import CoreData

struct DataGenerator {
    static func generateSampleData(in context: NSManagedObjectContext) {
        // Create sample chronic illnesses
        let chronicIllnesses = [
            "Diabetes",
            "Arthritis",
            "Asthma",
            "Fibromyalgia",
            "Multiple Sclerosis",
            "Chronic Fatigue",
            "Lupus"
        ]
        
        // Create sample users
        let users = [
            (name: "Sarah Mitchell", bio: "Living with diabetes for 10 years. Here to support and learn.", illnesses: ["Diabetes", "Asthma"]),
            (name: "Michael Brown", bio: "MS warrior. Finding strength in community.", illnesses: ["Multiple Sclerosis"]),
            (name: "Emma Wilson", bio: "Arthritis fighter. Advocating for chronic illness awareness.", illnesses: ["Arthritis", "Fibromyalgia"]),
            (name: "David Kim", bio: "Managing asthma and diabetes. Sharing my journey.", illnesses: ["Diabetes", "Asthma"])
        ]
        
        // Create illness entities
        var illnessEntities: [String: ChronicIllness] = [:]
        for illnessName in chronicIllnesses {
            let illness = ChronicIllness(context: context)
            illness.id = UUID()
            illness.name = illnessName
            illnessEntities[illnessName] = illness
        }
        
        // Create user entities
        var userEntities: [User] = []
        for user in users {
            let userEntity = User(context: context)
            userEntity.id = UUID()
            userEntity.name = user.name
            userEntity.bio = user.bio
            
            // Create sample posts for each user
            for i in 0..<3 {
                let post = Post(context: context)
                post.id = UUID()
                
                // Create realistic content based on the user's illnesses
                let contents = [
                    "Finally found a routine that helps manage my morning stiffness. Starting the day with gentle stretches has been a game changer! 💪",
                    "Remember to rest when your body needs it. Pushing through isn't always the answer.",
                    "Today's small win: Made it through a full grocery shopping trip! Anyone else celebrate these little victories? 🎉",
                    "New medication day 5: Starting to notice some improvements in my symptoms. Cautiously optimistic!",
                    "Bad flare day today. Sending strength to everyone else struggling right now. We've got this. ❤️",
                    "Just discovered a great app for tracking symptoms. Happy to share details if anyone's interested!",
                    "Had a doctor who actually listened today. It shouldn't feel this rare, but I'm grateful."
                ]
                
                post.content = contents[Int.random(in: 0..<contents.count)]
                post.createdAt = Date().addingTimeInterval(-Double.random(in: 0...30) * 86400) // Random dates in last 30 days
                post.isPrivate = Bool.random()
                post.likes = Int16.random(in: 0...50)
                post.comments = Int16.random(in: 0...20)
                post.author = userEntity
                
                // Add random chronic illnesses to the post
                let userIllnesses = user.illnesses.map { illnessEntities[$0]! }
                post.chronicIllnesses = NSSet(array: userIllnesses)
                
                // Add comments to the post
                for _ in 0..<Int(post.comments) {
                    let comment = Comment(context: context)
                    comment.id = UUID()
                    
                    let commentContents = [
                        "Thanks for sharing this!",
                        "I've experienced the same thing.",
                        "Have you tried talking to your doctor about this?",
                        "This is so helpful, thank you!",
                        "Sending support your way ❤️",
                        "I'd love to hear more about your experience with this."
                    ]
                    
                    comment.content = commentContents[Int.random(in: 0..<commentContents.count)]
                    comment.createdAt = Date().addingTimeInterval(-Double.random(in: 0...7) * 86400) // Random dates in last 7 days
                    
                    // Random commenter from other users
                    let otherUsers = users.filter { $0.name != user.name }
                    let randomUserName = otherUsers[Int.random(in: 0..<otherUsers.count)].name
                    let commenter = userEntities.first { $0.name == randomUserName } ?? userEntity
                    
                    comment.author = commenter
                    comment.post = post
                }
            }
            
            // Add chronic illnesses to user
            userEntity.chronicIllnesses = NSSet(array: user.illnesses.map { illnessEntities[$0]! })
            userEntities.append(userEntity)
        }
        
        // Create likes between users and posts
        for user in userEntities {
            // Get posts from other users
            let otherPosts = userEntities
                .filter { $0.id != user.id }
                .flatMap { $0.posts.allObjects as! [Post] }
            
            for post in otherPosts {
                if Bool.random() {
                    let like = Like(context: context)
                    like.id = UUID()
                    like.createdAt = Date().addingTimeInterval(-Double.random(in: 0...7) * 86400)
                    like.user = user
                    like.post = post
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving sample data: \(error)")
        }
    }
}

extension Array {
    func randomSubset(of count: Int) -> [Element] {
        guard count <= self.count else { return self }
        var result = [Element]()
        var indices = Array<Int>(0..<self.count)
        
        for _ in 0..<count {
            let randomIndex = Int.random(in: 0..<indices.count)
            result.append(self[indices[randomIndex]])
            indices.remove(at: randomIndex)
        }
        
        return result
    }
}
