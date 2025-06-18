//
//  RentalRequest.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//


struct RentalRequestMdoel: Encodable {
    let renter: Int
    let product: Int
    let rent_option: String
    let rent_period_start_date: String
    let rent_period_end_date: String
}


struct EmptyResponse: Decodable {}
