//
//  Document.swift
//  Lines
//
//  Created by Paolo Bosetti on 02/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import Foundation
import UIKit

class MXDocument: NSObject {
  var folderPath: String
  var fileName: String
  
  var fileExt: String {
    get { return fileName.pathExtension }
  }
  
  var filePath: String {
    get { return "\(folderPath)/\(fileName)"}
  }
  
  var fileURL: NSURL {
    get { return NSURL(fileURLWithPath: self.filePath) }
  }
  
  var fileExists: Bool {
    get { return NSFileManager.defaultManager().fileExistsAtPath(self.filePath) }
  }
  
  var fileAttr: [NSObject: AnyObject] {
    get {
      if self.fileExists {
        var attr: [NSObject: AnyObject] = NSFileManager.defaultManager().attributesOfItemAtPath(self.filePath, error: nil)!
        return attr
      }
      else {
        return [:]
      }
    }
  }
  
  var fileDescription: String {
    get {
      if (self.fileExists) {
        return String(format: "%@ (%lu kb)", self.fileName, self.fileAttr[NSFileSize]!.integerValue / 1024)
      }
      else {
        return "File \(self.fileName) does not exist!"
      }
    }
  }
  
  class func humanName() -> String {
    return "Generic file"
  }
  
  class func UTI() -> String {
    return "public.plain-text"
  }
  
  class func extensions() -> [String] {
    return [""]
  }
  
  class func filterFileNames(list: [String], atPath: String) -> [MXDocument] {
    var result :[MXDocument] = []
    for ext in self.extensions() {
      for name in list {
        if name.pathExtension == ext {
          result.append(MXDocument(fileName: name))
        }
      }
    }
    return result
  }
  
  override init() {
    folderPath = NSHomeDirectory().stringByAppendingPathComponent("Documents")
    fileName = ""
  }
  
  convenience init(fileName name: String) {
    self.init()
    fileName = name
  }
  
  func inspect() {
    NSLog("%@", self.fileDescription)
  }
  
  
}