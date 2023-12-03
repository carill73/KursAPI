//
//  ContentView.swift
//  KursAPI
//
//  Created by Christer Lindqvist on 2023-12-02.
// Allt detta är naturligvis tjänstefel: Hanteringen är 100% synkron, i motsats till vad som visats / uppmanats till i genomgångarna....men jag
// gick bort mig i andra varianter, där returdata hanterades i en closure...och dem fick jag inte att hänga ihop.
// Det enda som händer är att värdet av 1 DKK i SEK hämtas när man klickar på textknappen... :/
//

import SwiftUI

struct ContentView: View {
  @State var rate = 0.0
  
  var api = APIClient(baseURL: URL(string:"https://api.frankfurter.app/")!)
    
  var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button( action: {
                    let decoder = JSONDecoder()
                    let parameters = ["amount": 1.0, "from": "DKK","to":"SEK" ] as [String : Any]
                    
                    do {
                        let data = try api.fetchData(path: "latest", parameters: parameters)
                        let exchangeRate = try decoder.decode(ExchangeRate.self, from: data)
                        rate = exchangeRate.rates.SEK
                       
                    } catch {
                        print("Error: \(error)")
                    }
                }) {
                    Text("1 DKK i SEK: ")
                }
            
                TextField("", text: Binding(get: {
                                return String(self.rate)
                            }, set: { newValue in
                                self.rate = Double(newValue) ?? 0.0
                            }))
                            
                    
                
                Spacer()
            }
            Spacer()
        }
        .padding()
    }

    
}
#Preview {
    ContentView()
}
