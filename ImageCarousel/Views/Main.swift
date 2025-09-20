import StoreKit
import SwiftUI

struct TestMain: View {
    @Environment(Store.self) private var store
    @State private var scrollID: Int?
    @State private var rotation: Double = 0
    @State private var rotatingImages: Set<Int> = []  // Track which images are rotating

    @State private var showBottomSheet = false

    @State private var isShowAnimation = false

    @State private var showingAlert = false

    //Storekit
    let totalImages = 15
    let unlockedCount = 7
    @ObservedObject var storeManager: StoreKitManager
    @State private var isShowingPurchaseSheet = false
    @State private var selectedLockedImage: Int?
    //

    let backgroundColor: Color = Color(
        red: 33 / 255, green: 33 / 255, blue: 33 / 255)  //
    @StateObject private var noiseManager = AudioManager.shared
    @State private var currentPlayingIndex: Int?  // Track the currently playing index

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    let sliderAnimation: Animation = .easeInOut(duration: 0.5).delay(0.5)

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(spacing: 1) {
                    Spacer().frame(height: 100)

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                            ForEach(0..<store.sampleImages.count, id: \.self) {

                                index in
                                let sampleImage = store.sampleImages[index]
                                let topLayerImage = store.topLayerImage[0]
                                VStack(alignment: .leading) {

                                    ZStack {
                                        Image(sampleImage.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 20)
                                            )
                                            .shadow(radius: 10)
                                            .padding(40)
                                            .rotationEffect(
                                                .degrees(
                                                    noiseManager.isPlaying[
                                                        noiseManager.sounds[
                                                            index
                                                        ].file] == true
                                                        ? rotation : 0))

                                        Image(topLayerImage.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 20)
                                            )
                                            .padding(48)
                                            .blendMode(.screen)

                                        // Background circle
                                        Circle()
                                            .foregroundStyle(
                                                backgroundColor.gradient.shadow(
                                                    .inner(
                                                        color: .black.opacity(
                                                            0.5), radius: 1,
                                                        y: 2))
                                            )
                                            .frame(width: 70, height: 70)

                                        Button(action: {
                                            let soundFile =
                                                noiseManager.sounds[
                                                    index
                                                ].file
                                            noiseManager.playPauseAudio(
                                                name: soundFile)
                                        }) {

                                            Image(
                                                systemName:
                                                    noiseManager.isPlaying[
                                                        noiseManager.sounds[
                                                            index
                                                        ].file] == true
                                                    ? "stop.circle.fill"
                                                    : "play.circle.fill"
                                            )
                                            .font(.system(size: 40))
                                            .foregroundStyle(
                                                .gray, .white.gradient
                                            )
                                            .shadow(
                                                color: .black.opacity(0.2),
                                                radius: 2, y: 2)
                                        }
                                        if index >= unlockedCount
                                            && !storeManager
                                                .hasActiveSubscription()
                                        {

                                            Button(action: {
                                                //                                                if /*index >= unlockedCount &&*/ !storeManager.hasActiveSubscription() {
                                                selectedLockedImage = index
                                                isShowingPurchaseSheet = true
                                                //                                                }
                                                //                                                showingAlert = true
                                            }) {

                                                Image(
                                                    systemName:
                                                        "lock.circle.fill"
                                                )
                                                .font(.system(size: 40))
                                                .foregroundStyle(
                                                    .gray, .white.gradient
                                                )
                                                .shadow(
                                                    color: .black.opacity(0.2),
                                                    radius: 2, y: 2)
                                            }
                                            //                                            .alert("Locked Content", isPresented: $showingAlert) {
                                            //                                                Button("OK", role: .cancel) { }
                                            //                                            } message: {
                                            //                                                Text("This content is currently locked.")
                                            //                                            }
                                        }
                                    }
                                    HStack {
                                        Image(systemName: "speaker.wave.1")
                                            .padding(10)
                                            .foregroundColor(.white)

                                        Slider(
                                            value: Binding(
                                                get: {
                                                    noiseManager.players[
                                                        noiseManager.sounds[
                                                            index
                                                        ].file]?.volume ?? 0.5
                                                },
                                                set: {
                                                    noiseManager.setVolume(
                                                        name:
                                                            noiseManager.sounds[
                                                                index
                                                            ].file, volume: $0)
                                                }
                                            ),
                                            in: 0...1
                                        )
                                        .cornerRadius(10)
                                        .accentColor(.white)

                                        Image(systemName: "speaker.wave.3")
                                            .padding(10)
                                            .foregroundColor(.white)
                                    }
                                    .offset(y: 10)
                                    .padding(.horizontal, 60)
                                    .opacity(
                                        noiseManager.isPlaying[
                                            noiseManager.sounds[index].file]
                                            == true ? 1.0 : 0.0
                                    )
                                    .animation(
                                        sliderAnimation,
                                        value: noiseManager.isPlaying[
                                            noiseManager.sounds[index].file]
                                            == true)

                                }
                                .containerRelativeFrame(.horizontal)
                                .scrollTransition(.animated, axis: .horizontal)
                                { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.6)
                                        .scaleEffect(
                                            phase.isIdentity ? 1.0 : 0.6)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollID)
                    .scrollTargetBehavior(.paging)
                    .onReceive(timer) { _ in
                        if noiseManager.isPlaying.values.contains(true) {  // Only rotate if any sound is playing
                            withAnimation(.linear(duration: 0.1)) {
                                rotation += 6
                            }
                        }
                    }
                    VStack(spacing: 40) {
                        IndicatorView(
                            imageCount: store.sampleImages.count,
                            scrollID: $scrollID
                        )
                        .offset(y: 40)
                    }
                    .offset(y: -100)
                }
                .background(backgroundColor.ignoresSafeArea())

                // Custom navigation bar positioned lower than default
                VStack {

                    // Adjust this value to position your navbar lower

                    HStack {
                        //                        NavigationLink(destination: AudioMixer()) {
                        Button(action: { showBottomSheet.toggle() }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.subheadline)
                                .padding(12)
                                .background(backgroundColor)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0, x: 1,
                                    y: 1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0,
                                    x: -1, y: -1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0,
                                    x: -1, y: 1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0, x: 1,
                                    y: -1)
                        }
                        .sheet(isPresented: $showBottomSheet) {
                            BottomSheetView()

                                .presentationDetents([.height(390)])
                                .presentationBackground(
                                    Color(
                                        red: 27 / 255, green: 27 / 255,
                                        blue: 27 / 255))  // Blurred effect
                        }

                        Spacer()

                        Image("SoundHaven")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(36)

                        Spacer()

                        NavigationLink(
                            destination: MixerView(storeManager: storeManager)
                        ) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.subheadline)
                                .padding(10)
                                .background(backgroundColor)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0, x: 1,
                                    y: 1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0,
                                    x: -1, y: -1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0,
                                    x: -1, y: 1
                                )
                                .shadow(
                                    color: .white.opacity(0.9), radius: 0, x: 1,
                                    y: -1)
                        }
                    }
                    .buttonStyle(LowlightButtonStyle())
                    .padding(.horizontal)

                }
                .frame(maxHeight: 100)

            }
            //            .navigationBarHidden(true)  // Hide the default navigation bar
        }.sheet(isPresented: $isShowingPurchaseSheet) {
            PurchaseView(storeManager: storeManager)
                .presentationDetents(
                    UIDevice.current.userInterfaceIdiom == .pad
                        ? [.large] : [.medium]
                )
        }
        .onReceive(storeManager.$purchaseCompleted) { completed in
            if completed {
                isShowingPurchaseSheet = false
                storeManager.purchaseCompleted = false  // Reset for future purchases
            }
        }
    }

    private func toggleRotation(for index: Int) {
        if rotatingImages.contains(index) {
            rotatingImages.remove(index)
        } else {
            rotatingImages.insert(index)
        }
    }
}

