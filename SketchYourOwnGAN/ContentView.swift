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
    @State var sketching = true
    @State var canvas = PKCanvasView()
    @State var erasing = false
    @State var gan = GAN()
    @State var sketch = UIImage()
    @State var outputImage = UIImage()
    let context = CIContext()
    var body: some View {
        if sketching {
            VStack{
                DrawingView(canvas: $canvas, erasing: $erasing).navigationTitle("Sketching").navigationBarTitleDisplayMode(.inline)
                HStack {
                    Spacer()
                    Button(action: {
                        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }, label: {
                        Image(systemName: "square.and.arrow.down.fill").font(.title)
                    })
                    Spacer()
                    Button("To GAN", action: {
                        sketching=false
                        sketch = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
                        print("image created")
                    }).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        erasing = false
                    }, label: {
                        Image(systemName: "pencil").font(.title)
                    })
                    Spacer()
                    Button(action: {
                        erasing = true
                    }, label: {
                        Image(systemName: "pencil.slash").font(.title)
                    })
                    Spacer()
                }
                Spacer()
            }
        } else {
            VStack {
                Image(uiImage:outputImage).resizable().aspectRatio(contentMode: .fit)
                Image(uiImage: UIImage(imageLiteralResourceName: "suki")).resizable().aspectRatio(contentMode: .fit)
                HStack {
                    Button("Run GAN", action:{
                        //let ciimage = CIImage(cgImage: sketch.cgImage!)
                        let sketch = UIImage(imageLiteralResourceName: "suki")
                        gan.RunGan(sketch: sketch.cgImage!)
                        outputImage =  gan.outputImage!
                        print("gan successfully run")
                    }).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                    Button("Back to Sketch", action:{ sketching = true}).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                }
                Spacer()
            }
        }
    }
}



struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var erasing : Bool
    let pen = PKInkingTool(.pen, color: .black)
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        if erasing {
            canvas.tool = eraser
        } else {
            canvas.tool = pen
        }
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = erasing ? eraser : pen
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
