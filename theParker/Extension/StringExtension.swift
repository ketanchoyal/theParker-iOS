//
//  StringExtension.swift
//  theParker
//
//  Created by Ketan Choyal on 31/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
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
    
    func date_Year_Time(D_Y_T : String, DYT : @escaping (_ date : String, _ year : String, _ time : String) -> ()) {
        let D_Y_T = D_Y_T
        
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
}
