//
//  MXMovieDocument.swift
//  Lines
//
//  Created by Paolo Bosetti on 02/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import Foundation

class MXMovieDocument: MXDocument {
  
  override class func humanName() -> String {
    return "Screen cap"
  }
  
  override class func UTI() -> String {
    return "public.movie"
  }
  
  override class func extensions() -> [String] {
    return ["mp4"]
  }
  
  
}