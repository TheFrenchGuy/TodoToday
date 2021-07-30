//
//  ImagePicker.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 30/07/2021.
//

import UIKit
import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    
   
    typealias UIViewControllerType = PHPickerViewController
    
    var didFinishPicking: (_ didSelectItems: Bool) -> Void
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
//        config.filter = .any(of: [.images, .videos, .livePhotos])
        config.filter = .any(of: [.images])
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
        
       
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(with: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        var photoPicker: ImagePickerView
        
        init(with photoPicker: ImagePickerView) {
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            photoPicker.didFinishPicking(!results.isEmpty)
            
            guard !results.isEmpty else {
                return
            }
            
            for result in results {
                let itemProvider = result.itemProvider
                
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                      let utType = UTType(typeIdentifier)
                else { continue }
                
                if utType.conforms(to: .image) {
                    self.getPhoto(from: itemProvider, isLivePhoto: false)
                }
//                else if utType.conforms(to: .movie) {
//                    self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
//                } else {
//                    self.getPhoto(from: itemProvider, isLivePhoto: true)
//                }
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool) {
            let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
            
            if itemProvider.canLoadObject(ofClass: objectType) {
                itemProvider.loadObject(ofClass: objectType) { object, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if !isLivePhoto {
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                self.photoPicker.selectedImage = image
                            }
                        }
                    }
//                    else {
//                        if let livePhoto = object as? PHLivePhoto {
//                            DispatchQueue.main.async {
//                               // self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: livePhoto))
//                                print("To be later implemented")
//                            }
//                        }
//                    }
                }
            }
        }
        
        
        private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let url = url else { return }
                
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
                
                do {
                    if FileManager.default.fileExists(atPath: targetURL.path) {
                        try FileManager.default.removeItem(at: targetURL)
                    }
                    
                    try FileManager.default.copyItem(at: url, to: targetURL)
                    
                    DispatchQueue.main.async {
//                        self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: targetURL))
                         print("To be later implemented")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    

}

struct PhotoPicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

