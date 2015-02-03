import Foundation
import UIKit

let data: String = "#t x y\n1 1 2\n2 1 2\n3 2 1"
let lines = split(data) { $0 == "\n" }
var out: [[Float]] = [[0,0]]
println(out)
for line in lines {
  if !line.hasPrefix("#") {
    let cols = split(line) { $0 == " " }
    out.append([0,0])
  }
}
out


func addFromString(data: String, xCol: Int, yCol: Int) -> [[CGFloat]] {
  var result: [[CGFloat]] = []
  let lines = split(data) { $0 == "\n" }
  for line in lines {
    if !line.hasPrefix("#") {
      let cols = split(line) { $0 == " " }
      let x = cols[xCol] as NSString
      let y = cols[yCol] as NSString
      result.append([CGFloat(x.floatValue), CGFloat(y.floatValue)])
    }
  }
  return result
}

addFromString(data, 0, 0)