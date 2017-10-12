//
//  DictionaryExtensions.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/20.
//  Copyright © 2017 TW welly. All rights reserved.
//

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
