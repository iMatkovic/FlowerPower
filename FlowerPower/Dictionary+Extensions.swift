//
//  Dictionary+Extensions.swift
//  FlowerPower
//
//  Created by Ivan Matkovic on 26/10/2017.
//  Copyright © 2017 Ivan Matkovic. All rights reserved.
//

import Foundation

extension Dictionary where Value: Comparable {
    
    enum PrintOption {
        case none
        case lowToHigh
        case highToLow
    }
    
    func printEachPair(_ option: PrintOption) {
        
        var ordered: [(Key, Value)] = []
        
        switch option {
        case .none:
            ordered = self.map { $0 }
        case .lowToHigh:
            ordered = self.sorted(by: { (first, second) -> Bool in
                first.value < second.value
            })
        case .highToLow:
            ordered = self.sorted(by: { first, second in
                first.value > second.value
            })
        }
        
        ordered.forEach { key, value in
            print("\(key) -> \(value)")
        }
        
    }
    
}
