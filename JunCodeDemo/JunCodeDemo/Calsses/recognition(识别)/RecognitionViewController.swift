//
//  RecognitionViewController.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/15.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {

    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var codeInfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "识别二维码"
    }
    
    //选择图片
    @IBAction func selectivePictudeAction(_ sender: UIButton) {
        // 1.判断点的哪一个按钮
        let sourceType: UIImagePickerControllerSourceType = sender.tag == 201 ? .camera : .photoLibrary
        
        //2. 判断是否允许该操作
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            print("操作限制, 不可执行")
            return
        }
        
        //3. 创建照片选择器
        let imagePC = UIImagePickerController()
        //3.1 设置数据源
        imagePC.sourceType = sourceType
        //3.2 设置代理
        imagePC.delegate = self
        //3.3 的弹出控制器
        present(imagePC, animated: true, completion: nil)
    }
    
    //识别二维码信息
    @IBAction func recognitionCodeAction(_ sender: Any) {
        let codeMan = CodeManage()
        guard let image = codeImageView.image else { return }
        //获取二维码信息
        guard let infoArr = codeMan.recognitionQRCode(qrCodeImage: image) else { return }
        for text in infoArr {
            print(text)
            codeInfoLabel.text = infoArr.first
        }
    }
}


//MARK: 实现代理
extension RecognitionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1. 获取选中的图片
        guard let selectorImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    
        codeImageView.image = selectorImage
        
        //3. 退出控制器
        picker.dismiss(animated: true, completion: nil)
    }
    
    //选取完成后调用
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
