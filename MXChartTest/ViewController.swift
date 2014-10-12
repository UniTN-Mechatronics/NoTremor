//
//  ViewController.swift
//  MXChartTest
//
//  Created by Paolo Bosetti on 11/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var chartView: MXChart!
  
  @IBAction func toggle(sender: UITapGestureRecognizer) {
    self.active = !self.active
  }
  
  var count: Int64 = 0
  var active: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chartView.series["a"] = MXDataSeries(name: "test")
    chartView.series["a"]?.randomFill(0, to: 1, length: 1)
    chartView.series["a"]?.lineWidth = 1
    chartView.series["a"]?.capacity = 100
    count = 0
    var timer = NSTimer.scheduledTimerWithTimeInterval(1.0 / 60.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func update() {
    if (active) {
      count++
      let y: CGFloat = CGFloat(rand()) / CGFloat(RAND_MAX) * 2 - 1
      chartView.addPointToSerie("a", x: CGFloat(count), y: y)
      chartView.autoRescaleOnSerie("a", axes: (true, false))
    }
  }


}

