//
//  Alert.swift
//  Shrubhub
//
//  Created by Eric Dobyns on 3/9/17.
//  Copyright © 2017 HOTB Software Solutions. All rights reserved.
//

import UIKit



struct Alert {

    enum AlertType {
        case Alert, ActionSheet
    }
    
    enum ToastType {
        case Toast, Snackbar
    }
    
    enum Position {
        case Top, Bottom
    }
    
    
    func presentAlert(viewController: UIViewController, title: String?, message: String?, type: AlertType, actions: [(String, UIAlertActionStyle)]?, completionHandler: ((Int) -> ())?) {
        
//        let rootVC = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last

        let preferredStyle: UIAlertControllerStyle = String(describing: type) == String(describing: AlertType.Alert) ? .alert : .actionSheet
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let actions = actions {
            for (index, action) in actions.enumerated() {

                alertController.addAction(UIAlertAction(title: action.0, style: action.1, handler: { (_) in
                    completionHandler?(index)
                }))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                alertController.dismiss(animated: true, completion: nil)
            })
        }
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverPresentationController.sourceView = viewController.view
            popoverPresentationController.sourceRect = UIScreen.main.bounds
        }
        
        DispatchQueue.main.async(execute: {
            viewController.present(alertController, animated: true, completion: nil)
        })
    }
    
    func presentNotification(title: String?, message: String, type: ToastType, position: Position) {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last
        
        if type == .Toast {
            
            // Create a dynamically sized label...
            let label = UILabel()
            if title != nil {
                label.text = "\(title!)\n\n\(message)"
                label.textAlignment = .left
            } else {
                label.text = "\(message)"
                label.textAlignment = .center
            }
            
            label.alpha = 0
            label.textColor = .white
            let font = UIFont.systemFont(ofSize: 14.0)
            label.font = font
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.sizeToFit()
            
            let width = label.frame.width < UIScreen.main.bounds.size.width * 0.75 ? label.frame.width : UIScreen.main.bounds.size.width * 0.75
            
            let text = label.text!
            
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
            let height = boundingBox.height
            
            var yPosition: CGFloat = 80
            if position == .Bottom { // Default is top...
                yPosition = UIScreen.main.bounds.size.height - (height + 100)
            }
            
            label.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (width / 2),
                                 y: yPosition,
                                 width: width,
                                 height: height + 10)

            // Create a background view for the label to appear on top of
            let backgroundView = UIView(frame: CGRect(x: label.frame.origin.x - 20,
                                                      y: label.frame.origin.y - 10,
                                                      width: label.frame.width + 40,
                                                      height: label.frame.height + 20))
            backgroundView.backgroundColor = .black
            backgroundView.layer.cornerRadius = 10
            backgroundView.alpha = 0
            
            // Add Background View and Label
            rootVC?.view.addSubview(backgroundView)
            rootVC?.view.addSubview(label)
            
            // Fade in Toast Notification
            UIView.animate(withDuration: 0.4, animations: {
                backgroundView.alpha = 0.9
                label.alpha = 1.0
            }, completion: { (_) in
                // Wait 3 seconds and remove popup notifications
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    UIView.animate(withDuration: 0.3, animations: {
                        backgroundView.alpha = 0
                        label.alpha = 0
                    }, completion: { (_) in
                        backgroundView.removeFromSuperview()
                        label.removeFromSuperview()
                    })
                })
            })
        } else {
            // Add Snackbar
        }
    }
}
