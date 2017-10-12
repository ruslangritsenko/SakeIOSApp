//
//  DoubleExtensions.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/27.
//  Copyright © 2017 TW welly. All rights reserved.
//

extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
    
    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}
