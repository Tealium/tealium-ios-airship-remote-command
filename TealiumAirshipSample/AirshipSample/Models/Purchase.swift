//
//  Purchase.swift
//  AirshipSample
//
//  Created by Christina S on 12/16/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

struct Purchase {
    var event: String
    var total: Double
    var currency: String
    var id: String
    var product: Product

    static let `default` = Self(event: "purchase",
                                total: 19.99,
                                currency: "USD",
                                id: "ORDER123",
                                product: Product.default)

    init(event: String, total: Double, currency: String, id: String, product: Product) {
        self.event = event
        self.id = id
        self.total = total
        self.currency = currency
        self.product = product
    }

    var dictionary: [String: Any] {
        ["event_name": event,
         "order_id": id,
         "order_subtotal": total,
         "currency": currency,
         "product_id": product.id,
         "product_name": product.name,
         "product_brand": product.brand,
         "product_price": product.price]
    }

}

struct Product {
    var id: String
    var name: String
    var brand: String
    var price: Double

    static let `default` = Self(id: "abc123",
        name: "some cool product",
        brand: "awesome brand",
        price: 19.99
    )
    
    init(id: String,
         name: String,
         brand: String,
         price: Double) {
        self.id = id
        self.name = name
        self.brand = brand
        self.price = price
    }

}
