import SwiftUI

struct ContentView: View {
    @State private var temperature: String = ""
    @State private var windSpeed: String = ""
    
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
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    if city.id == 2747891 {
                                        Text("Beginner")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(.bottom, 5.0)
                                        
                                    } else if city.id == 2759794 {
                                        Text("Intermediate")
                                            .padding(.bottom, 5.0)
                                            .font(.title)
                                            .fontWeight(.bold)
                                    } else if city.id == 2744467 {
                                        Text("Advanced")
                                            .padding(.bottom, 5.0)
                                            .font(.title)
                                            .fontWeight(.bold)
                                    } else {
                                        Spacer()
                                    }
                                    
                                    Image(city.name)
                                        .resizable()
                                        .frame(maxWidth: 190, maxHeight: 120, alignment: .center)
                                        .cornerRadius(10)
                                    HStack{
                                        Text(city.name)
                                        Image(systemName: "figure.surfing")
                                    }
                                }
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    .padding(.horizontal)
                }
                VStack(spacing: 20) {
                    Text("Legend")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack(spacing: 20) {
                        VStack{
                            Image(systemName: "figure.surfing")
                            Text("You can surf!")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        VStack{
                            Image(systemName: "water.waves.and.arrow.down.trianglebadge.exclamationmark")
                            Text("Low tide!")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        VStack{
                            Image(systemName: "water.waves.slash")
                            Text("No  Waves!")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
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
                    self.windSpeed = "\(weatherData.wind.speed)"
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
    let wind: WindData
}

struct WindData: Codable {
    let speed: Double
}

struct MainData: Codable {
    let temp: Double
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
