//
//  ProfileView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 06.05.2025.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct ProfileView: View {
    let userEmail: String
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @AppStorage("profileImageData") private var profileImageBase64: String = ""

    var body: some View {
        VStack(spacing: 20) {
            avatarImage
            uploadButton

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

// MARK: - Subviews

private extension ProfileView {
    var header: some View {
        Text("👤 Добро пожаловать")
            .font(.largeTitle)
    }

    var emailText: some View {
        Text("Email: \(userEmail)")
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
    
    var avatarImage: some View {
        Group {
            if let data = profileImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var uploadButton: some View {
        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()) {
            Text("Выбрать изображение")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var profileImageData: Data? {
        Data(base64Encoded: profileImageBase64)
    }
}

#Preview {
    ProfileView(userEmail: "preview@example.com")
        .environmentObject(AuthViewModel())
}
