//
//  MXChart.swift
//  Lines
//
//  Created by Paolo Bosetti on 07/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import UIKit

class MXDataSeries {
  var data = Array<CGPoint>()
  var name = String()
  var lineColor: UIColor = UIColor.redColor()
  var lineWidth: CGFloat = 1
  
  init(name: String) {
    self.name = name
  }
  
}

@IBDesignable class MXChart : UIView {
  @IBInspectable var borderColor: UIColor = UIColor.blueColor()
  @IBInspectable var fillColor: UIColor   = UIColor.clearColor()
  @IBInspectable var plotColor: UIColor   = UIColor.redColor()
  @IBInspectable var axesColor: UIColor   = UIColor.grayColor()
  @IBInspectable var textColor: UIColor   = UIColor.blackColor()
  @IBInspectable var borderWidth: CGFloat  = 1
  @IBInspectable var cornerRadius: CGFloat = 5
  
  @IBInspectable var xLabel: String = "X axis"
  @IBInspectable var yLabel: String = "Y axis"
  @IBInspectable var range: CGRect = CGRectMake(-1, -2, 20, 4) {
    didSet {
      if (self.range.width <= 0 || self.range.height <= 0) {
        range = CGRectMake(range.origin.x, range.origin.y, 20, 4)
      }
    }
  }

  @IBInspectable var showXAxis: Bool = true
  @IBInspectable var showYAxis: Bool = true

