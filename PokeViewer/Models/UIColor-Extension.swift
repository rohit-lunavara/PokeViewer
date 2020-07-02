//
//  UIColor-Extension.swift
//  PokeViewer
//
//  Created by Rohit Lunavara on 6/30/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import UIKit

extension UIColor {
    // Credits : https://stackoverflow.com/a/33459083
    convenience init(hexaString: String, alpha: CGFloat = 1.0) {
        let hexaString = Array(hexaString)
        self.init(red:   .init(strtoul(String(hexaString[0...1]),nil,16))/255,
                  green: .init(strtoul(String(hexaString[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(hexaString[4...5]),nil,16))/255,
                  alpha: alpha)
        
    }
    
    // Credits : https://stackoverflow.com/a/40961645
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2 }
        guard l2 > 0 else { return color1 }
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
