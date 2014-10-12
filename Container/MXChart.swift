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
  var capacity: Int?
  
  init(name: String) {
    self.name = name
  }
  
  func randomFill(from: CGFloat, to: CGFloat, length: Int) {
    var x, y: CGFloat
    let rng = to - from
    for i in 0...length {
      x = from + (CGFloat(i) / CGFloat(length)) * rng
      y = CGFloat(rand()) / CGFloat(RAND_MAX)
      data.append(CGPointMake(x, y))
    }
  }
  
  func append(x: CGFloat, y: CGFloat) {
    let p = CGPointMake(x, y)
    data.append(p)
    if (self.capacity != nil && data.count > self.capacity){
      data.removeAtIndex(0)
    }
  }
  
  func range() -> CGRect {
    let yRange = data.reduce((data.first?.y, data.first?.y)) { (min($0.0!, $1.y), max($0.1!, $1.y)) }
    let xRange = (data.first?.x, data.last?.x)
    return CGRectMake(xRange.0!, yRange.0!, xRange.1! - xRange.0!, yRange.1! - yRange.0!)
  }
  
}

@IBDesignable class MXChart : UIView {
  @IBInspectable var borderColor: UIColor = UIColor.blackColor()
  @IBInspectable var fillColor: UIColor   = UIColor.clearColor()
  @IBInspectable var defaultPlotColor: UIColor   = UIColor.redColor()
  @IBInspectable var axesColor: UIColor   = UIColor.grayColor()
  @IBInspectable var textColor: UIColor   = UIColor.blackColor()
  @IBInspectable var borderWidth: CGFloat  = 1
  @IBInspectable var cornerRadius: CGFloat = 3
  
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

  var series = Dictionary<String,MXDataSeries>()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    drawChartView(fillColor, rectangle: self.bounds, strokeWidth: borderWidth, radius: cornerRadius, xLabelText: xLabel, yLabelText: yLabel)
    
  }
  
  override func prepareForInterfaceBuilder() {
    var x, s, c: CGFloat
    let n = 100
    series.removeAll(keepCapacity: false)
    
    series["sin"] = MXDataSeries(name: "Sine")
    series["sin"]!.lineColor = self.defaultPlotColor
    series["sin"]!.lineWidth = 1
    
    series["cos"] = MXDataSeries(name: "Cosine")
    series["cos"]!.lineColor = UIColor.blueColor()
    series["cos"]!.lineWidth = 1
    
    for i in 0...n {
      x = CGFloat(CGFloat(i) * CGFloat(range.width) / CGFloat(n) + CGFloat(range.origin.x))
      s = CGFloat(sin(x))
      c = CGFloat(cos(x))
      series["sin"]?.append(x, y: s)
      series["cos"]?.append(x, y: c)
    }

    series["rnd"] = MXDataSeries(name: "Random")
    series["rnd"]?.randomFill(range.origin.x, to: range.origin.x + range.width, length: n)
    series["rnd"]!.lineColor = UIColor.greenColor()
    series["rnd"]!.lineWidth = 2
  }
  
  func remap(point: CGPoint, fromRect: CGRect, toRect: CGRect) -> CGPoint {
    var p = CGPointMake(0, 0)
    p.x = ((point.x - fromRect.origin.x) / fromRect.width) * toRect.width + toRect.origin.x
    p.y = ((point.y - fromRect.origin.y) / fromRect.height) * toRect.height + toRect.origin.y
    p.y = -p.y + toRect.height
    return p
  }
  
  func addPointToSerie(serie: String, x: CGFloat, y: CGFloat) {
    self.series[serie]?.append(x, y: y)
    self.setNeedsDisplay()
  }
  
  func autoRescaleOnSerie(serie: String, axes: (x: Bool, y: Bool) ) {
    let s = self.series[serie]
    let rect = s!.range()
    let (x, y, width, height) = (rect.origin.x, rect.origin.y, rect.width, rect.height)
    switch axes {
    case (true, _):
      self.range.origin.x = x
      self.range.size.width = width
    case (_, true):
      self.range.origin.y = y
      self.range.size.height = height
    default:
      return
    }
    self.setNeedsDisplay()
  }
  
  func drawPlot(inRect: CGRect, atOffset: CGPoint) {
    let context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)
    CGContextTranslateCTM(context, atOffset.x, atOffset.y)
    
    for (name, serie) in series {
      var bezierPath = UIBezierPath()
      var p = remap(serie.data[0], fromRect: range, toRect: inRect)
      bezierPath.moveToPoint(p)
      for i in 1..<serie.data.count {
        p = remap(serie.data[i], fromRect: range, toRect: inRect)
        bezierPath.addLineToPoint(p)
      }
      serie.lineColor.setStroke()
      bezierPath.lineWidth = serie.lineWidth
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

