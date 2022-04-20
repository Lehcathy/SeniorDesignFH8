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
        //let multiArray = result.featureValue.multiArrayValue
        //print(multiArray)
        //self.outputImage = multiArray!.image(min: -256, max: 256, channel: nil, axes: (1,2,3))
        //let out = self.outputImage
        //print(out?.size)
        let ciimage = CIImage(cvPixelBuffer: result.pixelBuffer)
        let cgImage = self.context.createCGImage(ciimage, from: ciimage.extent)
        self.outputImage = UIImage(cgImage: cgImage!)
    }
    func RunGan(sketch: CGImage) {
        lazy var coreMLRequest:VNCoreMLRequest = {
            let config = MLModelConfiguration()
           let model = try! VNCoreMLModel(for: fast_neural_style_transfer_mosaic(configuration: config).model)
           let request = VNCoreMLRequest(model: model, completionHandler: self.coreMLCompletionHandler)
            return request
           }()
        let pixelBuffer = sketch.pixelBuffer(width: 256, height: 256, orientation: .up)!
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        //let handler = VNImageRequestHandler(ciImage: sketch,options: [:])
        try? handler.perform([coreMLRequest])
    }
}

