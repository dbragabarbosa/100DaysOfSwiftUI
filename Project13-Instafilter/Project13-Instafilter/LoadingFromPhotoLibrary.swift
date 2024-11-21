//
//  LoadingFromPhotoLibrary.swift
//  Project13-Instafilter
//
//  Created by Daniel Braga Barbosa on 21/11/24.
//

import SwiftUI
import PhotosUI

struct LoadingOnePhotoFromPhotoLibrary: View
{
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View
    {
        VStack
        {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
            
            selectedImage?
                .resizable()
                .scaledToFit()
            
            
        }
        .onChange(of: pickerItem)
        {
            Task
            {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
    }
}


struct LoadingFromPhotoLibrary: View
{
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View
    {
        VStack
        {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)]))
            {
                Label("Select a picture", systemImage: "photo")
            }
            
            ScrollView
            {
                ForEach(0..<selectedImages.count, id: \.self)
                { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onChange(of: pickerItems)
        {
            Task
            {
                selectedImages.removeAll()
                
                for item in pickerItems
                {
                    if let loadedImage = try await item.loadTransferable(type: Image.self)
                    {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}


#Preview
{
//    LoadingOnePhotoFromPhotoLibrary()
    LoadingFromPhotoLibrary()
}
