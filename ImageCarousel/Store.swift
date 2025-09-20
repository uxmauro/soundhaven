import Foundation

struct LocalImage: Identifiable {
    let id: Int
    let imageName: String
}

@Observable
class Store {
    var sampleImages: [LocalImage] = []
    var topLayerImage: [LocalImage] = []
    var soundMixerImage: [LocalImage] = []
    
    init() {
        loadLocalImages()
    }
    
    private func loadLocalImages() {
        // Add your local images with corresponding audio files
        sampleImages = [
            LocalImage(id: 1, imageName: "white-noise"),
            LocalImage(id: 2, imageName: "pink-noise"),
            LocalImage(id: 3, imageName: "brown-noise"),
            LocalImage(id: 4, imageName: "rain-vinyl"),
            LocalImage(id: 5, imageName: "beach-vinyl"),
            LocalImage(id: 6, imageName: "shhh-vinyl"),
            LocalImage(id: 7, imageName: "bonfire-vinyl"),
            LocalImage(id: 8, imageName: "birds-vinyl"),
            LocalImage(id: 9, imageName: "owl-vinyl"),
            LocalImage(id: 10, imageName: "crickets-vinyl"),
            LocalImage(id: 11, imageName: "fan-vinyl"),
            LocalImage(id: 12, imageName: "flute-vinyl"),
            LocalImage(id: 13, imageName: "frogs-vinyl"),
            LocalImage(id: 14, imageName: "piano-vinyl"),
            LocalImage(id: 15, imageName: "harp-vinyl"),
            LocalImage(id: 16, imageName: "heartbeat-vinyl"),
            LocalImage(id: 17, imageName: "engine-vinyl"),
            LocalImage(id: 18, imageName: "train-vinyl"),
            LocalImage(id: 19, imageName: "airplane-vinyl"),
            LocalImage(id: 20, imageName: "lofi-piano-vinyl"),
            LocalImage(id: 21, imageName: "lofi-guitar-vinyl"),
//            LocalImage(id: 8, imageName: "city"),
//            LocalImage(id: 15, imageName: "coffee-shop"),
//            LocalImage(id: 18, imageName: "jungle"),
//            LocalImage(id: 19, imageName: "ocean"),
//
//            LocalImage(id: 22, imageName: "rain"),
//            LocalImage(id: 23, imageName: "river"),
//            LocalImage(id: 25, imageName: "subway"),
//            LocalImage(id: 26, imageName: "thunder"),
//            LocalImage(id: 28, imageName: "Vacuum"),
//            LocalImage(id: 29, imageName: "waterfall"),
//            LocalImage(id: 30, imageName: "whales"),




        ]
        
        soundMixerImage = [
            LocalImage(id: 1, imageName: "white"),
            LocalImage(id: 2, imageName: "pink"),
            LocalImage(id: 3, imageName: "brown"),
            LocalImage(id: 4, imageName: "rain"),
            LocalImage(id: 5, imageName: "beach"),
            LocalImage(id: 6, imageName: "shhh"),
            LocalImage(id: 7, imageName: "bonfire"),
            LocalImage(id: 8, imageName: "birds"),
            LocalImage(id: 9, imageName: "owl"),
            LocalImage(id: 10, imageName: "crickets"),
            LocalImage(id: 11, imageName: "fan"),
            LocalImage(id: 12, imageName: "flute"),
            LocalImage(id: 13, imageName: "frog"),
            LocalImage(id: 14, imageName: "piano"),
            LocalImage(id: 15, imageName: "harp"),
            LocalImage(id: 16, imageName: "heartbeat"),
            LocalImage(id: 17, imageName: "engine"),
            LocalImage(id: 18, imageName: "train"),
            LocalImage(id: 19, imageName: "airplane"),
            LocalImage(id: 20, imageName: "lofi-piano"),
            LocalImage(id: 21, imageName: "lofi-guitar")
            
        ]
        
        
        topLayerImage = [
            LocalImage(id: 1, imageName: "top-layer") // Empty string if no audio needed
        ]
    }
}
