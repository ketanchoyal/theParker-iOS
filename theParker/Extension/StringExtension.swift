//
//  StringExtension.swift
//  theParker
//
//  Created by Ketan Choyal on 09/02/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

extension String {
    var isBlank : Bool {
        let s = self
        let cset = NSCharacterSet.newlines.inverted
        let r = s.rangeOfCharacter(from: cset)
        let ok = s.isEmpty || r == nil
        return ok
    }
    
    func date_Year_Time(DYT : @escaping (_ date : String, _ year : String, _ time : String) -> ()) {
        let D_Y_T = self
        
        let scanner = Scanner(string: D_Y_T)
        let skipped = CharacterSet(charactersIn: ", ")
        let comma = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped = skipped
        
        var date, year, time : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &date)
        scanner.scanUpToCharacters(from: comma, into: &year)
        scanner.scanUpToCharacters(from: comma, into: &time)
        
        DYT(date! as String, year! as String, time! as String)
        
    }
    
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
    
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}
