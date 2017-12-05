//
//  Validate.swift
//  Lovelab
//
//  Created by Laptop on 11/8/16.
//  Copyright © 2016 EricDobyns. All rights reserved.
//

import Foundation



class Validate {
    
    /*
     Email Validator:
     - Checks for an email with an alphanumeric name
     - Followed by an "@" symbol
     - Followed by an alphanumeric domain name
     - Followed by a "." symbol
     - Followed by a top level domain name (must be at least 2 characters and no longer than 12 characters)
     */
    func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,12}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
    }
    
    
    
    /*
     Phone Validator:
     - United States phone number validaton only
     - Strips out all dashes parenthesis and spaces
     - Checks for numeric characters only
     - Checks for 10 digits
     */
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        
        let formattedPhone1 = phoneNumber.replacingOccurrences(of: "-", with: "")
        let formattedPhone2 = formattedPhone1.replacingOccurrences(of: "(", with: "")
        let formattedPhone3 = formattedPhone2.replacingOccurrences(of: ")", with: "")
        let formattedPhone4 = formattedPhone3.replacingOccurrences(of: " ", with: "")
        
        if formattedPhone4.count == 10 {
            let containsNumbers = "^[0-9]+$"
            let phoneTest = NSPredicate(format:"SELF MATCHES %@", containsNumbers)
            let result = phoneTest.evaluate(with: formattedPhone4)
            return result
        }
        
        return false
    }
    
    
    
    /*
     Password Validator:
     - One Capital Letter
     - Three Lower Case Letters
     - One digit between 0-9
     - At Least 6 Characters, no longer than 20
     */
    func isValidPassword(_ password:String) -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z].*[a-z].*[a-z]).{6,20}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        
        return result
    }
}



