//
//  Weather.swift
//  APIKitSample
//
//  Created by ShinichiHirauchi on 2015/12/22.
//  Copyright © 2015年 SAPPOROWORKS. All rights reserved.
//

import Foundation
import APIKit



protocol WeatherRequestType : RequestType {
}

extension WeatherRequestType {
    var baseURL:NSURL {
        return NSURL(string: "http://weather.livedoor.com/forecast/webservice/json")!
    }
}

import Result


struct GetWeatherRequest: WeatherRequestType {
    typealias Response = WeatherData
    let _city:Int
    init(city:Int){
        _city = city
    }
    
    var method: HTTPMethod {
        return .GET
        // 任意のデータ送信
        //return .POST
    }
    
    var path: String {
        return "/v1"
    }
    
    var parameters: [String: AnyObject] {
        return [
            // cityパラメータは6桁の数値（文字列）
            "city": NSString(format: "%6.6d", _city),
        ]
    }

      // 任意のデータ送信
//    var requestBodyBuilder: RequestBodyBuilder {
//        return .Custom(contentTypeHeader: "text/plain",
//                       buildBodyFromObject: { o in
//                            let str = "Hello\r\n"
//                            return str.dataUsingEncoding(NSUTF8StringEncoding)!
//                       })
//    }
    
    
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        
        guard let dictionary = object as? [String: AnyObject] else {
            return nil
        }
        
        guard let weatherData = WeatherData(dictionary: dictionary) else {
            return nil
        }
        
        return weatherData
    }
}

struct WeatherData {
    var title: String = ""
    var description: String = ""
    var today:String = ""
    var tomorrow: String = ""
    
    
    init?(dictionary: [String: AnyObject]) {
        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let description = dictionary["description"]?["text"] as? String else {
            return nil
        }

        guard let array = dictionary["forecasts"] as? NSArray else {
            return nil
        }
        for a in array {
            if let dateLabel = a["dateLabel"] as? String {
                if dateLabel == "今日" {
                    guard let today = a["telop"] as? String else {
                        return nil
                    }
                    self.today = today
                } else if dateLabel == "明日"{
                    guard let tomorrow = a["telop"] as? String else {
                        return nil
                    }
                    self.tomorrow = tomorrow
                }
            }
        }
        self.title = title
        self.description = description
    }
}




