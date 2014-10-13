// Playground - noun: a place where people can play

import MXDocuments
print(MXDocumentsVersionNumber)

let minValue: Float = [1,9,0,-2].reduce(Float.infinity, combine:min)
minValue

var h = ["a":1, "b":2]
h["c"] = 3
print(h)

var series = [String(): Array<CGPoint>()]
series.removeAll(keepCapacity: false)
series["A"] = Array<CGPoint>()
series["A"]!.append(CGPointMake(0,0))
print(series)

Float64(random()) / Float64(RAND_MAX)


var y: CGFloat = 0

y = CGFloat(random()) / CGFloat(RAND_MAX)

var pair = (1, 2, 3)
print(pair.0 > pair.2)




var list = [CGPointMake(0, 2), CGPointMake(1, 10), CGPointMake(2, -5)]

var listMin = list.reduce((list[0].y, list[0].y)) { (min($0.0, $1.y), max($0.1, $1.y)) }
print(listMin.1 - listMin.0)


let what = (x:true, y:false)
switch what {
case (true, _):
  println("OK 1")
case (_, true):
  println("OK 2")
default:
  print("oh no")
}

var a, b: Int?
a = 1
b = 2

switch (a, b) {
case (.Some(let a1), .Some(let b1)):
  print("OK: \(a1), \(b1)")
default:
  print("NO")
}


var ary = [1, 2, 3, 4, 5, 6, 7, 8, 9]
ary.removeRange(0..<(ary.count - 7))
print(ary)




