import SwiftUI
import StoreKit

struct MixerView: View {
    @StateObject private var audioManager = AudioManager.shared
    @Environment(Store.self) private var store

    //Storekit
    let totalImages = 15
    let unlockedCount = 7  // First 4 images are free
    @ObservedObject var storeManager: StoreKitManager
    @State private var isShowingPurchaseSheet = false
    @State private var selectedLockedImage: Int?
    //
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    ForEach(audioManager.sounds.indices, id: \.self) { index in
                        let sound = audioManager.sounds[index]
                        
                        // Ensure the index is within bounds of sampleImages
                        let sampleImage = index < store.soundMixerImage.count ? store.soundMixerImage[index] : nil

                        HStack {
                            if index >= unlockedCount && !storeManager.hasActiveSubscription() {
                                Button(action: {
                                    selectedLockedImage = index
                                    isShowingPurchaseSheet = true
                                }) {
                                    ZStack {
                                        if let sampleImage = sampleImage {
                                            Image(sampleImage.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                        Circle()
                                            .foregroundStyle(
                                                Color.black.gradient.shadow(
                                                    .inner(
                                                        color: .black.opacity(
                                                            0.5), radius: 1,
                                                        y: 2))
                                            )
                                            .frame(width: 20, height: 20)

                                        // Foreground Lock Icon
                                        Image(
                                            systemName: "lock.circle.fill"
                                        )
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(
                                            .gray, .white.gradient
                                        )
                                        .shadow(
                                            color: .black.opacity(0.2),
                                            radius: 2, y: 2)
                                    }    .padding(.trailing, 10)
                                }
                            } else {
                                Button(action: {
                                    audioManager.playPauseAudio(name: sound.file)
                                }) {
                                    ZStack {
                                        if let sampleImage = sampleImage {
                                            Image(sampleImage.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        }
                                        Circle()
                                            .foregroundStyle(
                                                Color.black.gradient.shadow(
                                                    .inner(
                                                        color: .black.opacity(
                                                            0.5), radius: 1,
                                                        y: 2))
                                            )
                                            .frame(width: 20, height: 20)
                                        Image(systemName: audioManager.isPlaying[sound.file] == true ? "pause.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(
                                                .gray, .white.gradient
                                            )
                                            .shadow(
                                                color: .black.opacity(0.2),
                                                radius: 2, y: 2)
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(sound.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Image(systemName: "speaker.wave.1")
                                        .foregroundColor(.white)
                                    Slider(
                                        value: Binding(
                                            get: { audioManager.players[sound.file]?.volume ?? 0.5 },
                                            set: { audioManager.setVolume(name: sound.file, volume: $0) }
                                        ),
                                        in: 0...1
                                    )
                                    .accentColor(.white)
                                }
                                .offset(y: -8)
                            }
                        }
                        
                        if index != audioManager.sounds.indices.last {
                            Divider()
                                .frame(width: .infinity, height: 1)
                                .background(Color.gray.opacity(0.5))
                        }
                    }

                }
                .padding()
                .background(Color(
                    red: 33 / 255, green: 33 / 255, blue: 33 / 255))
            }
            .foregroundColor(.white) // Apply to all text in the ScrollView
            .navigationTitle("Mixer")
                .padding(.trailing, 20)
            .toolbarBackground(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .background(Color(
                red: 33 / 255, green: 33 / 255, blue: 33 / 255))
        }  .sheet(isPresented: $isShowingPurchaseSheet) {
            PurchaseView(storeManager: storeManager)
                .presentationDetents(
                           UIDevice.current.userInterfaceIdiom == .pad ? [.large] : [.medium]
                       )
        }
        .onReceive(storeManager.$purchaseCompleted) { completed in
                    if completed {
                        isShowingPurchaseSheet = false
                        storeManager.purchaseCompleted = false // Reset for future purchases
                    }
                }
    }
}





// Preview
struct MixerView_Previews: PreviewProvider {
    static var previews: some View {
        MixerView(storeManager: StoreKitManager())
            .environment(Store())
    }
}
