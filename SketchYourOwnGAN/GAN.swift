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
    var outputImage: UIImage?
    func coreMLCompletionHandler(request:VNRequest?,error:Error?){
        let result = request?.results?.first as! VNPixelBufferObservation
        self.outputImage = UIImage(ciImage: CIImage(cvPixelBuffer: result.pixelBuffer))
    }
    func RunGan(sketch: CIImage) {
        lazy var coreMLRequest:VNCoreMLRequest = {
            let config = MLModelConfiguration()
           let model = try! VNCoreMLModel(for: ugatit(configuration: config).model)
           let request = VNCoreMLRequest(model: model, completionHandler: self.coreMLCompletionHandler)
            return request
           }()

        let handler = VNImageRequestHandler(ciImage: sketch,options: [:])
        try? handler.perform([coreMLRequest])
    }
    
}
