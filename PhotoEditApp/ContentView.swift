//
//  ContentView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            if let user = authViewModel.user {
                ProfileView(userEmail: user.email ?? "")
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
