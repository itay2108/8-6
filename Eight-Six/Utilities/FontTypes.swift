//
//  FontTypes.swift
//  Dory
//
//  Created by itay gervash on 06/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit
import SwiftFontName

public class FontTypes {
    
    private let sizeModifier: CGFloat!
    
    static let shared = FontTypes()
    
    var h1 = UIFont.systemFont(ofSize: 14)
    var h2 = UIFont.systemFont(ofSize: 14)
    var h2_medium = UIFont.systemFont(ofSize: 14)
    var h3 = UIFont.systemFont(ofSize: 14)
    var h3_medium = UIFont.systemFont(ofSize: 14)
    var h3_demiBold = UIFont.systemFont(ofSize: 14)
    var h4_medium = UIFont.systemFont(ofSize: 13)
    var h5 = UIFont.systemFont(ofSize: 11)
    
    var xl = UIFont.systemFont(ofSize: 14)
    var button_bold = UIFont.systemFont(ofSize: 20)
    
    init() {
        sizeModifier = UIScreen.main.bounds.size.height / 812
        
        h1 = UIFont(name: FontName.AvenirNextDemiBold, size: 23 * sizeModifier)!
        h2 = UIFont(name: FontName.AvenirNextRegular, size: 16 * sizeModifier)!
        h2_medium = UIFont(name: FontName.AvenirNextMedium, size: 16 * sizeModifier)!
        h3 = UIFont(name: FontName.AvenirNextRegular, size: 14 * sizeModifier)!
        h3_medium = UIFont(name: FontName.AvenirNextMedium, size: 14 * sizeModifier)!
        h3_demiBold = UIFont(name: FontName.AvenirNextDemiBold, size: 14 * sizeModifier)!
        h4_medium = UIFont(name: FontName.AvenirNextMedium, size: 13 * sizeModifier)!
        h5 = UIFont(name: FontName.AvenirNextRegular, size: 11 * sizeModifier)!
        xl = UIFont(name: FontName.AvenirNextDemiBold, size: 64 * sizeModifier)!
        button_bold = UIFont(name: FontName.AvenirNextDemiBold, size: 20 * sizeModifier)!
    }
    

    
}
