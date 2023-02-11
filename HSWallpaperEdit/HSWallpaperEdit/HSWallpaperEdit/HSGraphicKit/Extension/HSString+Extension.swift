//
//  HSString+Extension.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/14.
//

import Foundation

extension String {

    func substringFromIndex(index:Int) ->String {
        guard index < self.count else {
            print("超出边界")
            return ""
        }
        var tempStr = self
        let subIndex = index < 0 ? 0 : index
        let targetIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        tempStr.removeSubrange(tempStr.startIndex...targetIndex)
        return tempStr
    }
    
    func substringToIndex(index:Int) ->String {
        guard index < self.count else {
            print("超出边界")
            return ""
        }
        let subIndex = index < 0 ? 0 : index
        var tempStr = self
        let targetIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        tempStr.removeSubrange(targetIndex...)
        return tempStr
    }
    
    func substringWithRange(loc:Int,len:Int) ->String {
        guard loc < self.count else {
            print("裁剪位置超出边界")
            return ""
        }
        guard len < self.count else {
            print("裁剪长度超出边界")
            return ""
        }
        let subIndex = loc < 0 ? 0 : loc
        let end = subIndex + len - 1
        guard end < self.count else {
            print("裁剪长度超出边界")
            return ""
        }
        let tempStr = self
        let startIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        let endIndex = tempStr.index(tempStr.startIndex, offsetBy: end)
        return String.init(tempStr[startIndex...endIndex])
    }
    
    func stringByReplacingOccurrencesOfString(replaceString:String,targetString:String) ->String {
        guard self.contains(replaceString) else {
            print("不包含要替换的字符")
            return ""
        }
        var tempStr = self
        tempStr = tempStr.replacingOccurrences(of: replaceString, with: targetString)
        return tempStr
    }
    
    
    static func convertDictionaryToString(dict:[String: Any]) -> String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = ""
        }
        return result
    }
    
    static func convertStringToDictionary(text: String) -> [String:Any]? {
      if let data = text.data(using: String.Encoding.utf8) {
          do {
              return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
          } catch let error as NSError {
              print(error)
          }
      }
      return nil
    }
}
