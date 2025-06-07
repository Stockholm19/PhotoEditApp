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
    @StateObject private var canvasWrapper = CanvasViewWrapper()
    
    @AppStorage("profileImageData") private var profileImageBase64: String = ""
    @State private var originalImageData: Data? = nil
    
    @State private var currentFilter: ImageFilterType? = nil
    
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?


    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                imageCanvas
                textInputField
                editingSection
                imageSection
                infoSection
            }
            .padding()
            .task(id: selectedItem) {
                handleImageSelection(selectedItem)
            }
            .sheet(isPresented: $showShareSheet, content: shareSheet)
            .alert("✅ Сохранено", isPresented: $showSaveAlert) {
                Button("ОК", role: .cancel) { }
            }
            .toolbar { toolbarMenu }
        }
    }
}

// MARK: - Logic
private extension PhotoEditorView {
    
    func handleImageSelection(_ newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                profileImageBase64 = data.base64EncodedString()
                originalImageData = data
                currentFilter = nil
            }
        }
    }

    func shareSheet() -> some View {
        Group {
            if let image = imageToShare {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    var toolbarMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    let base = editableImage.snapshot().resize(to: CGSize(width: 300, height: 300))
                    if let combined = canvasWrapper.renderedImage(size: base.size, base: base) {
                        UIImageWriteToSavedPhotosAlbum(combined, nil, nil, nil)
                        showSaveAlert = true
                    }
                } label: {
                    Label("Сохранить изображение", systemImage: "square.and.arrow.down")
                }

                Button {
                    let base = editableImage.snapshot().resize(to: CGSize(width: 300, height: 300))
                    if let finalImage = canvasWrapper.renderedImage(size: base.size, base: base) {
                        imageToShare = finalImage
                        showShareSheet = true
                    }
                } label: {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }

            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
    }
}

enum ImageFilterType {
    case sepia, mono, blur
}

struct FilterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// MARK: - Subviews

private extension PhotoEditorView {
    
    var filterButtons: some View {
        HStack {
            Button("Сепия") {
                self.applyFilter(type: .sepia)
            }
            .buttonStyle(FilterButtonStyle())

            Button("Ч/Б") {
                self.applyFilter(type: .mono)
            }
            .buttonStyle(FilterButtonStyle())

            Button("Блюр") {
                self.applyFilter(type: .blur)
            }
            .buttonStyle(FilterButtonStyle())
        }
    }
    
    func applyFilter(type: ImageFilterType) {
        // Если нажимаю тот же фильтр — он сбрасывается
        if currentFilter == type {
            currentFilter = nil
            if let originalData = originalImageData {
                profileImageBase64 = originalData.base64EncodedString()
            }
            return
        }

        // Иначе применяем новый фильтр — на ОРИГИНАЛ
        guard let originalData = originalImageData,
              let uiImage = UIImage(data: originalData) else { return }

        let service = ImageFilterService()
        let filteredImage: UIImage?

        switch type {
        case .sepia:
            filteredImage = service.applySepia(to: uiImage)
        case .mono:
            filteredImage = service.applyMono(to: uiImage)
        case .blur:
            filteredImage = service.applyBlur(to: uiImage)
        }

        if let image = filteredImage, let newData = image.pngData() {
            profileImageBase64 = newData.base64EncodedString()
            currentFilter = type
        }
    }
    
    var header: some View {
        Text("PhotoEditApp")
            .font(.largeTitle)
            .bold()
    }
    
    var resetButton: some View {
        Button {
            currentScale = 1.0
            finalScale = 1.0
            currentRotation = .zero
            finalRotation = .zero
            textPosition = .zero
            canvasWrapper.clear()
        } label: {
            Label("Сбросить", systemImage: "arrow.uturn.backward")
                .uniformButtonStyle(backgroundColor: Color.orange)
        }
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
            if showDrawingCanvas {
                DrawingCanvasView(wrapper: canvasWrapper)
                    .background(Color.clear)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .allowsHitTesting(true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color.white)
    }
    
    var drawingToggleButton: some View {
        Button {
            showDrawingCanvas.toggle()
        } label: {
            Label("Рисование", systemImage: "pencil.tip.crop.circle")
                .uniformButtonStyle(backgroundColor: Color.indigo)
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
            Label("Выбрать", systemImage: "photo.on.rectangle")
                .uniformButtonStyle(backgroundColor: Color.indigo)
        }
    }
    
    var rotateButton: some View {
        Button {
            finalRotation += Angle(degrees: 90)
        } label: {
            Label("Повернуть", systemImage: "rotate.right")
                .uniformButtonStyle(backgroundColor: Color.indigo)
        }
    }

    var deleteButton: some View {
        Button {
            profileImageBase64 = ""
        } label: {
            Label("Удалить", systemImage: "trash")
                .uniformButtonStyle(backgroundColor: Color.red)
        }
    }
    
    private var profileImageData: Data? {
        Data(base64Encoded: profileImageBase64)
    }
    
    var editingSection: some View {
        VStack(spacing: 8) {
            Text("Редактирование изображения")
                .font(.headline)

            HStack(spacing: 12) {
                Menu {
                    Button("Сепия") {
                        self.applyFilter(type: .sepia)
                    }
                    Button("Ч/Б") {
                        self.applyFilter(type: .mono)
                    }
                    Button("Блюр") {
                        self.applyFilter(type: .blur)
                    }
                } label: {
                    Label("Фильтры", systemImage: "slider.horizontal.3")
                        .uniformButtonStyle(backgroundColor: Color.indigo)
                }

                rotateButton
            }

            HStack(spacing: 12) {
                drawingToggleButton
                resetButton
            }
        }
        .frame(maxWidth: .infinity)
    }

    var imageSection: some View {
        VStack(spacing: 8) {
            Text("Работа с изображением")
                .font(.headline)

            HStack(spacing: 12) {
                uploadButton
                deleteButton
            }
        }
        .frame(maxWidth: .infinity)
    }

    var infoSection: some View {
        VStack(spacing: 8) {
            header
            emailText
            signOutButton
        }
        .padding(.top, 24)
    }
}

private extension View {
    func uniformButtonStyle(backgroundColor: Color) -> some View {
        self
            .padding(.vertical, 6)
            .frame(width: 130)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    PhotoEditorView(userEmail: "preview@example.com")
        .environmentObject(AuthViewModel())
}
