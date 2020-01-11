//
//  CountryAPI.swift
//  CountryApp
//
//  Created by Blake McAnally on 1/2/20.
//  Copyright © 2020 Blake McAnally. All rights reserved.
//

import Foundation
import Combine

enum CountryAPI {
    static func fetchCountries() -> AnyPublisher<[Country], Error> {
        let url = URL(string: "https://restcountries.eu/rest/v2/all")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
