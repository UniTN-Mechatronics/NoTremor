//
//  Test.swift
//  Lines
//
//  Created by Paolo Bosetti on 02/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import Foundation
import UIKit

class MXTestClass: UIView {
  var name: String?
  
  convenience init(name: String) {
    self.init()
    self.name = name
  }
  
  func inspect() -> String {
    return "My name is \(self.name)"
  }
}

