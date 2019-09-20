import Foundation

// MARK: - CompareFundObj
struct CompareFundObj: Codable {
    let navhisthl: [Navhisthl]
    let schemedet: [[String: String?]]
    let holdings: [Holding]
    let assetAllocation: [AssetAllocation]
    let expenceRatio: [ExpenceRatio]
    let exitLoad: [ExitLoad]
    let navhistory: [Navhistory]
    
    enum CodingKeys: String, CodingKey {
        case navhisthl, schemedet, holdings
        case assetAllocation = "asset_allocation"
        case expenceRatio = "expence_ratio"
        case exitLoad = "exit_load"
        case navhistory
    }
}

// MARK: - AssetAllocation
struct AssetAllocation: Codable {
    let holdSchemecode, holding, asset: String
    
    enum CodingKeys: String, CodingKey {
        case holdSchemecode = "hold_schemecode"
        case holding, asset
    }
}

// MARK: - ExitLoad
struct ExitLoad: Codable {
    let exitloadSchemecode, exitLoad, exitLoadRemarks: String
    
    enum CodingKeys: String, CodingKey {
        case exitloadSchemecode = "exitload_schemecode"
        case exitLoad = "exit_load"
        case exitLoadRemarks = "exit_load_remarks"
    }
}

// MARK: - ExpenceRatio
struct ExpenceRatio: Codable {
    let expratioSchemecode, expRatio, ratioDate: String
    
    enum CodingKeys: String, CodingKey {
        case expratioSchemecode = "expratio_schemecode"
        case expRatio = "exp_ratio"
        case ratioDate = "ratio_date"
    }
}

// MARK: - Holding
struct Holding: Codable {
    let schemecode, holdpercentage, compname: String
    let sector: String?
    enum CodingKeys: String, CodingKey {
        case schemecode = "Schemecode"
        case holdpercentage = "Holdpercentage"
        case compname = "Compname"
        case sector = "Sector"
        
    }
}

// MARK: - Navhisthl
struct Navhisthl: Codable {
    let high, low, ytd, sihigh: String
    let silow, schemecode: String
    
    enum CodingKeys: String, CodingKey {
        case high, low, ytd, sihigh, silow
        case schemecode = "SCHEMECODE"
    }
}

// MARK: - Navhistory
struct Navhistory: Codable {
    let navhisSchemecode: String
    let currentnav: String?
    let sixmonthsnav: String?
    let oneyearnav, threeyearsnav, fiveyearsnav: String?
    
    enum CodingKeys: String, CodingKey {
        case navhisSchemecode = "navhis_schemecode"
        case currentnav, sixmonthsnav, oneyearnav, threeyearsnav, fiveyearsnav
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
