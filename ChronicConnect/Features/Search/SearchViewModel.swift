import Foundation
import CoreData
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [SearchResult] = []
    @Published var recentSearches: [String] = []
    @Published var trendingTags: [ChronicIllness] = []
    @Published var filterOption: FilterOption = .mostRecent
    
    private let coreDataStack = CoreDataStack.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum FilterOption: String, CaseIterable, Identifiable {
        case mostRecent = "Most Recent"
        case mostRelevant = "Most Relevant"
        case mostSupported = "Most Supported"
        
        var id: String { self.rawValue }
    }
    
    init() {
        // Load recent searches from UserDefaults
        recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        
        // Set up search text publisher with debounce
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] searchTerm in
                self?.performSearch(searchTerm: searchTerm)
            }
            .store(in: &cancellables)
        
        fetchTrendingTags()
    }
    
    func performSearch(searchTerm: String) {
        guard !searchTerm.isEmpty else {
            searchResults = []
            return
        }
        
        // Add to recent searches if not already there
        if !recentSearches.contains(searchTerm) {
            recentSearches.insert(searchTerm, at: 0)
            // Keep only the 5 most recent searches
            if recentSearches.count > 5 {
                recentSearches = Array(recentSearches.prefix(5))
            }
            // Save to UserDefaults
            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        }
        
        // Search for posts
        let postResults = searchPosts(matching: searchTerm)
        
        // Search for users
        let userResults = searchUsers(matching: searchTerm)
        
        // Search for chronic illnesses
        let illnessResults = searchChronicIllnesses(matching: searchTerm)
        
        // Combine and sort results
        var combinedResults = postResults + userResults + illnessResults
        
        // Apply filter
        switch filterOption {
        case .mostRecent:
            combinedResults.sort { $0.date > $1.date }
        case .mostRelevant:
            // For relevance, we could implement a scoring system based on how well the content matches
            // For now, we'll just prioritize exact matches in the title/content
            combinedResults.sort { result1, result2 in
                let exactMatch1 = result1.title.lowercased().contains(searchTerm.lowercased()) || 
                                 (result1.content?.lowercased().contains(searchTerm.lowercased()) ?? false)
                let exactMatch2 = result2.title.lowercased().contains(searchTerm.lowercased()) || 
                                 (result2.content?.lowercased().contains(searchTerm.lowercased()) ?? false)
                
                if exactMatch1 && !exactMatch2 {
                    return true
                } else if !exactMatch1 && exactMatch2 {
                    return false
                } else {
                    return result1.date > result2.date
                }
            }
        case .mostSupported:
            // Sort by likes/support count
            combinedResults.sort { $0.supportCount > $1.supportCount }
        }
        
        searchResults = combinedResults
    }
    
    private func searchPosts(matching searchTerm: String) -> [SearchResult] {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        // Search in post content
        let contentPredicate = NSPredicate(format: "content CONTAINS[cd] %@", searchTerm)
        
        // Also search in associated chronic illnesses
        let illnessPredicate = NSPredicate(format: "ANY chronicIllnesses.name CONTAINS[cd] %@", searchTerm)
        
        // Combine predicates with OR
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [contentPredicate, illnessPredicate])
        
        do {
            let posts = try coreDataStack.viewContext.fetch(fetchRequest)
            return posts.map { post in
                return SearchResult(
                    id: post.id,
                    type: .post,
                    title: post.author.name,
                    content: post.content,
                    date: post.createdAt,
                    supportCount: Int(post.likes),
                    tags: post.chronicIllnessesArray.map { $0.name },
                    associatedObject: post
                )
            }
        } catch {
            print("Error searching posts: \(error)")
            return []
        }
    }
    
    private func searchUsers(matching searchTerm: String) -> [SearchResult] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        // Search in user name and bio
        let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchTerm)
        let bioPredicate = NSPredicate(format: "bio CONTAINS[cd] %@", searchTerm)
        
        // Also search in associated chronic illnesses
        let illnessPredicate = NSPredicate(format: "ANY chronicIllnesses.name CONTAINS[cd] %@", searchTerm)
        
        // Combine predicates with OR
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, bioPredicate, illnessPredicate])
        
        do {
            let users = try coreDataStack.viewContext.fetch(fetchRequest)
            return users.map { user in
                return SearchResult(
                    id: user.id,
                    type: .user,
                    title: user.name,
                    content: user.bio,
                    date: Date(), // Users don't have a creation date, using current date as fallback
                    supportCount: user.postsArray.reduce(0) { $0 + Int($1.likes) },
                    tags: user.chronicIllnessesArray.map { $0.name },
                    associatedObject: user
                )
            }
        } catch {
            print("Error searching users: \(error)")
            return []
        }
    }
    
    private func searchChronicIllnesses(matching searchTerm: String) -> [SearchResult] {
        let fetchRequest: NSFetchRequest<ChronicIllness> = ChronicIllness.fetchRequest()
        
        // Search in illness name
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchTerm)
        
        do {
            let illnesses = try coreDataStack.viewContext.fetch(fetchRequest)
            return illnesses.map { illness in
                return SearchResult(
                    id: illness.id,
                    type: .chronicIllness,
                    title: illness.name,
                    content: nil,
                    date: Date(), // Illnesses don't have a creation date, using current date as fallback
                    supportCount: illness.postsArray.count,
                    tags: [illness.name],
                    associatedObject: illness
                )
            }
        } catch {
            print("Error searching chronic illnesses: \(error)")
            return []
        }
    }
    
    func fetchTrendingTags() {
        let fetchRequest: NSFetchRequest<ChronicIllness> = ChronicIllness.fetchRequest()
        
        do {
            let allIllnesses = try coreDataStack.viewContext.fetch(fetchRequest)
            
            // Sort by number of associated posts (popularity)
            let sortedIllnesses = allIllnesses.sorted { illness1, illness2 in
                return illness1.postsArray.count > illness2.postsArray.count
            }
            
            // Take top 5 or fewer
            trendingTags = Array(sortedIllnesses.prefix(5))
        } catch {
            print("Error fetching trending tags: \(error)")
        }
    }
    
    func clearRecentSearch(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        }
    }
    
    func clearAllRecentSearches() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentSearches")
    }
}

// Search result model to unify different types of search results
struct SearchResult: Identifiable {
    let id: UUID
    let type: SearchResultType
    let title: String
    let content: String?
    let date: Date
    let supportCount: Int
    let tags: [String]
    let associatedObject: Any
    
    enum SearchResultType {
        case post
        case user
        case chronicIllness
    }
}
