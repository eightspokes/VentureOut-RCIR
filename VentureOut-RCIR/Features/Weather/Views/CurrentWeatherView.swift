//
//  WeatherView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/21/23.
//

import SwiftUI
import CoreLocation

struct CurrentWeatherView: View{
    
    var weatherManager = WeatherManager()
    @State var weather: WeatherResponse?

    static let location = CLLocation(
        latitude: .init(floatLiteral: 43.094200),
        longitude: .init(floatLiteral: -77.681801)
    
    )
    var RCIRLocation = "Black Creek"
    
    func celsiusToFahrenheit(celsius: Double) -> String {
        return ((celsius * 9/5) + 32).roundDoubleToOneDecimal()
    }
    private func fetchWeather() async {
        do{
            try await weather = weatherManager.getCurrentWeather(latitude: Self.location.coordinate.latitude, longitude: Self.location.coordinate.longitude)

        }catch{
            print("Error getting weather \(error)")
        }
    }
    private   func windDirection(degrees: Int) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = (degrees + 22) / 45
        return directions[index]
    }

    var body: some View{
    
       
        if let weather = weather{
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(RCIRLocation)
                        .bold()
                        .font(.title)
                    Text("Today: \(Date().formatted(.dateTime.month().day().hour().minute()))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack {
                    HStack (){
                        VStack(spacing: 10) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 35))
                            Text(weather.weather[0].main)
                        }
                        Spacer()
                        Text("\(celsiusToFahrenheit( celsius: weather.main.temp)) F")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .padding()
                    }
                }
                Spacer()
                
                Image("rowers")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270)
                    .offset(y: -20)
                
                  
                VStack{
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Weather now: ")
                            .bold().padding(.bottom)
                            .font(.title2)
                        HStack{
                            WeatherRow(logo: "location.north", name: "Direction", value: windDirection(degrees: weather.wind.deg))
                            Spacer()
                            WeatherRow(logo: "wind", name: "Speed", value: weather.wind.speed.description + " m/s" )
                          
                           
                            
                        }
                        HStack{
                            WeatherRow(logo: "digitalcrown.horizontal.press", name: "Pressure", value: weather.main.pressure.description + " Pa" )
                            Spacer()
                            WeatherRow(logo: "drop", name: "Humidity", value: weather.main.humidity.description + "%       " )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear()
            
            
        }else{
            ProfileView()
                .task{
                    await fetchWeather()
                }

        }


    
     
        
        

    }
        
}

struct CurrentWeatherView_Previews:
    PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(weather: previewWeather)
    }
}
