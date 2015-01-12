// Playground - noun: a place where people can play

import UIKit

class Stacker {

var arrayOfBugs = ["Ant", "Fly", "Beetle", "Mantis", "Worm"]

  func push(thingToPush: String){
    self.arrayOfBugs.append(thingToPush)
}


  func pop() -> String?{
  if arrayOfBugs.isEmpty == false {
    let bug = self.arrayOfBugs.last
    self.arrayOfBugs.removeLast()
    return bug
  }else{
    return nil
  }
}

func peek() -> String? {
  return self.arrayOfBugs.last
}
  
}

var S = Stacker()

S.push("BEE")
S.pop()
S.peek()
S.peek()
