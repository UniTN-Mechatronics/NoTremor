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