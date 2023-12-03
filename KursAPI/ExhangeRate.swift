//
//  ExhangeRate.swift
//  KursAPI
//
//  Created by Christer Lindqvist on 2023-12-02.
//

import Foundation

struct Rate : Codable {
    let SEK : Double //Att hantera dynamiska fältnamn i samband med Decode....tar vi en annan gång.
}

struct ExchangeRate : Codable {
    let amount : Double
    let base : String
    let date : String
    let rates : Rate
}
