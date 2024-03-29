//
//  Navigation.swift
//  AlarmClock
//
//  Created by Александр Сенин on 22/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class Navigation{
    var controllers: [UIViewController] = []
    var selectView: UIViewController{
        return controllers.last!
    }
    
    init(viewController: UIViewController) {
        controllers.append(viewController)
    }
    
    func transitionToView(viewControllerType: NavigationProtocol, special: ((UIViewController) -> Void)?){
        
        for i in 0 ..< controllers.count{
            if type(of: viewControllerType) == type(of: controllers[i]) {
                controllers[i+1 ..< controllers.count] = []
                controllers[i].dismiss(animated: true, completion: {
                    special?(self.controllers[i])
                })
                
                
                return
            }
        }
        
        if let nextViewController = type(of: viewControllerType).storyboardInstance(navigation: self) {
            special?(nextViewController)
            selectView.present(nextViewController, animated: true, completion: nil)
            controllers.append(nextViewController)
        }
    }
}