  var series = [String(): Array<CGPoint>()]
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    drawChartView(fillColor, rectangle: self.bounds, strokeWidth: borderWidth, radius: cornerRadius, xLabelText: xLabel, yLabelText: yLabel)
    
  }
  
  override func prepareForInterfaceBuilder() {
    var x, y, z: CGFloat
    let n = 100
    series.removeAll(keepCapacity: false)
    series["Sin"] = Array<CGPoint>()
    series["Sin"]!.removeAll(keepCapacity: false)
    series["Cos"] = Array<CGPoint>()
    series["Cos"]!.removeAll(keepCapacity: false)
    for i in 0...n {
      x = CGFloat(CGFloat(i) * CGFloat(range.width) / CGFloat(n) + CGFloat(range.origin.x))
      y = CGFloat(sin(x))
      z = CGFloat(cos(x))
      series["Sin"]!.append(CGPointMake(x, y))
      series["Cos"]!.append(CGPointMake(x, z))
    }
  }
  
  func remap(point: CGPoint, fromRect: CGRect, toRect: CGRect) -> CGPoint {
    var p = CGPointMake(0, 0)
    p.x = ((point.x - fromRect.origin.x) / fromRect.width) * toRect.width + toRect.origin.x
    p.y = ((point.y - fromRect.origin.y) / fromRect.height) * toRect.height + toRect.origin.y
    p.y = -p.y + toRect.height
    return p
  }
  
  func drawPlot(inRect: CGRect, atOffset: CGPoint) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, atOffset.x, atOffset.y)
    
    for serie in series.keys {
      var bezierPath = UIBezierPath()
      var p = remap(series[serie]![0], fromRect: range, toRect: inRect)
      bezierPath.moveToPoint(p)
      for i in 1..<series[serie]!.count {
        p = remap(series[serie]![i], fromRect: range, toRect: inRect)
        bezierPath.addLineToPoint(p)
      }
      plotColor.setStroke()
      bezierPath.lineWidth = 1
      bezierPath.stroke()
    }
    
    if (showXAxis) {
      var xAxisPath = UIBezierPath()
      CGContextSaveGState(context)
      CGContextSetLineDash(context, 0, [4, 2], 2)
      xAxisPath.moveToPoint(remap(CGPointMake(range.origin.x, 0), fromRect: range, toRect: inRect))
      xAxisPath.addLineToPoint(remap(CGPointMake(range.origin.x + range.width, 0), fromRect: range, toRect: inRect))
      self.axesColor.setStroke()
      xAxisPath.stroke()
      CGContextRestoreGState(context)
    }
    
    if (showYAxis) {
      var yAxisPath = UIBezierPath()
      CGContextSaveGState(context)
      CGContextSetLineDash(context, 0, [4, 2], 2)
      yAxisPath.moveToPoint(remap(CGPointMake(0, range.origin.y), fromRect: range, toRect: inRect))
      yAxisPath.addLineToPoint(remap(CGPointMake(0, range.origin.y + range.height), fromRect: range, toRect: inRect))
      self.axesColor.setStroke()
      yAxisPath.stroke()
      CGContextRestoreGState(context)
    }

    CGContextRestoreGState(context)
  }
  
  func drawChartView(fillColor: UIColor, rectangle: CGRect, strokeWidth: CGFloat, radius: CGFloat, xLabelText: String, yLabelText: String) {
    //// General Declarations
    let context = UIGraphicsGetCurrentContext()
    
    
    //// Variable Declarations
    let labelHeight: CGFloat = 15
    let rectWidth = rectangle.width - labelHeight - strokeWidth
    let rectHeight = rectangle.height - labelHeight - strokeWidth
    let minusHeight = -rectHeight
    let rectOffset = CGPointMake(rectangle.origin.x, rectangle.origin.y + strokeWidth / 2.0)
    
    //// Chart Drawing
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, rectOffset.x, rectOffset.y)
    let chartRect = CGRectMake(labelHeight + strokeWidth / 2.0, 0, rectWidth, rectHeight)
    let chartPath = UIBezierPath(roundedRect: chartRect, cornerRadius: radius)
    fillColor.setFill()
    borderColor.setStroke()
    chartPath.fill()
    chartPath.lineWidth = strokeWidth
    chartPath.stroke()
    
    CGContextRestoreGState(context)
    
    //// Draw data
    drawPlot(chartRect, atOffset: rectOffset)
    
    //// Label styles
    let labelFont = UIFont(name: "Helvetica", size: 9)
    let labelColor = self.textColor
    let cLabelStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
    let lLabelStyle: NSMutableParagraphStyle = cLabelStyle.mutableCopy() as NSMutableParagraphStyle
    let rLabelStyle: NSMutableParagraphStyle = cLabelStyle.mutableCopy() as NSMutableParagraphStyle
    
    cLabelStyle.alignment = NSTextAlignment.Center
    lLabelStyle.alignment = NSTextAlignment.Left
    rLabelStyle.alignment = NSTextAlignment.Right
    
    let labelFontAttributes = [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelColor, NSParagraphStyleAttributeName: cLabelStyle]
    let minLabelFontAttributes = [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelColor, NSParagraphStyleAttributeName: lLabelStyle]
    let maxLabelFontAttributes = [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelColor, NSParagraphStyleAttributeName: rLabelStyle]

    //// xLabel Drawing
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, rectOffset.x, rectOffset.y)
    
    let xLabelRect = CGRectMake(labelHeight, rectHeight + strokeWidth / 2.0, rectWidth + strokeWidth, labelHeight)
    NSString(string: xLabelText).drawInRect(xLabelRect, withAttributes: labelFontAttributes);
    NSString(string: "\(range.origin.x)").drawInRect(xLabelRect, withAttributes: minLabelFontAttributes);
    NSString(string: "\(range.origin.x + range.width)").drawInRect(xLabelRect, withAttributes: maxLabelFontAttributes);
    CGContextRestoreGState(context)
    
    
    //// yLabel Drawing
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, rectOffset.x, rectOffset.y)
    CGContextRotateCTM(context, -90 * CGFloat(M_PI) / 180)
    
    let yLabelRect = CGRectMake(minusHeight, 0, rectHeight, labelHeight)
    
    NSString(string: yLabelText).drawInRect(yLabelRect, withAttributes: labelFontAttributes);
    NSString(string: "\(range.origin.y)").drawInRect(yLabelRect, withAttributes: minLabelFontAttributes);
    NSString(string: "\(range.origin.y + range.height)").drawInRect(yLabelRect, withAttributes: maxLabelFontAttributes);
    CGContextRestoreGState(context)
  }

  
}

