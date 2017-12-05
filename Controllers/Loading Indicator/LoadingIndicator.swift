//
//  LoadingIndicator.swift
//  Shrubhub
//
//  Created by Eric Dobyns on 3/20/17.
//  Copyright © 2017 HOTB Software Solutions. All rights reserved.
//

import UIKit



class LoadingIndicator {
    
    // MARK: - Singleton
    static let shared = LoadingIndicator()
    
    // MARK: - Private Variables
    private var activityIndicatorView: UIView? = nil

    
    
    // MARK: - System Indicators
    func showSystemIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func hideSystemIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    
    // MARK: - Custom Indicators
    func showCustomIndicator(viewController: UIViewController) {
        self.activityIndicatorView = UIView()
        self.activityIndicatorView?.frame.size = CGSize(width: 100, height: 100)
        self.activityIndicatorView?.frame.origin = CGPoint(x: (UIScreen.main.bounds.size.width/2 - 50), y: (UIScreen.main.bounds.size.height/2 - 50))
        self.activityIndicatorView?.layer.cornerRadius = 12.0
        self.activityIndicatorView?.backgroundColor = .black
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        activityIndicator.frame.size = CGSize(width: 100, height: 100)
        
        DispatchQueue.main.async {
            self.activityIndicatorView?.addSubview(activityIndicator)
            if let activityIndicator = self.activityIndicatorView {
                viewController.view.addSubview(activityIndicator)
            }
            activityIndicator.startAnimating()
        }
    }
    
    func hideCustomIndicator() {
        if self.activityIndicatorView != nil {
            DispatchQueue.main.async {
                self.activityIndicatorView?.removeFromSuperview()
                self.activityIndicatorView = nil
            }
        }
    }
}
