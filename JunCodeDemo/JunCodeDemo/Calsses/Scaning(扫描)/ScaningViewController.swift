//
//  ScaningViewController.swift
//  JunCodeDemo
//
//  Created by iOS_Tian on 2017/11/15.
//  Copyright © 2017年 CoderJun. All rights reserved.
//

import UIKit
import AVFoundation

class ScaningViewController: UIViewController {

    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var scanImageLine: UIImageView!
    //输入输出中间桥梁(会话)
    fileprivate lazy var session : AVCaptureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addScaningAnimation()
        
        //开始扫描
        addScaningVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func addScaningVideo(){
        //1.获取输入设备（摄像头）
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        //2.根据输入设备创建输入对象
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        //3.创建原数据的输出对象
        let metadataOutput = AVCaptureMetadataOutput()
        
        //4.设置代理监听输出对象输出的数据，在主线程中刷新
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //5.创建会话（桥梁）
        //        let session = AVCaptureSession()
        
        //6.添加输入和输出到会话
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        //7.告诉输出对象要输出什么样的数据(二维码还是条形码),要先创建会话才能设置
        metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
        
        //8.创建预览图层
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）
        let rect = CGRect(x: scanImageView.frame.minY / kScreenHeight, y: scanImageView.frame.minX / kScreenWidth, width: scanImageView.frame.height / kScreenHeight, height: scanImageView.frame.width / kScreenWidth)
        metadataOutput.rectOfInterest = rect
        
        //10. 开始扫描
        session.startRunning()

    }

    //初始化页面
    fileprivate func setupViews(){
        //设置中空区域，即有效扫描区域（中间扫描区域透明度比周边要低的效果）
        maskView.frame = UIScreen.main.bounds
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let rect = CGRect(x: scanImageView.frame.minX, y: scanImageView.frame.minY, width: scanImageView.frame.width, height: scanImageView.frame.height)
        let rectPath = UIBezierPath(rect: maskView.bounds)
        rectPath.append(UIBezierPath(roundedRect: rect, cornerRadius: 1).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
        maskView.layer.mask = shapeLayer
    }
    
    //添加扫描动画
    fileprivate func addScaningAnimation(){
        scanImageLine.frame.origin.y = scanImageView.frame.minY
        UIView.animate(withDuration: 2, animations: {
            self.scanImageLine.frame.origin.y = self.scanImageView.frame.maxY
        }) { (finished) in
            self.addScaningAnimation()
        }
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: 开始扫描二维码
extension ScaningViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //1. 取出扫描到的数据: metadataObjects
        //2. 以震动的形式告知用户扫描成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //3. 关闭session
        session.stopRunning()
        
        //4. 遍历结果
        var resultArr = [String]()
        for result in metadataObjects {
            //转换成机器可读的编码数据
            if let code = result as? AVMetadataMachineReadableCodeObject {
                resultArr.append(code.stringValue ?? "")
            }else {
                resultArr.append(result.type.rawValue)
            }
        }
        
        //5. 将结果
        let vc = ShowViewController()
        vc.scanDataArr = resultArr
        navigationController?.pushViewController(vc, animated: true)
    }
}


