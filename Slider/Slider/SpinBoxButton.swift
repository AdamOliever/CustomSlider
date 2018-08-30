//
//  SpinBoxButton.swift
//  Slider
//
//  Created by adam on 2018-08-29.
//  Copyright © 2018 adam. All rights reserved.
//

import Cocoa

class SpinBoxButton: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        cell = SpinBoxButtonCell.init(textCell: "")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cell = SpinBoxButtonCell.init(textCell: "")
    }
    
    override var stringValue: String{
        set(newValue){
            cell?.stringValue = stringValue
        }
        
        get{
            return (cell?.stringValue)!
        }
    }
    override var doubleValue: Double{
        set(newValue){
            stringValue = String(newValue)
        }
        
        get{
            if stringValue == ""{
                return 0
            }
            
            return 10
        }
    }
    override func becomeFirstResponder() -> Bool {
//        let success:Bool = super.becomeFirstResponder()
//
//        if success{
//            stringValue = (cell?.stringValue)!
//        }
        return false
    }
}

class SpinBoxButtonCell: NSTextFieldCell {
    var textControl:NSTextField!
    
    private var mIsEditingOrSelecting:Bool = false
    
    override init(textCell string: String) {
        super.init(textCell: String("10"))
        defauleValue()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        defauleValue()
    }
    func defauleValue() {
        drawsBackground = true
        focusRingType = NSFocusRingType.none
        font = NSFont.systemFont(ofSize: 11.0)
        wraps = false
        isEditable = true
        if textControl == nil{
            textControl = NSTextField.init(frame: NSMakeRect(0, 0, cellSize.width, cellSize.height))
        }
        textControl.drawsBackground = false
        textControl.isBordered = false
        textControl.cell?.controlSize = NSControl.ControlSize.small
        textControl.font = font
        textControl.alignment = NSTextAlignment.center
        textControl.stringValue = String("10")
        textControl.backgroundColor = NSColor.init(named: NSColor.Name.init(String("SpinBoxButtonColor")))
    }
    
    override var stringValue: String{
        set(newValue){
            if textControl == nil{
                textControl = NSTextField.init(frame: NSMakeRect(0, 0, cellSize.width, cellSize.height))
            }
            textControl.stringValue = newValue
        }
        get{
            return textControl.stringValue
        }
    }
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        //draw background
        
        let backgroundColor:NSColor = NSColor.init(named: NSColor.Name.init(String("SpinBoxButtonColor")))!
        NSGraphicsContext.saveGraphicsState()
        backgroundColor.set()
        NSBezierPath.fill(cellFrame)
        //draw up button
        let upButtonRect:NSRect = upButtonArea(frame: cellFrame)
        let upImagerect:NSRect = NSInsetRect(upButtonRect, 4, 4)
        let upBtnPath:NSBezierPath = NSBezierPath.init()
        upBtnPath.move(to: NSMakePoint(NSMinX(upImagerect), NSMaxY(upImagerect)))
        upBtnPath.line(to: NSMakePoint(upImagerect.origin.x + upImagerect.size.width / 2, NSMinY(upImagerect)))
        upBtnPath.line(to: NSMakePoint(NSMaxX(upImagerect), NSMaxY(upImagerect)))
        NSColor.black.set()
        upBtnPath.stroke()
        
        //draw daown button
        let downButtonRect:NSRect = downButtonArea(frame: cellFrame)
        let downImagerect:NSRect = NSInsetRect(downButtonRect, 4, 4)
        let downBtnpath:NSBezierPath = NSBezierPath.init()
        downBtnpath.move(to: downImagerect.origin)
        downBtnpath.line(to: NSMakePoint(downImagerect.width / 2 + NSMinX(downImagerect), downImagerect.origin.y + downImagerect.height))
        downBtnpath.line(to: NSMakePoint(downImagerect.width + NSMinX(downImagerect), downImagerect.origin.y))
        
        NSColor.black.set()
        downBtnpath.stroke()
        
        
        textControl.cell?.draw(withFrame: titleRect(forBounds: cellFrame), in: controlView)
        
        
    }
    
    func downButtonArea(frame cellFrame:NSRect) -> NSRect {
        let buttonWidth:CGFloat = NSMaxY(cellFrame) / 2
        
        let originalX:CGFloat = NSMaxX(cellFrame) - buttonWidth
        
        let origianlY:CGFloat = NSMaxY(cellFrame) - buttonWidth
        
        return NSMakeRect(originalX, origianlY, buttonWidth, buttonWidth)
        
    }
  
    func upButtonArea(frame cellFrame:NSRect) -> NSRect{
        let buttonWidth:CGFloat = NSMaxY(cellFrame) / 2
        let originalX:CGFloat = NSMaxX(cellFrame) - buttonWidth
        
        let origianlY:CGFloat = NSMinY(cellFrame)
        
        return NSMakeRect(originalX, origianlY, buttonWidth, buttonWidth)
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return NSInsetRect(NSMakeRect(rect.origin.x, rect.origin.y + 7.5, rect.size.width - rect.size.height / 2, rect.size.height - 15), 0, 0)
    }
    
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        //Get the parent's idea of where we should draw
        var newRect:NSRect = super.drawingRect(forBounds: theRect)
        
        // When the text field is being edited or selected, we have to turn off the magic because it screws up
        // the configuration of the field editor.  We sneak around this by intercepting selectWithFrame and editWithFrame and sneaking a
        // reduced, centered rect in at the last minute.
        
        if !mIsEditingOrSelecting {
            // Get our ideal size for current text
            newRect = titleRect(forBounds: theRect)
        }
        
        return newRect
    }
    override func select(withFrame rect: NSRect,in controlView: NSView,editor textObj: NSText,delegate: Any?,start selStart: Int,length selLength: Int){
        self.stringValue = textControl.stringValue
        let arect = self.drawingRect(forBounds: rect)
        mIsEditingOrSelecting = true;
        super.select(withFrame: arect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
        mIsEditingOrSelecting = false;
    }
    
    override func edit(withFrame rect: NSRect,in controlView: NSView,editor textObj: NSText,delegate: Any?,event: NSEvent?){
        let aRect = self.drawingRect(forBounds: rect)
        mIsEditingOrSelecting = true;
        super.edit(withFrame: aRect, in: controlView, editor: textObj, delegate: delegate, event: event)
        mIsEditingOrSelecting = false
    }
}
//tracking event
extension SpinBoxButtonCell{
    
}
