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
}
