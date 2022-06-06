//
//  ViewController.swift
//  TargetedCoupon
//
//  Created by Muhammad Ahsan on 29/11/2020.
//

import UIKit

let kDob = "18/09/1990"
let kDateOfPurchase = "15/11/2020"
let kPostalCode = "54000"
let kIsNewUser = "true"
let kGender = "Male"
let kPoints = "250"
let kProductCode = "A-0022"
let kPurchaseThisMonth = "2950"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoupons { (coupons, error) in
            if let coupons = coupons, let couponsArray = coupons.data, couponsArray.isEmpty == false {
                for coupon in couponsArray {
                    let finalResult = checkCoupon(coupon: coupon)
                    print("\n\nFinal Result   = ", finalResult, "\n")
                }
            }
        }
    }
}
