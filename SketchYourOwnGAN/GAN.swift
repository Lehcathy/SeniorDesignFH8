//
//  GAN.swift
//  SketchYourOwnGAN
//
//  Created by Jeffrey Wallace on 2/23/22.
//

import Foundation
import Vision
import CoreImage
import UIKit
class GAN{
    let context = CIContext()
    var outputImage: UIImage?
    func coreMLCompletionHandler(request:VNRequest?,error:Error?){
        let result = request!.results!.first as! VNPixelBufferObservation
        let ciimage = CIImage(cvPixelBuffer: result.pixelBuffer)
        let cgImage = self.context.createCGImage(ciimage, from: ciimage.extent)
        self.outputImage = UIImage(cgImage: cgImage!)
    }
    func RunGan(sketch: CGImage, modelName: String) {
        lazy var coreMLRequest:VNCoreMLRequest = {
           let model = getModel(name: modelName)
           let request = VNCoreMLRequest(model: model, completionHandler: self.coreMLCompletionHandler)
            return request
           }()
        let pixelBuffer = sketch.pixelBuffer(width: 256, height: 256, orientation: .up)!
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([coreMLRequest])
    }
    
    func getModel(name: String) -> VNCoreMLModel{
        let config = MLModelConfiguration()
        switch name {
        case "mosaic":
            return try! VNCoreMLModel(for: fast_neural_style_transfer_mosaic(configuration: config).model)
        case "cuphead":
            return try! VNCoreMLModel(for: fast_neural_style_transfer_cuphead(configuration: config).model)
        case "starry night":
            return try! VNCoreMLModel(for: fast_neural_style_transfer_starry_night(configuration: config).model)
        case "warp":
            return try! VNCoreMLModel(for: warpgan(configuration: config).model)
        case "anime":
            return try! VNCoreMLModel(for: warpgan(configuration: config).model)
        default:
            return try! VNCoreMLModel(for: fast_neural_style_transfer_mosaic(configuration: config).model)
        }
    }
}

