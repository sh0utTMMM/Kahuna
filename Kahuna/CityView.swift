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
            
            
            HStack(alignment: .top, spacing: 30) {
                
                VStack(spacing: 30) {
                    VStack() {
                        Text("Temperature")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("\(temperature)°C")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(width: 150, height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                    

                    VStack {
                        HStack{
                            Text("Location")
                                .font(.title3)
                                .fontWeight(.medium)
                            Image(systemName: "mappin.and.ellipse")
                        }
                        Text("\(city.name)")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(width: 150, height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                }
                VStack(alignment: .leading) {
                    HStack(){
                        Text("Conditions")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: "cloud.fill")
                    }
                    .padding(.bottom)
                    
                    HStack{
                        Text("Wind Speed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(windSpeed) m/s")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 3.0)
                    
                    HStack{
                        Text("Gust")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(windSpeed) m/s")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    .padding(.bottom, 3.0)
                    HStack{
                        Text("Tide")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(windSpeed) m/s")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 3.0)
                    
                    HStack{
                        Text("Swell")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(windSpeed) m/s")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 3.0)
                    
                    HStack{
                        Text("Something")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(windSpeed) m/s")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 5.0)
                    
                }
                .frame(width: 180, height: 230)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                )
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
