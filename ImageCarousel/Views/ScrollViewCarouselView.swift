import SwiftUI

struct ScrollViewCarouselView: View {
    @Environment(Store.self) private var store
    @State private var scrollID: Int?
    @State private var rotation: Double = 0
    @State private var rotatingImages: Set<Int> = [] // Track which images are rotating
    @State private var backgroundColor: Color = .gray // Default background color
    @State private var showColorPicker = false // Control color picker visibility
     
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<store.sampleImages.count, id: \.self) { index in
                            let sampleImage = store.sampleImages[index]
                            let topLayerImage = store.topLayerImage[0]
                            VStack(alignment: .leading){
                                ZStack {
                                    Image(sampleImage.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius: 10)
                                        .padding(40)
                                        .rotationEffect(.degrees(rotatingImages.contains(index) ? rotation : 0))
                                    Image(topLayerImage.imageName)
                                        .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .padding(48)
                                            .blendMode(.screen)
                                    // Background circle
                                    Circle()
                                        .foregroundStyle(backgroundColor.gradient.shadow(.inner(color: .black.opacity(0.5), radius: 1, y: 2)))
                                        .frame(width: 70, height: 70)
//
                                    
                                    // Play/Stop button overlay
                                    Button(action: {
                                        toggleRotation(for: index)
                                    }) {
                                        Image(systemName: rotatingImages.contains(index) ? "stop.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundStyle(.gray, .white.gradient)        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
                                    
//                                            .foregroundStyle(rotatingImages.contains(index) ? Color.red : Color.green,  .white ) // Red for stop, Green for play
                                    }
                                }
                            }
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollID)
                .scrollTargetBehavior(.paging)
                .onReceive(timer) { _ in
                    if !rotatingImages.isEmpty {
                        withAnimation(.linear(duration: 0.1)) {
                            rotation += 6
                        }
                    }
                }
                
                IndicatorView(imageCount: store.sampleImages.count, scrollID: $scrollID)
                    .offset(y: -100)
                
                Spacer()
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SoundHaven")
                        .font(.title)
                        .foregroundColor(.primary)
                        .offset(y: 100)
                }
                   // Color Picker Button at the Top Right
            // Color Picker Button at the Top Right
                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: { showColorPicker.toggle() }) {
//                        Image(systemName: "paintpalette")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                    }
                    HStack {
    // "slider.vertical.3" icon
    Button(action: {
        // Action if needed
    }) {
        Image(systemName: "slider.vertical.3")
            .font(.subheadline)
            .foregroundColor(.white)
    }
                        Spacer() 
    ZStack {
        // Paint Palette Icon
        Image(systemName: "swatchpalette")
            .font(.subheadline)
            .background(.black)
            .foregroundColor(.white)

        // Invisible Color Picker Overlaid on Button
        ColorPicker("", selection: $backgroundColor, supportsOpacity: true)
            .opacity(0.1)
            .offset(x: -12)
            .frame(width: 50, height: 50)
            .blendMode(.destinationOver)
    }
}
                }
            }
            // Color Picker as a sheet
            .sheet(isPresented: $showColorPicker) {
                VStack {
                 
                    
                    ColorPicker("Select Color", selection: $backgroundColor, supportsOpacity: true)
                        .padding()
                    
                    Button("Done") {
                        showColorPicker = false
                    }
               
                }
                .padding()
            }
        }
    }
    
    private func toggleRotation(for index: Int) {
        if rotatingImages.contains(index) {
            rotatingImages.remove(index)
            if rotatingImages.isEmpty {
                let targetRotation = round(rotation / 360) * 360
                withAnimation(.linear(duration: 0.5)) {
                    rotation = targetRotation
                }
            }
        } else {
            rotatingImages.insert(index)
        }
    }
}
#Preview {
    ScrollViewCarouselView()
        .environment(Store())
}

struct IndicatorView: View {
    let imageCount: Int
    @Binding var scrollID: Int?
    var body: some View {
        HStack {
            ForEach(0..<imageCount, id: \.self) { indicator in
            let index = scrollID ?? 0
                Button {
                    withAnimation {
                        scrollID = indicator
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                     .foregroundStyle(indicator == index ? Color.white : Color(.lightGray))
                }
            }
        }
        .padding(7)
//        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.lightGray)).opacity(0.2))
    }
}
