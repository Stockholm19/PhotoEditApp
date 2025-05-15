//
//  EditableImageView.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 12.05.2025.
//

import SwiftUI

struct EditableImageView: View {
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0

    @State private var currentRotation: Angle = .zero
    @State private var finalRotation: Angle = .zero

    @State private var offset: CGSize = .zero

    var image: Image

    var body: some View {
        VStack {
            ZStack {
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(currentScale * finalScale)
                    .rotationEffect(currentRotation + finalRotation)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        currentScale = value
                                    }
                                    .onEnded { value in
                                        finalScale *= value
                                        currentScale = 1.0
                                    },
                                RotationGesture()
                                    .onChanged { angle in
                                        currentRotation = angle
                                    }
                                    .onEnded { angle in
                                        finalRotation += angle
                                        currentRotation = .zero
                                    }
                            ),
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                        )
                    )
                    .animation(.easeInOut, value: currentScale)
                    .animation(.easeInOut, value: currentRotation)
                    .animation(.easeInOut, value: offset)
                    .padding()
            }
        }
    }
}

#Preview {
    EditableImageView(image: Image("example"))
        .background(Color.gray.opacity(0.2))
}
