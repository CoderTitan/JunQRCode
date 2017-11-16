//
//  ShowViewController.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/16.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    var scanDataArr = [String]()
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "显示扫描到的二维码信息"
        
        if scanDataArr.count >= 3 {
            thirdLabel.text = scanDataArr[2]
        }else if scanDataArr.count == 2{
            secondLabel.text = scanDataArr[1]
        }else if scanDataArr.count == 1 {
            firstLabel.text = scanDataArr[0]
        }
    }
}
