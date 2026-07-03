//
//  PhotoPickerStep.swift
//  ParentsMap
//
//  Created by Mariia on 30/6/2026.
//

import SwiftUI
import PhotosUI

struct PhotoPickerStep: View {
    @Binding var selectedImages: [UIImage]
    @State private var photoPickerItems: [PhotosPickerItem] = []
    @State private var showCamera = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add photos")
                .font(.quicksand(.bold, size: 18))
                .foregroundColor(Color(.brandBrown))
            
            Text(selectedImages.isEmpty
                 ? "Add photos of the facility. You can always add more later."
                 : "Add photos of the facility.")
                .font(.quicksand(.medium, size: 13))
                .foregroundColor(Color(.brandBrown).opacity(0.6))
            
            if selectedImages.isEmpty {
                PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 6, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add photos")
                            .font(.quicksand(.semiBold, size: 16))
                    }
                    .foregroundColor(Color(.brandBrown))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                
                Button {
                    showCamera = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera")
                        Text("Take new photos")
                            .font(.quicksand(.semiBold, size: 16))
                    }
                    .foregroundColor(Color(.brandBrown))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            } else {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            Button {
                                selectedImages.remove(at: index)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(.brandBrown))
                                    .frame(width: 26, height: 26)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding(6)
                        }
                    }
                    
                    if selectedImages.count < 6 {
                        PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 6 - selectedImages.count, matching: .images) {
                            VStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                Text("Add more")
                                    .font(.quicksand(.medium, size: 13))
                            }
                            .foregroundColor(Color(.brandBrown).opacity(0.6))
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                    }
                }
            }
        }
        .onChange(of: photoPickerItems) { _, newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }
                }
                photoPickerItems = []
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraCaptureView { image in
                if let image = image {
                    selectedImages.append(image)
                }
            }
        }
    }
}

struct CameraCaptureView: UIViewControllerRepresentable {
    let onCapture: (UIImage?) -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraCaptureView
        init(_ parent: CameraCaptureView) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            parent.onCapture(image)
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
