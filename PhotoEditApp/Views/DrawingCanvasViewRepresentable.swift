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
    
    /// Объединяю загруженное фото и рисунок с холста в одно изображение
    func renderedImage(size: CGSize, base: UIImage?) -> UIImage? {
        let drawingImage = canvasView.drawing.image(from: CGRect(origin: .zero, size: size), scale: 1)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        base?.draw(in: CGRect(origin: .zero, size: size))
        drawingImage.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func clear() {
        canvasView.drawing = PKDrawing()
    }
}

struct DrawingCanvasView: UIViewRepresentable {
    @ObservedObject var wrapper: CanvasViewWrapper

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = wrapper.canvasView
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
