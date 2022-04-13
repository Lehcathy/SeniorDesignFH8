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
        print(request!.results!.first as Any)
        let result = request!.results!.first as! VNPixelBufferObservation
        print(result)
        let ciimage = CIImage(cvPixelBuffer: result.pixelBuffer)
        let cgImage = self.context.createCGImage(ciimage, from: ciimage.extent)
        self.outputImage = UIImage(cgImage: cgImage!)
    }
    func RunGan(sketch: CIImage) {
        lazy var coreMLRequest:VNCoreMLRequest = {
            let config = MLModelConfiguration()
           let model = try! VNCoreMLModel(for: photosketch3(configuration: config).model)
           let request = VNCoreMLRequest(model: model, completionHandler: self.coreMLCompletionHandler)
            return request
           }()
        let handler = VNImageRequestHandler(ciImage: sketch,options: [:])
        try? handler.perform([coreMLRequest])
    }
    
}
