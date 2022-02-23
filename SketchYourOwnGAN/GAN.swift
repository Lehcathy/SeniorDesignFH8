//
//  GAN.swift
//  SketchYourOwnGAN
//
//  Created by Jeffrey Wallace on 2/23/22.
//

import Foundation
import Vision
import CoreImage
class GAN{
    var image: CIImage?
    var gan: VNCoreMLModel?
    func completionHandler(request:VNRequest?,error:Error?) {
        //let result = request?.results?.first as! VNCoreMLFeatureValueObservation
        //let multiArray = result.featureValue.multiArrayValue
        //let uiImage = multiArray?.image(min: -1, max: 1, channel: nil, axes:nil)
    }
    
    func RunGan(image: CIImage) {
        lazy var coreMLRequest:VNCoreMLRequest = { () -> VNCoreMLRequest in
             let model:VNCoreMLModel = try! VNCoreMLModel(for: gan(configuration: MLModelConfiguration()).model)
             let request = VNCoreMLRequest(model: model, completionHandler: self.completionHandler)
             return request
        }()
        let handler = VNImageRequestHandler(ciImage: image, options: [:])
        DispatchQueue.global(qos: .userInitiated).async { [self] in
             do {
                 try handler.perform([coreMLRequest])
             } catch let error {
                 print(error)
             }
         }
        print("running GAN")
    }
}
