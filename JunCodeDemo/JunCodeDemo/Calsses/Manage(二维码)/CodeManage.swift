//
//  CodeManage.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/15.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import AVFoundation

class CodeManage: NSObject {

}

extension CodeManage {
    //MARK: 生成二维码
    /* *  @param inputMsg 二维码保存的信息
       *  @param fgImage  前景图片  */
    func generateCode(inputMsg: String, fgImage: UIImage?) -> UIImage {
        //1. 将内容生成二维码
        //1.1 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //1.2 恢复默认设置
        filter?.setDefaults()
        
        //1.3 设置生成的二维码的容错率
        //value = @"L/M/Q/H"
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        // 2.设置输入的内容(KVC)
        // 注意:key = inputMessage, value必须是NSData类型
        let inputData = inputMsg.data(using: .utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        
        //3. 获取输出的图片
        guard let outImage = filter?.outputImage else { return UIImage() }
        
        //4. 获取高清图片
        let hdImage = getHDImage(outImage)
        
        //5. 判断是否有前景图片
        if fgImage == nil{
            return hdImage
        }
        
        //6. 获取有前景图片的二维码
        return getResultImage(hdImage: hdImage, fgImage: fgImage!)
    }
    
    //4. 获取高清图片
    fileprivate func getHDImage(_ outImage: CIImage) -> UIImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        //放大图片
        let ciImage = outImage.transformed(by: transform)
        
        return UIImage(ciImage: ciImage)
    }
    
    //获取前景图片
    fileprivate func getResultImage(hdImage: UIImage, fgImage: UIImage) -> UIImage {
        let hdSize = hdImage.size
        //1. 开启图形上下文
        UIGraphicsBeginImageContext(hdSize)
        
        //2. 将高清图片画到上下文
        hdImage.draw(in: CGRect(x: 0, y: 0, width: hdSize.width, height: hdSize.height))
        
        //3. 将前景图片画到上下文
        let fgWidth: CGFloat = 80
        fgImage.draw(in: CGRect(x: (hdSize.width - fgWidth) / 2, y: (hdSize.height - fgWidth) / 2, width: fgWidth, height: fgWidth))
        
        //4. 获取上下文
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        
        //5. 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    
    //MARK: 识别二维码
    /* *  @param qrCodeImage 二维码的图片
       *  @return 结果的数组 */
    func recognitionQRCode(qrCodeImage: UIImage) -> [String]? {
        //1. 创建过滤器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        //2. 获取CIImage
        guard let ciImage = CIImage(image: qrCodeImage) else { return nil }
        
        //3. 识别二维码
        guard let features = detector?.features(in: ciImage) else { return nil }
        
        //4. 遍历数组, 获取信息
        var resultArr = [String]()
        for feature in features {
            resultArr.append(feature.type)
        }
        
        return resultArr
    }
}


/// 屏幕的宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕的高
let kScreenHeight = UIScreen.main.bounds.size.height

