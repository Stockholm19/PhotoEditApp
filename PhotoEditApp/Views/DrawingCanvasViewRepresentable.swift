//
//  DrawingCanvasViewRepresentable.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 15.05.2025.
//

import SwiftUI
import PencilKit

class CanvasViewWrapper: ObservableObject {
    @Published var canvasView = PKCanvasView()
}

struct DrawingCanvasView: UIViewRepresentable {
    @ObservedObject var wrapper: CanvasViewWrapper

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = wrapper.canvasView
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = .white
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
