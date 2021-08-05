//
//  SerializableColor.swift
//  ToDoToday
//
//  Created by Noe De La Croix on 05/08/2021.
//

import Foundation
import struct CoreGraphics.CGFloat
import class CoreGraphics.CGColor
import class CoreGraphics.CGColorSpace
import class UIKit.UIColor
import struct SwiftUI.Color

public class SerializableColor: NSObject, NSCoding, NSSecureCoding {
  public static var supportsSecureCoding: Bool = true
  
  public enum SerializableColorSpace: Int {
    case sRGB = 0
    case displayP3 = 1
  }
  
  let colorSpace: SerializableColorSpace
  let r: Float
  let g: Float
  let b: Float
  let a: Float
  
  public func encode(with coder: NSCoder) {
    coder.encode(colorSpace.rawValue, forKey: "colorSpace")
    coder.encode(r, forKey: "red")
    coder.encode(g, forKey: "green")
    coder.encode(b, forKey: "blue")
    coder.encode(a, forKey: "alpha")
  }
  
  required public init?(coder: NSCoder) {
    colorSpace = SerializableColorSpace(rawValue: coder.decodeInteger(forKey: "colorSpace")) ?? .sRGB
    r = coder.decodeFloat(forKey: "red")
    g = coder.decodeFloat(forKey: "green")
    b = coder.decodeFloat(forKey: "blue")
    a = coder.decodeFloat(forKey: "alpha")
  }
  
  init(colorSpace: SerializableColorSpace, red: Float, green: Float, blue: Float, alpha: Float) {
    self.colorSpace = colorSpace
    self.r = red
    self.g = green
    self.b = blue
    self.a = alpha
  }
  
  convenience init(from cgColor: CGColor) {
    var colorSpace: SerializableColorSpace = .sRGB
    var components: [Float] = [0, 0, 0, 0]
    
    // Transform the color into sRGB space
    if cgColor.colorSpace?.name == CGColorSpace.displayP3 {
      if let p3components = cgColor.components?.map({ Float($0) }),
         cgColor.numberOfComponents == 4 {
        colorSpace = .displayP3
        components = p3components
      }
    } else {
      if let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
         let sRGBColor = cgColor.converted(to: sRGB, intent: .defaultIntent, options: nil),
         let sRGBcomponents = sRGBColor.components?.map({ Float($0) }),
         sRGBColor.numberOfComponents == 4 {
        components = sRGBcomponents
      }
    }
    self.init(colorSpace: colorSpace, red: components[0], green: components[1], blue: components[2], alpha: components[3])
  }
  
  convenience init(from color: Color) {
    self.init(from: UIColor(color))
  }
  
  convenience init(from uiColor: UIColor) {
    self.init(from: uiColor.cgColor)
  }
  
  var cgColor: CGColor {
    return uiColor.cgColor
  }
  
  var color: Color {
    return Color(self.uiColor)
  }
  
  var uiColor: UIColor {
    if colorSpace == .displayP3 {
      return UIColor(displayP3Red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    } else {
      return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
  }
}

// MARK: Transformer Class
// For CoreData compatibility.

@objc(SerializableColorTransformer)
class SerializableColorTransformer: NSSecureUnarchiveFromDataTransformer {
  override class var allowedTopLevelClasses: [AnyClass] {
    return super.allowedTopLevelClasses + [SerializableColor.self]
  }
  
  public override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  public override func transformedValue(_ value: Any?) -> Any? {
    guard let data = value as? Data else {return nil}
    return try! NSKeyedUnarchiver.unarchivedObject(ofClass: SerializableColor.self, from: data)
  }
  
  public override func reverseTransformedValue(_ value: Any?) -> Any? {
    guard let color = value as? SerializableColor else {return nil}
    return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
  }
}




