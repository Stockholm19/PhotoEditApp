//
//  ProfileView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 06.05.2025.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct PhotoEditorView: View {
    let userEmail: String
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var finalRotation: Angle = .zero
    
    @State private var textOverlay: String = ""
    @State private var textPosition = CGSize.zero
    
    @State private var showSaveAlert = false
    
    @State private var showDrawingCanvas = false
    
    @AppStorage("profileImageData") private var profileImageBase64: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imageCanvas
                textInputField
                
                VStack(spacing: 12) {
                    resetButton
                    uploadButton
                    deleteButton
                    drawingToggleButton
                    drawingCanvas
                    saveButton
                }
                .frame(maxWidth: 300)
                
                header
                emailText
                signOutButton
            }
            .padding()
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        profileImageBase64 = data.base64EncodedString()
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

private extension PhotoEditorView {
    var header: some View {
        Text("PhotoEditApp")
            .font(.largeTitle)
            .bold()
    }
    
    var resetButton: some View {
        Button("Сбросить изменения") {
            currentScale = 1.0
            finalScale = 1.0
            currentRotation = .zero
            finalRotation = .zero
            textPosition = .zero
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    var emailText: some View {
        Text("Email: \(userEmail)")
            .font(.caption)
            .foregroundColor(.gray)
    }

    var signOutButton: some View {
        Button("Выйти") {
            do {
                try Auth.auth().signOut()
                authViewModel.user = nil
            } catch {
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    var imageCanvas: some View {
        ZStack {
            editableImage
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .background(Color.white)
    }
    
    var drawingToggleButton: some View {
        Button("Рисование") {
            showDrawingCanvas.toggle()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    var drawingCanvas: some View {
        Group {
            if showDrawingCanvas {
                DrawingCanvasView(wrapper: CanvasViewWrapper())
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
        }
    }
    
    var editableImage: some View {
        Group {
            if let data = profileImageData,
               let uiImage = UIImage(data: data) {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .shadow(radius: 5)
                        .scaleEffect(currentScale * finalScale)
                        .rotationEffect(currentRotation + finalRotation)

                    Text(textOverlay)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(4)
                        .shadow(radius: 3)
                        .offset(textPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    textPosition = value.translation
                                }
                        )
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentScale = value
                        }
                        .onEnded { value in
                            finalScale *= value
                            currentScale = 1.0
                        }
                        .simultaneously(with:
                            RotationGesture()
                                .onChanged { angle in
                                    currentRotation = angle
                                }
                                .onEnded { angle in
                                    finalRotation += angle
                                    currentRotation = .zero
                                }
                        )
                )
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var textInputField: some View {
        TextField("Введите текст", text: $textOverlay)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    var uploadButton: some View {
        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()) {
            Text("Выбрать изображение")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    var deleteButton: some View {
        Button("Удалить изображение") {
            profileImageBase64 = ""
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(10)
    }
    var saveButton: some View {
        Button("Сохранить изображение") {
                let snapshot = editableImage.snapshot()
                UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil)
                showSaveAlert = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert("✅ Сохранено", isPresented: $showSaveAlert) {
                Button("ОК", role: .cancel) { }
            }
    }
    
    private var profileImageData: Data? {
        Data(base64Encoded: profileImageBase64)
    }
}

#Preview {
    PhotoEditorView(userEmail: "preview@example.com")
        .environmentObject(AuthViewModel())
}
    
