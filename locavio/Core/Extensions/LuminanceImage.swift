//
//  LuminanceImage.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 15/10/26.
//

import UIKit

extension UIImage {
    /// Luminância média de 0 (preto) a 1 (branco).
    /// `region` usa coordenadas normalizadas (0...1), origem no canto superior esquerdo.
    func averageLuminance(in region: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> CGFloat? {
        guard let cgImage else { return nil }

        let w = CGFloat(cgImage.width)
        let h = CGFloat(cgImage.height)
        let cropRect = CGRect(
            x: region.minX * w,
            y: region.minY * h,
            width: region.width * w,
            height: region.height * h
        ).integral

        guard let cropped = cgImage.cropping(to: cropRect) else { return nil }

        var pixel = [UInt8](repeating: 0, count: 4)
        let drawn = pixel.withUnsafeMutableBytes { buffer -> Bool in
            guard let ctx = CGContext(
                data: buffer.baseAddress,
                width: 1,
                height: 1,
                bitsPerComponent: 8,
                bytesPerRow: 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return false }

            ctx.interpolationQuality = .medium
            ctx.draw(cropped, in: CGRect(x: 0, y: 0, width: 1, height: 1))
            return true
        }
        guard drawn else { return nil }

        let r = CGFloat(pixel[0]) / 255
        let g = CGFloat(pixel[1]) / 255
        let b = CGFloat(pixel[2]) / 255

        // Pesos de luminância (Rec. 709)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
}
