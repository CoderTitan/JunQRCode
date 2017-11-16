//
//  GenerateViewController.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/15.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class GenerateViewController: UIViewController {

    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var codeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "生成二维码"
    }

    @IBAction func getQRCodeImageAction(_ sender: Any) {
        //1, 获取输入的内容
        guard var text = infoTextField.text else { return }
        if text.count == 0 {
            text = "http://www.jianshu.com/u/5bd5e9ed569e"
        }
        
        //2. 生成二维码
        let fgImage = UIImage(named: "icon1024")
        let codeMan = CodeManage()
        codeImage.image = codeMan.generateCode(inputMsg: text, fgImage: fgImage)
    }
}
