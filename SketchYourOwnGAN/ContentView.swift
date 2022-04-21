//
//  ContentView.swift
//  SketchYourOwnGAN
//
//  Created by Jeffrey Wallace on 11/16/21.
//

import SwiftUI
import PencilKit
import Vision
struct ContentView: View {
    @State private var model = "mosaic"
    let models = ["mosaic", "starry night", "cuphead", "warp"]
    @State var isShowPhotoLibrary = false
    @State var gan = GAN()
    @State var inputImage = UIImage()
    @State var outputImage = UIImage()
    let context = CIContext()
    var body: some View {
            VStack {
                Image(uiImage:outputImage).resizable().aspectRatio(contentMode: .fit)
                Image(uiImage:self.inputImage).resizable().aspectRatio(contentMode: .fit)
                HStack {
                    Spacer()
                    Button("Run GAN", action:{
                        gan.RunGan(sketch: inputImage.cgImage!, modelName: model)
                        outputImage =  gan.outputImage!
                    }).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                    Spacer()
                    Picker("Select Model:", selection: $model){
                        ForEach(models, id:\.self){
                            Text($0).padding()
                        }
                    }.pickerStyle(.menu)
                    Spacer()
                    Button(action: {
                        UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil)
                    }, label: {
                        Image(systemName: "square.and.arrow.down.fill").font(.title)
                    })
                    Spacer()
                    Button(action: {
                            self.isShowPhotoLibrary = true
                        }, label: {
                            Image(systemName: "photo")
                                .font(.system(size: 20))
             
                        })
                    Spacer()
                }
                .sheet(isPresented: $isShowPhotoLibrary){
                    ImagePicker(selectedImage:self.$inputImage, sourceType: .photoLibrary)
                }
                }
                Spacer()
            }
        }







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
