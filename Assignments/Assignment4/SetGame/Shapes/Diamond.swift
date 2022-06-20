//
//  Diamond.swift
//  SetGame
//
//  Created by Brian Coleman on 2022-06-13.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width * 0.8
        let height = width * 0.5
        
        let left = CGPoint(x: rect.midX - width/2, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.midY + height/2)
        let right = CGPoint(x: rect.midX + width/2, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.midY - height/2)
        
        var p = Path()
        p.move(to: left)
        p.addLine(to: top)
        p.addLine(to: right)
        p.addLine(to: bottom)
        p.addLine(to: left)
        return p
    }
}
