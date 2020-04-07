//
//  DeepLinkManager.swift
//  GenericRouter
//
//  Created by William Huang on 7/4/20.
//  Copyright © 2020 Whuangz. All rights reserved.
//

import Foundation
import Common

public class Router: NSObject {

    var routes: Array<Route> = []

    struct RouterPage {
        var target: String
        var parameters : Dictionary<String,String>
    }

    struct Route {

        enum Component {
            case constant(String)
            case parameter(String)
        }

        var components: Array<Component>
        var target: String

        init(pattern: String, target: String) {
            self.components = pattern
                .components(separatedBy: "/")
                .map({ part -> Component in
                    if part.first == ":" {
                        return .parameter(String(part.dropFirst()))
                    } else {
                        return .constant(part)
                    }
                })
            self.target = target
        }

        func matches(_ pathComponents: [String]) -> RouterPage?{
            guard components.count == pathComponents.count else {return nil}
            var parameters : Dictionary<String,String> = [:]
            for (component, input) in zip(components, pathComponents){
                print(component, ":", input)
                switch component {
                case .constant(let value):
                    guard input == value else {return nil}
                case .parameter(let name):
                    parameters[name] = input
                }


                
            }
            print(parameters)
            return RouterPage(target: self.target, parameters: parameters)
        }
    }

    override init() {

    }

    func register(_ pattern: String, target: String){
        routes.append(Route(pattern: pattern, target: target))
    }

    func matches(_ url: URL) -> RouterPage?{
        let pathComponents = url.path.components(separatedBy: "/")
        for route in routes {
            if let match = route.matches(pathComponents){
                return match
            }
        }
        return nil
    }
}
    
public class DeepLinkingManager: Router{

    static let shared = DeepLinkingManager()
    
    override init(){
        super.init()
        self.register("/home" , target:"HOME")
        self.register("/detail/:slug", target: "DETAIL")
    }
    
    func isDefaultScheme(from url: URL?) -> Bool {
        let defaultScheme = ["https://www.yourdomain.com"]

        for txt in defaultScheme {
            if (txt == url?.absoluteString) {
                return true
            }
        }


        return false

    }

    
    func routeTo(url: URL) -> (DeeplinkType, Bool){
        
        if (self.isDefaultScheme(from: url)){
            return (.toHomePage, true)
        }
        
        let trimming = self.trimLocalization(for: url.absoluteString)
        if let trimUrl = URL(string: trimming ?? ""), let page = self.matches(trimUrl) {
            return (getRoutingType(from: page), true)
        }
        return (.webview(url.absoluteString, true), true)
    }
    
    
    func trimLocalization(for path: String?) -> String? {
        var components: [String]? = nil
        if let components1 = path?.components(separatedBy: "/") {
            components = components1
        }
        let appLocalization = ["id", "en"]
        for locale in appLocalization {
            let idx = components?.firstIndex(of: locale) ?? NSNotFound
            if idx < (components?.count ?? 0) {
                if (components?[idx] == locale) {
                    components?.remove(at: idx)
                }
            } else {
                break
            }
        }

        return components?.joined(separator: "/")
    }
}


extension DeepLinkingManager {
    
    func getRoutingType(from page: RouterPage) -> DeeplinkType {
        switch page.target {
        case "HOME":
            return .toHomePage
        case "DETAIL":
            return .toDetailPage(page.parameters["slug"])
        default:
            return .toHomePage
        }
    }
}
