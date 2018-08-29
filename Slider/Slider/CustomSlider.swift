//
//  CustomSlider.swift
//  Slider
//
//  Created by adam on 2018-08-29.
//  Copyright © 2018 adam. All rights reserved.
//

import Cocoa

class CustomSlider: NSControl {
    var textFlied:NSTextField!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.cell = customSliderCell.init(textCell: "")
    }
    
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        self.addTrackingRect(self.bounds, owner: self, userData: nil, assumeInside: true)
    }
}


class customSliderCell:NSSliderCell{
    var textFiled:NSTextField!
    var upButton:NSButton!
    var downButton:NSButton!
    
    var value:CGFloat!
    var sliderTitle:String!
    var isInTriangel:Bool!
    
    let textFiledSize:NSSize = NSMakeSize(50, 30)
    let triangelWidth:Double = 10
    
    override init(textCell string: String) {
        super.init(textCell: string)
        defaultValue()
    }
    
    required init(coder: NSCoder) {
       super.init(coder: coder)
       defaultValue()
    }
    
    func defaultValue() {
        sliderTitle = String("Exposure")
        textFiled = NSTextField.init(frame: NSMakeRect(0, 0, 50, 30))
        textFiled.isEditable = true
        textFiled.isBordered = false
        textFiled.alignment = NSTextAlignment.center
        textFiled.bezelStyle = NSTextField.BezelStyle.squareBezel
        minValue = -100
        maxValue = 100
        value = 40
        isInTriangel = false
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        NSGraphicsContext.saveGraphicsState()
        //draw background
        let backgroundColor:NSColor = NSColor.init(named: NSColor.Name.init(String("customSliderBackgroundColor")))!
        
        backgroundColor.set()
        NSBezierPath.fill(cellFrame)
        
        print(sliderTitle)
        let titleStr =  sliderTitle + String.init(format: " = %0.01lf", value)
        //draw title
        let titleAtt:NSMutableAttributedString = NSMutableAttributedString.init(string: titleStr)
        titleAtt.addAttributes([NSAttributedStringKey.font : NSFont.systemFont(ofSize: 12)], range: NSMakeRange(0, titleAtt.length))
        titleAtt.addAttributes([NSAttributedStringKey.foregroundColor : NSColor.black], range: NSMakeRange(0, titleAtt.length))
        
        titleAtt.draw(in: NSMakeRect(NSMinX(cellFrame), (NSMaxY(cellFrame) - titleAtt.size().height) / 2, titleAtt.size().width, titleAtt.size().height))
        
        //draw value area
        let valueArea:NSRect = valueAreaRect(frame: cellFrame)
        let valueAreaColor = NSColor.init(named: NSColor.Name.init(String("valueAreaColor")))
        
        valueAreaColor?.set()
        NSBezierPath.fill(valueArea)
        
        //draw title
        titleAtt.draw(in: NSMakeRect(NSMinX(cellFrame), (NSMaxY(cellFrame) - titleAtt.size().height) / 2, titleAtt.size().width, titleAtt.size().height))
        
        //draw triangle symbolt
        let triangelArea:TriangelArea =  triangelRect(frame: cellFrame)
        
        let triangelPath:NSBezierPath = NSBezierPath.init()
        triangelPath.move(to: triangelArea.topPoint)
        triangelPath.line(to: triangelArea.leftPoint)
        triangelPath.line(to: triangelArea.rightPoint)
        if isInTriangel{
            NSColor.red.set()
        }
        else{
            NSColor.black.set()
        }
        
        triangelPath.fill()
        
        //draw Spinbox button
        let textFiledCellRect = NSMakeRect(NSMaxX(cellFrame) - textFiledSize.width, NSMinY(cellFrame), textFiledSize.width, textFiledSize.height)
        
        textFiled.backgroundColor = NSColor.init(named: NSColor.Name.init(String("SpinBoxButtonColor")))
        textFiled.cell?.draw(withFrame: textFiledCellRect, in: controlView)
        textFiled.stringValue = String.init(format: "%0.01lf", value)
    }

    //value area
    func valueAreaRect(frame cellFrame:NSRect) -> NSRect {
        let sliderWidth:CGFloat = sliderArea(frame: cellFrame).size.width
        let valueAreaWidth:CGFloat = sliderWidth * ((value - CGFloat(minValue)) / (CGFloat(maxValue) - CGFloat(minValue)))
        let valueAreaRect:NSRect = NSMakeRect(NSMinX(cellFrame), NSMinY(cellFrame), valueAreaWidth, cellFrame.size.height)
        
        return valueAreaRect
    }
    
