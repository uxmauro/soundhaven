//
//  AudioMixer.swift
//  ImageCarousel
//
//  Created by Mauro on 2/5/25.
//

import SwiftUI

//struct BottomSheetView: View {
//    var body: some View {
//        VStack(spacing: 15) {
//            Text("More")
//                .font(.headline)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding(.top, 10)
//            
////            Spacer()
//            
//            VStack(alignment: .leading, spacing: 18) {
//                ShareLink(item: URL(string: "https://apps.apple.com/app/your-app-id")!) {
//                    Text("Share App")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                }
//                Divider()
//                    .overlay(.white)
//                ShareLink(item: URL(string: "https://apps.apple.com/app/your-app-id/review")!) {
//                    Text("Rate App")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                }
//                Divider()
//                    .overlay(.white)
//                Text("Privacy Policy")
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//                    .onTapGesture {
//                        if let url = URL(string: "https://www.example.com/") {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//                Divider()
//                    .overlay(.white)
//                Text("Terms of Service")
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//                    .onTapGesture {
//                        if let url = URL(string: "https://www.example.com/") {
//                            UIApplication.shared.open(url)
//                        }
//                    }
//                Divider()
//                    .overlay(.white)
//                Text("Version 1.0")
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the leading edge
//            
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 40) // Reduce horizontal padding
//        .padding(.vertical, 10) // Reduce vertical padding
//        .background(Color(red: 27 / 255, green: 27 / 255, blue: 27 / 255))
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//    }
//}


struct BottomSheetView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    ShareLink(item: URL(string: "https://apps.apple.com/app/6743006931")!) {
                        Text("Share App")
                    }
                    Button("Rate App") {
                            rateApp()
                        }
                }
                
                Section {
                    Button(action: {
                    if let url = URL(string: "https:/soundhaven.framer.website/privacy-policy/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Privacy Policy")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    Button(action: {
                        if let url = URL(string: "https://soundhaven.framer.website/terms") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Terms Of Service")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section {
                    Text("Version 1.0")
                }
            }
            .listStyle(InsetGroupedListStyle()) // Makes it look like iOS settings
//            .navigationTitle("More")
        }.preferredColorScheme(.dark)
    }
}


func rateApp() {
       if let url = URL(string: "itms-apps://apps.apple.com/app/id6743006931?action=write-review") {
           UIApplication.shared.open(url)
       }
   }


#Preview {
    BottomSheetView()
}
