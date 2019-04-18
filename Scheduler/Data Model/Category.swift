//
//  Category.swift
//  Scheduler
//
//  Created by George James Manayath on 18/04/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