    //slider area
    func sliderArea(frame cellFrame:NSRect) -> NSRect {
        
        let sliderWidth:CGFloat = cellFrame.size.width - textFiledSize.width
        return NSMakeRect(NSMinX(cellFrame), NSMinY(cellFrame), sliderWidth, cellFrame.size.height)
    }
    
    //triangle symbolt rect
    func triangelRect(frame cellFrame:NSRect) -> TriangelArea{
        
        let valueAreaWidth:CGFloat = valueAreaRect(frame: cellFrame).size.width
        let topPoint:NSPoint = NSMakePoint(valueAreaWidth, CGFloat(sqrt(triangelWidth * triangelWidth - (triangelWidth / 2) * (triangelWidth / 2))))
        
        let leftPoint:NSPoint = NSMakePoint(valueAreaWidth - CGFloat(triangelWidth / 2), NSMinY(cellFrame))
        
        let rightPoint:NSPoint = NSMakePoint(valueAreaWidth + CGFloat(triangelWidth / 2), NSMinY(cellFrame))
        
        let triangelArea:TriangelArea = TriangelArea.init(top: topPoint, left: leftPoint, right: rightPoint)
        
        return triangelArea
    }
    
    //calculate the value with mouse location
    func cacluteValue(location point:NSPoint)->CGFloat{
        
        let sliderRect:NSRect = sliderArea(frame: (controlView?.bounds)!)
        if point.x > NSMaxX(sliderRect){
            return value
        }
        
        let valueAreaWith:CGFloat = point.x - sliderRect.origin.x
        var calValue:CGFloat = CGFloat(minValue) + valueAreaWith / (sliderRect.size.width) * (CGFloat( maxValue) - CGFloat(minValue))
        
        if calValue < CGFloat(minValue){
            calValue = CGFloat(minValue)
        }
        
        if calValue > CGFloat(maxValue){
            calValue = CGFloat(maxValue)
        }
        
        return calValue
    }
}
//tracking event
extension customSliderCell{
    override func continueTracking(last lastPoint: NSPoint, current currentPoint: NSPoint, in controlView: NSView) -> Bool {
        if triangelRect(frame: controlView.bounds).isInTriangelArea(Point: lastPoint){
            isInTriangel = true
        }
        else{
            isInTriangel = false
        }
        print("Adam-Debug: " + NSStringFromPoint(lastPoint))
        super.continueTracking(last: lastPoint, current: currentPoint, in: controlView)
        value = cacluteValue(location: lastPoint)
        controlView.needsLayout = true
        controlView.needsDisplay = true
        
        return true
    }
    
    override func trackMouse(with event: NSEvent, in cellFrame: NSRect, of controlView: NSView, untilMouseUp flag: Bool) -> Bool {
        let mouseLocation:NSPoint = controlView.convert(event.locationInWindow, from: nil)
        value = cacluteValue(location: mouseLocation)
        controlView.needsLayout = true
        controlView.needsDisplay = true
        
        return super.trackMouse(with: event, in: cellFrame, of: controlView, untilMouseUp: flag)
    }
    
    override func stopTracking(last lastPoint: NSPoint, current stopPoint: NSPoint, in controlView: NSView, mouseIsUp flag: Bool) {
        
        return super.stopTracking(last: lastPoint, current: stopPoint, in: controlView, mouseIsUp: flag)
    }
    
}

struct TriangelArea {
    var topPoint:NSPoint!
    var leftPoint:NSPoint!
    var rightPoint:NSPoint!
    
    init(top point1:NSPoint,left point2:NSPoint, right point3:NSPoint) {
        topPoint = point1
        leftPoint = point2
        rightPoint = point3
    }
    //if Point is inside isInTriangelArea return true, else return false
    func isInTriangelArea(Point:NSPoint) -> Bool {
    
        let pointA:NSPoint = NSMakePoint(Point.x - topPoint.x, Point.y - topPoint.y)
        let pointB:NSPoint = NSMakePoint(Point.x - leftPoint.x, Point.y - leftPoint.y)
        let pointC:NSPoint = NSMakePoint(Point.x - rightPoint.x, Point.y - rightPoint.y)
        let a:CGFloat = pointA.x * pointB.y - pointA.y * pointB.x
        let b:CGFloat = pointB.x * pointC.y - pointB.y * pointC.x
        let c:CGFloat = pointC.x * pointA.y - pointC.y * pointA.x
        
        if (a <= 0 && b <= 0 && c <= 0) || (a > 0 && b > 0 && c > 0){
            return true
        }
        
        return false
    }
}
