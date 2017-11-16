//
//  ViewController.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/14.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //生成二维码
    @IBAction func generateAction(_ sender: Any) {
        navigationController?.pushViewController(GenerateViewController(), animated: true)
    }
    
    //识别二维码
    @IBAction func recognitionACtion(_ sender: Any) {
        navigationController?.pushViewController(RecognitionViewController(), animated: true)
    }
    
    //扫描二维码
    @IBAction func scaningAction(_ sender: Any) {
        let vc = ScaningViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

