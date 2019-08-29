

//
//  MainScreensController.swift
//  EduChat
//
//  Created by Tom Knighton on 29/08/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainScreensController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "FeedHost")
        let vc2 = sb.instantiateViewController(withIdentifier: "ProfileHost")
        let vc3 = sb.instantiateViewController(withIdentifier: "ChatHost")
        
        return[vc1, vc2, vc3]
    }()
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.bounds, colors: [UIColor(hexString: "#007991")!, UIColor(hexString: "#78ffd6")!])
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        let secondViewController = viewControllerList[1]
        pageContainer.setViewControllers([secondViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.view.addSubview(pageContainer.view)
    }

    

}
