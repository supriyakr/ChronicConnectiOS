import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showClearButton = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.gray)
                            .padding(.leading)
                    }
                    
                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Search posts, conditions, or keywords...", text: $viewModel.searchText)
                            .onChange(of: viewModel.searchText) { newValue in
                                showClearButton = !newValue.isEmpty
                            }
                        
                        if showClearButton {
                            Button(action: {
                                viewModel.searchText = ""
                                showClearButton = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                }
                .padding(.vertical, 8)
                .padding(.trailing)
                
                // Filter options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(SearchViewModel.FilterOption.allCases) { option in
                            FilterButton(
                                title: option.rawValue,
                                isSelected: viewModel.filterOption == option
                            ) {
                                viewModel.filterOption = option
                                if !viewModel.searchText.isEmpty {
                                    viewModel.performSearch(searchTerm: viewModel.searchText)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Content
                if viewModel.searchText.isEmpty {
                    emptySearchView
                } else if viewModel.searchResults.isEmpty {
                    noResultsView
                } else {
                    searchResultsView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // View when search field is empty
    private var emptySearchView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Trending tags section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Trending Tags")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.trendingTags) { illness in
                                Button(action: {
                                    viewModel.searchText = illness.name
                                    viewModel.performSearch(searchTerm: illness.name)
                                }) {
                                    Text("#\(illness.name)")
                                        .foregroundColor(tagColor(for: illness.name))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(tagColor(for: illness.name).opacity(0.1))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Recent searches section
                if !viewModel.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Searches")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.recentSearches, id: \.self) { search in
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.gray)
                                
                                Text(search)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.clearRecentSearch(search)
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.searchText = search
                                viewModel.performSearch(searchTerm: search)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .padding(.top)
        }
    }
    
    // View when search has no results
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No results found")
                .font(.headline)
            
            Text("Try different keywords or check for typos")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // View when search has results
    private var searchResultsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchResults) { result in
                    SearchResultCard(result: result)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    // Helper function to get a consistent color for each tag
    private func tagColor(for tag: String) -> Color {
        let colors: [Color] = [.blue, .purple, .pink, .green, .orange, .red]
        let index = abs(tag.hashValue) % colors.count
        return colors[index]
    }
}

// Filter button component
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .primary : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color(.systemBackground) : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// Search result card component
struct SearchResultCard: View {
    let result: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with user info
            HStack {
                // Profile image placeholder
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.title)
                        .font(.headline)
                    
                    // Time ago
                    Text(timeAgo(from: result.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Content
            if let content = result.content {
                Text(content)
                    .font(.body)
                    .lineLimit(3)
            }
            
            // Tags
            if !result.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(result.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(tagColor(for: tag))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(tagColor(for: tag).opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            
            // Interaction stats
            HStack {
                Label("\(result.supportCount)", systemImage: "heart")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if result.type == .post, let post = result.associatedObject as? Post {
                    Label("\(post.comments)", systemImage: "bubble.left")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Helper function to get a consistent color for each tag
    private func tagColor(for tag: String) -> Color {
        let colors: [Color] = [.blue, .purple, .pink, .green, .orange, .red]
        let index = abs(tag.hashValue) % colors.count
        return colors[index]
    }
    
    // Helper function to format date as time ago
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
