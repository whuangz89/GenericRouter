//
//  NavigatorIntegrator.swift
//  GenericRouter
//
//  Created by William Huang on 7/4/20.
//  Copyright © 2020 Whuangz. All rights reserved.
//

import UIKit
import Common

public class NavigatorIntegrator: NSObject, NavigatorFactory {

    private var window: UIWindow?
    private var deepLinkManager: DeepLinkingManager!
    
    public func deepLink(with url: String, from: UIViewController?) -> Bool {
        if let url = URL(string: url) {
            let (type, isDeeplink) = deepLinkManager.routeTo(url: url)
            let isFromWebview = (from is MyWebviewVC) // used to handler in app deeplinking (use ur own webview)
            
            var shouldDeeplink = true
            switch type {
            case .webview:
                shouldDeeplink = !isFromWebview
                break
            default:
                shouldDeeplink = true
                break
            }
            
            if isDeeplink && shouldDeeplink{
                processRouting(for: type, from: from, completion: nil)
                return isDeeplink
            }
        }
        return false
    }

    public func navigate(to type: DeeplinkType, from: UIViewController?, completion: (() -> ())?) {
        processRouting(for: type, from: from, completion: completion)
    }
    
    func proceedToDeeplink(url: String? = nil, type: DeeplinkType? = nil, from: UIViewController?) -> Bool {
        if let type = type {
            processRouting(for: type, from: from, completion: nil)
            return false
        }else if let url = URL(string: url ?? "") {
            let (type, isDeeplink) = deepLinkManager.routeTo(url: url)
            processRouting(for: type, from: from, completion: nil)
            return isDeeplink
        }
        return false
    }
    
    
    @objc public init(with window: UIWindow?){
        self.window = window
        deepLinkManager = DeepLinkingManager.shared
        super.init()
        
        let dl = DeepLinkNavigator.shared
        dl.navigatorFactory = self
    }
    
    
}

extension NavigatorIntegrator {
    public func processRouting(for type: DeeplinkType, from: UIViewController?, completion: (() -> ())?){
        switch type {
        case .toDetailPage(let data):
            toActivity(with: data, from: from)
            break
        default:
            _ = toHomePage()
        }
    }
}


extension NavigatorIntegrator {
    
     func toActivity(with data: Any, from: UIViewController?){
        
        var slug: String?
        var id: Int?
        
        if let s = data as? String{
            slug = s
        }else if let i = data as? Int {
            id = i
        }
        
        let detail = DetailViewController(with: id, slug: slug)
        
        if let from = from {
            from.navigationController?.pushViewController(detail, animated: true)
        }else{
            if let vc = toHomePage() {
                vc.navigationController?.pushViewController(detail, animated: true)
            }
        }


    }
    
    func toWebview(with url: String, shouldShowShare: Bool, from: UIViewController?){
        //implement our own usage
        let webview = MyWebviewVC()
        
        if let from = from {
            from.navigationController?.pushViewController(webview, animated: true)
        }else{
            self.openFromHome(vc: webview)
        
        }
    }
    
    
    
    //Tabbar
    
    func toHomePage() -> ViewController? {
        if let tb = self.window?.rootViewController?.children.first as? UITabBarController, let vc = tb.viewControllers?[0] as? ViewController {
            vc.navigationController?.popToRootViewController(animated: false)
            tb.selectedIndex = 0
            return vc
        }
        return nil
        
    }
    
    func openFromHome(vc: UIViewController){
        if let vc = toHomePage() {
            vc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
