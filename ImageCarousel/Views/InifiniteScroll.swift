//import SwiftUI
//
//struct TestMain2: View {
//    @Environment(Store.self) private var store
//    @State private var scrollID: Int? = 1 // Start from the first real item
////    @State private var scrollID: Int? = store.sampleImages.count
//    
//    @State private var isScrolling = false
//
//    let backgroundColor: Color = Color(red: 33/255, green: 33/255, blue: 33/255)
//
//    var loopedImages: [String] {
//        let images = store.sampleImages.map { $0.imageName }
//        guard images.count > 1 else { return images }
//        return [images.last!] + images + [images.first!] // Duplicate first & last
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 10) {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    LazyHStack(spacing: 0) {
//                        ForEach(0..<loopedImages.count, id: \.self) { index in
//                            let imageName = loopedImages[index]
//                            Image(imageName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxWidth: .infinity)
//                                .clipShape(RoundedRectangle(cornerRadius: 20))
//                                .shadow(radius: 10)
//                                .padding(40)
//                                .containerRelativeFrame(.horizontal)
//                        }
//                    }
//                    .scrollTargetLayout()
//                }
//                .scrollPosition(id: $scrollID)
//                .scrollTargetBehavior(.paging)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        scrollID = 1 // Ensure it starts at the real first image
//                    }
//                }
//                .onChange(of: scrollID) { oldValue, newValue in
//                    handleLoopingScroll(newValue)
//                }
//
//                IndicatorView(imageCount: store.sampleImages.count, scrollID: $scrollID)
//                    .offset(y: -20)
//            }
//            .background(backgroundColor.ignoresSafeArea())
//        }
//    }
//
//    private func handleLoopingScroll(_ newIndex: Int?) {
//        guard let newIndex else { return } // Unwrap optional safely
//
//        print("Current scrollID: \(newIndex)") // Debug statement
//
//        if newIndex == 0 {
//            print("Transitioning from duplicate last to real last") // Debug statement
//            DispatchQueue.main.async {
//                scrollID = store.sampleImages.count
//            }
//        } else if newIndex == loopedImages.count - 1 {
//            print("Transitioning from duplicate first to real first") // Debug statement
//            DispatchQueue.main.async {
//                scrollID = 1
//            }
//        }
//    }
//}
//
//struct IndicatorView: View {
//    let imageCount: Int
//    @Binding var scrollID: Int? // Change from Int to Int?
//
//    var body: some View {
//        HStack {
//            ForEach(0..<imageCount, id: \.self) { index in
//                Button {
//                    withAnimation {
//                        scrollID = index + 1 // Adjust for extra elements
//                    }
//                } label: {
//                    Image(systemName: "circle.fill")
//                        .font(.system(size: 8))
//                        .foregroundStyle(scrollID == index + 1 ? Color.white : Color(.lightGray))
//                }
//            }
//        }
//        .padding(7)
//    }
//}
//
//#Preview {
//    TestMain2()
//        .environment(Store())
//}
