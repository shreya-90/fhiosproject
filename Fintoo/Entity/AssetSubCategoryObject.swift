// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let delivery = try? newJSONDecoder().decode(Delivery.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let delivery = try? newJSONDecoder().decode(Delivery.self, from: jsonData)

import Foundation

// MARK: - DeliveryElement
struct DeliveryElement: Codable {
    let name, id, date: String
    let data: [[Datum]]
    let appdata: [Appdatum]
}

// MARK: - Appdatum
struct Appdatum: Codable {
    let schmemeName: String
    let schemeAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case schmemeName = "schmeme_name"
        case schemeAmount = "scheme_amount"
    }
}

enum Datum: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Datum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

typealias Delivery = [DeliveryElement]
