//
//  Pattern.swift
//  Set
//
//  Created by 杨浩 on 2020/2/29.
//  Copyright © 2020 Grayson. All rights reserved.
//

import Foundation
import UIKit

struct CardView {
    enum number: Int {
        case zero = 0
        case one
        case two
        case three
        
        static let all = [number.one, .two, .three]
    }
    
    enum shape: String {
        case none = ""
        case triangle = "▲"
        case circle = "●"
        case rectangle = "■"
        
        static let all = [shape.triangle, .circle, .rectangle]
    }
    
    enum fill: String{
        case none = ""
        case solid = "solid"
        case hollow = "hollow"
        case stripe = "stripe"
        
        static let all = [fill.solid, .hollow, .stripe]
    }
    
    enum color {
        case none
        case red
        case green
        case purple
        
        static let all = [color.red, .green, .purple]
    }
}


