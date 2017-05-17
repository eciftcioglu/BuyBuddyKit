// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr) Thanks :)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Alamofire
import Foundation

public class Endpoint{
    
    public static func buildURL(endPoint: String, values: [String: AnyObject]? = nil) -> (method: HTTPMethod,
        URL: NSURL,
        otherValues: [String: AnyObject]?) {
            let method: HTTPMethod
            var path: String
            
            // e.g. "GET /me" -> ["GET", "/me"]
            let whitespace = NSCharacterSet.whitespaces
            let components = endPoint.components(separatedBy: whitespace).filter { !$0.isEmpty }
            if components.count > 1 {
                method = HTTPMethod(rawValue: components[0]) ?? .get
                path = components[1]
            } else {
                method = .get
                path = components[0]
            }
            
            var placeholders = [String]()
            
            // replace `<key>` with `value`
            for (key, value) in values ?? [:] {
                let pattern = "<" + key + ">" // 3x faster than "<\(key)>"
                let replacement = value as? String ?? String(describing: value)
                
                if path.contains(pattern) {
                    path = path.replacingOccurrences(of: pattern, with: replacement)
                    placeholders.append(key)
                }
            }
            
            var otherValues = values
            for key in placeholders {
                otherValues?.removeValue(forKey: key) // remove URL placeholder values
            }
            
            
            let URL = NSURL(string: BuyBuddyApi.getBaseUrl() + path)!
            return (method, URL, otherValues)
    }
    
}
