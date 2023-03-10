import SwiftUI

struct ContentView: View {
    @State private var temperature: String = ""
    @State private var searchText: String = ""
    @State private var selectedCity: City?
    
    let cities = [
        City(id: 2747891, name: "Rotterdam", latitude: 51.9225, longitude: 4.47917),
        City(id: 2747373, name: "Den Haag", latitude: 52.0705, longitude: 4.3007),
        City(id: 2759794, name: "Amsterdam", latitude: 52.374, longitude: 4.8897),
        City(id: 2745343, name: "Texel", latitude: 53.0638, longitude: 4.7997),
        City(id: 2744467, name: "Wassenaar", latitude: 52.1483, longitude: 4.4067),
        City(id: 2749877, name: "Middelburg", latitude: 51.5, longitude: 3.61389)
    ]

    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Text(selectedCity?.name ?? "Select a city")
                    .font(.title)
                    .padding()
                
                Text("Temperature: \(temperature)°C")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    TextField("Search cities", text: $searchText)
                        .padding()
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 150), spacing: 10),
                        GridItem(.flexible(minimum: 150), spacing: 10)
                    ], spacing: 10) {
                        ForEach(filteredCities, id: \.id) { city in
                            NavigationLink(destination: CityView(city: city)) {
                                VStack(alignment: .center, spacing: 5) {
                                    Text(city.name)
                                        .font(.headline)
                                        .foregroundColor(selectedCity == city ? .white : .blue)
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: 200,
                                               alignment: .center)
                                        .background(selectedCity == city ? Color.blue : Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedCity == city ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                                        )
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    .padding(.horizontal)
                    
                }
            }
            
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

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(city.latitude)&lon=\(city.longitude)&units=metric&appid=8c714448edc2ce49f32ce5608cebf590") else {
            print("Invalid URL")
            return
        }

        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: Data is nil")
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.temperature = "\(weatherData.main.temp)"
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
    let latitude: Double
    let longitude: Double
}

struct WeatherData: Codable {
    let main: MainData
}

struct MainData: Codable {
    let temp: Double
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
