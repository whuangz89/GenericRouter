//
//  DeepLinkNavigator.swift
//  
//
//  Created by William Huang on 7/4/20.
//

import Foundation
import UIKit

//Common module will be used as shared navigator if you build your app in modular way

public enum DeeplinkType {
    case toHomePage
    case toDetailPage(Any) //Any for handling open detail with id or slug or something you prefer
    case webview(String, Bool)
}

public class DeepLinkNavigator {
    public static let shared = DeepLinkNavigator()
    private var deeplinkType: DeeplinkType?


    public var navigatorFactory: NavigatorFactory?

    
    public func navigate(to type: DeeplinkType, from: UIViewController?, completion: (() -> ())?) {
        deeplinkType = type
        self.navigatorFactory?.navigate(to: type, from: from, completion: completion)
        
    }
    
    public func deepLink(with url: String, from: UIViewController?) -> Bool {
        return self.navigatorFactory?.deepLink(with: url, from: from) ?? false
    }
    
}

public protocol NavigatorFactory {
    func navigate(to type: DeeplinkType, from: UIViewController?, completion: (()->())?)
    func deepLink(with url: String, from: UIViewController?) -> Bool
}