struct IndicatorView: View {
    let imageCount: Int
    @Binding var scrollID: Int?

    private let maxVisibleDots = 6  // Maximum number of dots displayed at once

    var body: some View {
        HStack(spacing: 4) {
            ForEach(visibleIndicators(), id: \.self) { indicator in
                let index = scrollID ?? 0
                let scale = dotScale(for: indicator)
                let opacity = dotOpacity(for: indicator)

                Button {
                    withAnimation {
                        scrollID = indicator
                    }
                } label: {

                    Circle()
                        .frame(width: 8, height: 8)
                        .scaleEffect(scale)
                        .foregroundStyle(
                            indicator == index ? Color.white : Color(.lightGray)
                        )
                        .opacity(opacity)
                }
            }
        }
        .padding(4)
    }

    // Determines which indicators are visible
    private func visibleIndicators() -> [Int] {
        let index = scrollID ?? 0

        if imageCount <= maxVisibleDots {
            return Array(0..<imageCount)
        }

        let halfMax = maxVisibleDots / 2

        if index <= halfMax {
            return Array(0..<maxVisibleDots)
        } else if index >= imageCount - halfMax {
            return Array((imageCount - maxVisibleDots)..<imageCount)
        } else {
            return Array((index - halfMax)...(index + halfMax))
        }
    }

    // Scales down dots at the edges to create the Instagram-like effect
    private func dotScale(for indicator: Int) -> CGFloat {
        let index = scrollID ?? 0
        let distance = abs(index - indicator)

        if distance == 3 { return 0.8 }
        if distance == 4 { return 0.6 }
        if distance >= 5 { return 0.4 }

        return 1.0
    }

    // Fades out dots at the edges
    private func dotOpacity(for indicator: Int) -> Double {
        let index = scrollID ?? 0
        let distance = abs(index - indicator)

        if distance == 3 { return 0.7 }
        if distance == 4 { return 0.5 }
        if distance >= 5 { return 0.3 }

        return 1.0
    }
}

struct LowlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct PurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storeManager: StoreKitManager

    var body: some View {
        VStack {
            Text("Unlock All Sounds")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 60)

            if storeManager.isLoading {
                ProgressView("Loading subscriptions...")
                    .padding()
            } else if let error = storeManager.loadingError {
                VStack(spacing: 8) {
                    Spacer()
                    Text("Something went wrong while loading subscriptions.")
                        .foregroundColor(.black)
                    Text(error.localizedDescription)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Button("Try Again") {
                        Task {
                            await storeManager.fetchProducts()
                        }
                    }
                    .padding(.top)
                    Spacer()
                }
            } else if storeManager.products.isEmpty {
                Text("No subscription options available at this time.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(storeManager.products) { product in
                    PurchaseButton(product: product, storeManager: storeManager)
                }
            }

            Spacer()

            Button("Restore Purchases") {
                Task {
                    await storeManager.restorePurchases()
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
        .padding(20)
    }
}

struct PurchaseButton: View {
    let product: Product
    @ObservedObject var storeManager: StoreKitManager

    var body: some View {
        Button {
            Task {
                await storeManager.purchase(product: product)
            }
        } label: {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .font(.headline)
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(product.displayPrice)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TestMain(storeManager: StoreKitManager())
        .environment(Store())
}
