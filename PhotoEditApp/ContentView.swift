//
//  ContentView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 01.05.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Перейти на экран входа") {
                    LoginView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
