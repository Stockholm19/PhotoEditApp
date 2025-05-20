//
//  ImageFilterService.swift
//  PhotoEditApp
//
//  Created by Роман Пшеничников on 20.05.2025.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageFilterService {
    private let context = CIContext()

    func applySepia(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        let filter = CIFilter.sepiaTone()
        filter.inputImage = ciImage
        filter.intensity = 0.8

        return outputImage(from: filter, originalImage: image)
    }

    func applyMono(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        let filter = CIFilter.photoEffectNoir()
        filter.inputImage = ciImage

        return outputImage(from: filter, originalImage: image)
    }

    func applyBlur(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = 5

        return outputImage(from: filter, originalImage: image)
    }

    private func outputImage(from filter: CIFilter, originalImage: UIImage) -> UIImage? {
        guard let outputCIImage = filter.outputImage,
              let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }
}
