//
//  RadarView.swift
//  Kahuna
//
//  Created by Ivan on 3/14/23.
//
import SwiftUI

struct RadarView: View {
    @State private var radarImage: UIImage? = nil
    let timer = Timer.publish(every: 150, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if let image = radarImage {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(maxWidth: 300, maxHeight: 340, alignment: .center)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            fetchRadarImage()
        }
        .onReceive(timer) { _ in
            fetchRadarImage()
        }
    }
    
    private func fetchRadarImage() {
        guard let url = URL(string: "https://api.buienradar.nl/image/1.0/RadarMapNL?w=500&h=512&nocache=\(UUID().uuidString)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching radar image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.radarImage = UIImage(data: data)
            }
        }.resume()
    }
}



struct RadarView_Previews: PreviewProvider {
    static var previews: some View {
        RadarView()
    }
}
