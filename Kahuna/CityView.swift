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
    @State private var humidity: String = ""
    @State private var windGust: String = ""
    @State private var waterTemp: String = ""
    @State private var amountOfRain: String = ""
    @State private var windDegree: String = ""
    @State var tideStatus = "High"
    
    var surferImageName: String {
        if tideStatus == "High" && Double(windSpeed) ?? 0 > 3 {
            return "sufer"
        } else {
            return "Caution"
        }
    }

    var noSurferImageName: String {
        if tideStatus == "Low" && Double(windSpeed) ?? 0 < 1 {
            return "NoSurfing"
        } else {
            return ""
        }
    }


   
    var body: some View {
        ScrollView {
            VStack {
                WebView(url: URL(string: "https://www.youtube.com/embed/EHKOx5QJEj4?controls=1&showinfo=0")!)
                          .frame(width: 440, height: 315)
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(Color.white)
                        .opacity(1)
                        .frame(width: 440, height: 40)
                        .cornerRadius(90)
                        Image(surferImageName)
                        Image(noSurferImageName)
                    
                }
                .padding(.top, -20)
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
                            Text("Wave Height")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(String(format: "%.2f", Double.random(in: 0..<1.5)))m")                 .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                          
                        .padding(.bottom, 3.0)
                        HStack{
                            Text("Tide")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(tideStatus)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .onAppear {
                                              // Start the timer
                                    Timer.scheduledTimer(withTimeInterval: 12*60*60 + 25*60, repeats: true) { timer in
                                        // Toggle the tide status
                                        if tideStatus == "High" {
                                            tideStatus = "Low"
                                        } else {
                                            tideStatus = "High"
                                        }
                                    }
                                }
                        }
                        .padding(.bottom, 3.0)
                        
                        HStack{
                            Text("Water Temp")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(waterTemp) °C")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 3.0)
                        
                        HStack{
                            Text("Humidity")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(humidity) %")
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
                .padding(.bottom, 20)
                
                
                Text("Rain Radar")
                    .font(.title)
                    .padding(.bottom, 20)
                    
                HStack(spacing: 50){
                    VStack() {
                        Text("Precipitation")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("\(amountOfRain)mm")
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
                            Text("Wind")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        Text("Direction")
                            .font(.title3)
                            .fontWeight(.medium)
                        Image(systemName: "location.north.line")
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(Double(windDegree) ?? 0))
                    }
                    .padding()
                    .frame(width: 150, height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                }
                    
                RadarView()
                
                Spacer()
                
                
            }
            .onAppear {
                self.fetchTemperature()
                
        }
        }
        .navigationTitle(city.name)
      //  .edgesIgnoringSafeArea(.all)
    }
    
    
    
    func fetchTemperature() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(city.latitude)&lon=\(city.longitude)&units=metric&appid=8c714448edc2ce49f32ce5608cebf590&wind_deg") else {
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
                    self.humidity = "\(weatherData.main.humidity)"
                    self.windGust = "\(weatherData.wind.gust ?? 0.0)"
                    self.waterTemp = "\(weatherData.main.temp/2)"
                    self.amountOfRain = "\(weatherData.rain?.oneHour ?? 0.0)"
                    self.windDegree = "\(weatherData.wind.deg)"
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

