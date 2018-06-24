//
//  Model.swift
//  Todoey
//
//  Created by Yangfan on 2018-06-24.
//  Copyright © 2018 fansaien. All rights reserved.
//

import Foundation
class Item : NSObject, NSCoding{
    var title  = ""
    var done = false
    init(title : String, done : Bool = false) {
        self.title = title
        self.done = done
    }
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let done = aDecoder.decodeBool(forKey: "done")
        self.init(title: title, done: done)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(done, forKey: "done")
    }
}
