import SwiftUI

struct PostCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PostCreationViewModel()
    @State private var postContent: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text("Share Your Experience")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Post") {
                        viewModel.createPost(content: postContent, image: selectedImage)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(postContent.isEmpty)
                    .foregroundColor(postContent.isEmpty ? .gray : .blue)
                }
                .padding(.horizontal)
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Mood selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How are you feeling today?")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 20) {
                                ForEach(["😊", "😐", "😔", "😣"], id: \.self) { emoji in
                                    Button(action: {
                                        viewModel.selectedMood = emoji
                                    }) {
                                        Text(emoji)
                                            .font(.system(size: 24))
                                            .padding(8)
                                            .background(
                                                Circle()
                                                    .fill(viewModel.selectedMood == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Post content
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What would you like to share today?")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $postContent)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        // Selected image preview
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                        
                        // Tags selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select relevant tags")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.availableIllnesses, id: \.id) { illness in
                                        Button(action: {
                                            viewModel.toggleIllnessSelection(illness)
                                        }) {
                                            Text("#\(illness.name)")
                                                .font(.subheadline)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    viewModel.selectedIllnesses.contains(illness) ?
                                                    Color.blue.opacity(0.2) : Color(.systemGray6)
                                                )
                                                .foregroundColor(
                                                    viewModel.selectedIllnesses.contains(illness) ?
                                                    .blue : .primary
                                                )
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        
                        // Add photo button
                        Button(action: {
                            showImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Add Photo")
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        }
                        
                        // Privacy settings
                        HStack {
                            Text("Privacy")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Picker("", selection: $viewModel.isPrivate) {
                                Text("Public").tag(false)
                                Text("Private").tag(true)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 150)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
        .onAppear {
            viewModel.fetchAvailableIllnesses()
        }
    }
}

// Simple Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PostCreationView_Previews: PreviewProvider {
    static var previews: some View {
        PostCreationView()
    }
}
