//
//  MXDocumentsList.swift
//  Lines
//
//  Created by Paolo Bosetti on 02/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import Foundation

class MXDocumentsList: NSObject {
  var list: Dictionary<String,[MXDocument]> = [:]
  var types: Array<MXDocument.Type> = []
  var folderPath: String = ""
  
  class func documentsListAtPath(path: String, forTypes: [MXDocument.Type]) -> MXDocumentsList {
    var result: MXDocumentsList?
    result?.scanFolder(path, forTypes: forTypes)
    return result!
  }
    
  override init() {
    self.folderPath = "\(NSHomeDirectory())Documents"
    self.types = [MXLogDocument.self , MXMovieDocument.self]
  }
  
  func scanFolder(path: String?, forTypes:[MXDocument.Type]?) {
    if (path != nil) {
      self.folderPath = path!
    }
    if (forTypes != nil) {
      self.types = forTypes!
    }
    let manager = NSFileManager.defaultManager()
    let allItems = manager.contentsOfDirectoryAtPath(self.folderPath, error: nil) as [String]
    var docsList: [MXDocument] = []
    for k in self.types {
      let n = k.humanName()
      docsList = k.filterFileNames(allItems, atPath: self.folderPath)
      self.list[n] = docsList
    }
  }
  
  func documentAtIndexPath(indexPath: NSIndexPath) -> MXDocument {
    return MXDocument()
  }
  
  func removeDocumentAtIndexPath(indexPath: NSIndexPath) {
    let key = self.types[indexPath.section].humanName()
    let idx = indexPath.row
    let doc = self.list[key]?[idx];
    list[key]?.removeAtIndex(idx)
    NSFileManager.defaultManager().removeItemAtPath(doc!.filePath, error:nil);
  }
  
  func sectionAtIndex(index: Int) -> String {
    return self.list.keys.array[index]
  }
  
}