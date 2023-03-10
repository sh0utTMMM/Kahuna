/*import SwiftUI

struct ContentView: View {
    @State private var temperature: String = ""
    @State private var selectedCity: City?
    
    let cities = [
        City(id: 6265, name: "Amsterdam"),
        City(id: 6391, name: "Arcen"),
        City(id: 6248, name: "Breda"),
        City(id: 6275, name: "Den Haag"),
        City(id: 6280, name: "Eindhoven"),
        City(id: 6285, name: "Groningen"),
        City(id: 6288, name: "Hoofddorp"),
        City(id: 6290, name: "Leeuwarden"),
        City(id: 6242, name: "Maastricht"),
        City(id: 6260, name: "Rotterdam"),
        City(id: 6273, name: "Utrecht"),
        City(id: 6348, name: "Zandvoort")
    ]
    
    var body: some View {
        VStack {
            Text(selectedCity?.name ?? "Select a city")
                .font(.title)
                .padding()
            
            Text("Temperature: \(temperature)°C")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
            
            Picker("Select a city", selection: $selectedCity) {
                ForEach(cities, id: \.id) { city in
                    Text(city.name).tag(city as City?)
                }
            }
            .padding()
            
            Button(action: {
                self.fetchTemperature()
            }, label: {
                Text("Refresh Temperature")
                    .font(.headline)
            })
        }
    }
    
    func fetchTemperature() {
        guard let city = selectedCity else {
            print("No city selected")
            return
        }
        
        guard let url = URL(string: "https://data.buienradar.nl/2.0/feed/json") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let buienradarData = try decoder.decode(BuienradarData.self, from: data)
                if let station = buienradarData.actual.stationmeasurements.first(where: { $0.stationid == city.id }) {
                    DispatchQueue.main.async {
                        self.temperature = String(station.temperature)
                    }
                } else {
                    print("\(city.name) station not found")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

struct City: Hashable {
    let id: Int
    let name: String
}

struct BuienradarData: Codable {
    let actual: ActualData
}

struct ActualData: Codable {
    let stationmeasurements: [StationMeasurement]
}

struct StationMeasurement: Codable {
    let stationid: Int
    let temperature: Double
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
