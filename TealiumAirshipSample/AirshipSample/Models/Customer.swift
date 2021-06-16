//
//  Customer.swift
//  AirshipSample
//
//  Created by Christina S on 12/16/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

struct Customer {
    var customerFirstName: String
    var customerLastName: String
    var customerCity: String
    var customerState: String
    var customerZip: String
    var customerCountry: String

    static let `default` = Self(customerFirstName: "John",
        customerLastName: "Doe",
        customerCity: "San Diego",
        customerState: "CA",
        customerZip: "92121",
        customerCountry: "US")

    init(customerFirstName: String,
        customerLastName: String,
        customerCity: String,
        customerState: String,
        customerZip: String,
        customerCountry: String) {
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerCity = customerCity
        self.customerState = customerState
        self.customerZip = customerZip
        self.customerCountry = customerCountry
    }

    var dictionary: [String: String] {
        ["customer_first_name": customerFirstName,
            "customer_last_name": customerLastName,
            "customer_city": customerCity,
            "customer_state": customerState,
            "customer_zip": customerZip,
            "customer_country": customerCountry]
    }
}
