//
//  ViewController.swift
//  3_crash
//
//  Created by admin on 2025/6/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test1()
    }
    
    
    func test1() {
        let arrayInt: [Int] = [1]
        
        arrayInt[2]
    }
}

