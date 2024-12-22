//
//  ContentView.swift
//  Marathon-SwiftUI-MakeItLoud
//
//  Created by Sergey Leontiev on 21.12.24..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .blur(radius: 5, opaque: true)
                .ignoresSafeArea()
                
            VolumeView()
                .frame(width: 100, height: 225)
                .frame(maxHeight: .infinity)
        }
      
    }
}

#Preview {
    ContentView()
}

struct VolumeView: View {
    @State var progress: CGFloat = 0.2
    @State var offset: CGFloat = 0
    @State var lastOffset: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .background(.ultraThinMaterial)
                Rectangle()
                    .fill(.white)
                    .frame(height: max(progress, 0) * height)
            }
            .clipShape(.rect(cornerRadius: 30))
            .frame(height: progress < 0 ? height - (progress * height) : nil)
            .gesture (
                DragGesture()
                    .onChanged { value in
                        offset = -value.translation.height + lastOffset
                        calculateProgress(height: height)
                    }
                    .onEnded { _ in
                        withAnimation(.smooth) {
                            offset = min(height, max(offset, 0))
                            calculateProgress(height: height)
                        }
                        lastOffset = offset
                    }
            )
            .frame(
                width: width,
                height: height,
                alignment: progress > 0 ? .bottom : .top
            )
            .scaleEffect(x: (0...1).contains(progress) ? 1 : 0.95)
            .animation(.default, value: (0...1).contains(progress))
        }
    }
    
    private func calculateProgress(height: CGFloat) {
        let scale = 0.05
        let topExcessOffset = height + (offset - height) * scale
        let bottomExcessOffset = offset < 0 ? offset * scale : offset
        progress = (offset > height ? topExcessOffset : bottomExcessOffset) / height
    }
}


struct AnimationProperties {
    var translation = 0.0
    var verticalStretch = 1.0
}
