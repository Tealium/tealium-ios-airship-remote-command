//
//  Tags.swift
//  AirshipSample
//
//  Created by Christina S on 12/17/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

struct Tags {
    var value: [String]
    var group: String
    var type: String
    
    static let namedUser = Self(value: ["def123", "ghi123"],
                                group: "electronics",
                                type: "named_user")
    
    static let channel = Self(value: ["abc123", "xyz123"],
                                group: "sports",
                                type: "channel")
    
    init(value: [String], group: String, type: String) {
        self.value = value
        self.group = group
        self.type = type
    }

    var dictionary: [String: Any] {
        ["tags": value,
         "tag_group": group,
         "tag_type": type]
    }
}
