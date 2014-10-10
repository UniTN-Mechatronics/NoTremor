//
//  LogDocument.swift
//  Lines
//
//  Created by Paolo Bosetti on 02/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import Foundation

class MXLogDocument: MXDocument {
  
  override class func humanName() -> String {
    return "Log file"
  }
  
  override class func UTI() -> String {
    return "public.plain-text"
  }
  
  override class func extensions() -> [String] {
    return ["txt", "dat", "log"]
  }
  

}