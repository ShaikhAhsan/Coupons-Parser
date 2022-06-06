//
//  Coupons.swift
//  TargetedCoupon
//
//  Created by Muhammad Ahsan on 29/11/2020.
//

import UIKit

class Coupons: Codable {
    
    var data: [Coupon]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(data, forKey: .data)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decode([Coupon].self, forKey: .data)
    }
}


class Coupon: Codable {
    
    var name: String?
    var id: String?
    var data: [Condition]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(String.self, forKey: .id)
        data = try values.decode([Condition].self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(name, forKey: .name)
        try? container.encode(id, forKey: .id)
        try? container.encode(data, forKey: .data)
    }
}

class Condition: Codable {
    
    var op: String
    var condition: String
    
    enum CodingKeys: String, CodingKey {
        case op
        case condition
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        op = try values.decode(String.self, forKey: .op)
        condition = try values.decode(String.self, forKey: .condition)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(op, forKey: .op)
        try? container.encode(condition, forKey: .condition)
    }
}
