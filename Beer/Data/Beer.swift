//
//  Beer.swift
//  UI
//
//  Created by p h on 22.05.2022.
//

import Foundation
import RealmSwift

class Beer: Object {
    @objc dynamic var brand = ""
    @objc dynamic var country = ""
    @objc dynamic var price: Float = 0
    @objc dynamic var amount = 0
    @objc dynamic var sold = 0
}
