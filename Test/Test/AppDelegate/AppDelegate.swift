//
//  AppDelegate.swift
//  Test
//
//  Created by Apple on 30/07/2021.
//

import UIKit

public protocol Reptile {
    func lay() -> ReptileEgg
}

public class ReptileEgg {
    public init(createReptile: @escaping () -> Reptile) {
        
    }

    public func hatch() throws -> Reptile {
        throw AlreadyHatchedError.alreadyHatched
    }
    
    public enum AlreadyHatchedError: Error {
        case alreadyHatched
    }
    
    public class FireDragon: Reptile {
        public func lay() -> ReptileEgg {
            let reptileEgg = ReptileEgg(createReptile: {() in
                
            })
            
            return reptileEgg
        }
        
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}


