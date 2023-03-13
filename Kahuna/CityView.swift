//
//  CityView.swift
//  Kahuna
//
//  Created by Connor McClanahan on 09/03/2023.
//

import SwiftUI

struct CityView: View {
    let city: City
    @State private var temperature: String = ""
    @State private var windSpeed: String = ""

    var body: some View {
        VStack {
            Text(city.name)
                .font(.title)
                .padding()

            
            Image(city.name)
                .resizable()
                .padding(.bottom)
                .frame(maxWidth: 490, maxHeight: 240, alignment: .center)
            
            
            HStack {
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Temperature")
                            .font(.headline)
                        Text("\(temperature)°C")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                    

                    
                    
                    VStack {
                        Text("Wind Speed")
                            .font(.headline)
                        Text("\(windSpeed) m/s")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                }
                
                
            }
            
            Spacer()
        }
        .onAppear {
            self.fetchTemperature()
        }
    }

    func fetchTemperature() {
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

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(city: City(id: 2747891, name: "Rotterdam", latitude: 51.9225, longitude: 4.47917))
    }
}
