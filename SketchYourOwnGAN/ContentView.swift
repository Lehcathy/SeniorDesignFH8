//
//  ContentView.swift
//  SketchYourOwnGAN
//
//  Created by Jeffrey Wallace on 11/16/21.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State var sketching = true
    @State var canvas = PKCanvasView()
    
    var body: some View {
        if sketching {
            VStack{
                Text("Sketching")
                DrawingView(canvas: $canvas).navigationTitle("Sketching").navigationBarTitleDisplayMode(.inline)
                HStack {
                    Button("Save Sketch", action: {sketching=false}).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                    Button("To GAN", action: {sketching=false}).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                }
                Spacer()
            }
        } else {
            VStack {
                Image("image1").resizable().aspectRatio(contentMode: .fit)
                Image("image2").resizable().aspectRatio(contentMode: .fit)
                Image("image3").resizable().aspectRatio(contentMode: .fit)
                Image("image4").resizable().aspectRatio(contentMode: .fit)
                HStack {
                    Button("Run GAN", action:{ RunGan()}).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                    Button("Back to Sketch", action:{ sketching = true}).buttonStyle(.bordered).background().colorMultiply(.blue).foregroundColor(.black)
                }
                
                Spacer()
            }
        }
    }
}

func RunGan() {
    print("running GAN")
}

struct DrawingView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
