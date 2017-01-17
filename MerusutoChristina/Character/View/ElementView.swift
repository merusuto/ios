//
//  ElementView.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/26.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit

class ElementView: UIView {

    var item: CharacterItem? {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let radius = min(rect.width, rect.height) / 2 - 5
        drawPentagonPointsTo(context: context!, boundedBy: rect, radius: radius, circleRadius: 3)
        drawPentagonTo(context: context!, boundedBy: rect, radius: radius, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
        drawPentagonTo(context: context!, boundedBy: rect, radius: radius * 2 / 3, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
        drawPentagonTo(context: context!, boundedBy: rect, radius: radius / 3, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05))
        drawElementTo(context: context!, boundedBy: rect, radius: radius)
    }

    func drawPentagonTo(context: CGContext, boundedBy rect: CGRect, radius: CGFloat, color: UIColor) {
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        context.setFillColor(color.cgColor)
        for i in 0 ... 4 {
            let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            if i == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        context.fillPath()
    }

    func drawPentagonPointsTo(context: CGContext, boundedBy rect: CGRect, radius: CGFloat, circleRadius r: CGFloat) {
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        for i in 0 ... 4 {
            let color = UIColorFromRGBA(rgbValue: [0xffe74c3c, 0xff3498db, 0xff2ecc71, 0xfff1c40f, 0xff9b59b6][i])
            context.setFillColor(color.cgColor)
            let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let circleRect = CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r)
            
            context.fillEllipse(in: circleRect)
            context.fillPath()
            
        }
    }

    func UIColorFromRGBA(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x000000FF) / 255.0,
            alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        )
    }

    func drawElementTo(context: CGContext, boundedBy rect: CGRect, radius: CGFloat) {
        if let item = self.item {
            let elements = [item.fire, item.aqua, item.wind, item.light, item.dark]
            let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
            let color = UIColorFromRGBA(rgbValue: [0, 0x80e74c3c, 0x803498db, 0x802ecc71, 0x80f1c40f, 0x809b59b6][item.element])
            context.setFillColor(color.cgColor)
            for i in 0 ... 4 {
                let angle = CGFloat((Double(i) * 72 - 90) * M_PI * 2 / 360)
                let x = center.x + radius * cos(angle) * CGFloat(elements[i]) / 2
                let y = center.y + radius * sin(angle) * CGFloat(elements[i]) / 2
                let point = CGPoint(x: x, y: y)
                if i == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }

            }
            context.fillPath()
        }
    }
}
