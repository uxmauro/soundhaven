import Foundation

struct LocalImage: Identifiable {
    let id: Int
    let imageName: String
}

@Observable
class Store {
    var sampleImages: [LocalImage] = []
    var topLayerImage: [LocalImage] = []
    
    init() {
        loadLocalImages()
    }
    
    private func loadLocalImages() {
        // Add your local images with corresponding audio files
        sampleImages = [
            LocalImage(id: 1, imageName: "white-noise"),
            LocalImage(id: 2, imageName: "pink-noise"),
            LocalImage(id: 3, imageName: "brown-noise"),
            // Add more images as needed
        ]
        
        topLayerImage = [
            LocalImage(id: 1, imageName: "top-layer") // Empty string if no audio needed
        ]
    }
}
