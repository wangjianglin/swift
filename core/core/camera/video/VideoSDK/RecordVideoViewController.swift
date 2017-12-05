//
//  ViewController.swift
//  VideoSDK-Demo
//
//  Created by devjia on 2017/11/8.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit
import Photos
import GPUImage

import AVFoundation
import AVKit





class RecordVideoViewController: UIViewController {
    
//    @IBOutlet weak var previewImageView: GPUImageView!
//    @IBOutlet weak var recordBtn: UIButton!
    
    var preViewImgaeView:GPUImageView!
    var recordBtn:UIButton!
    var cancelBtn:UIButton!
    var recorder: Recorder?
    var editor: Editer!
    
    
    var finishRecordHandle:((URL)->Void)?
    
    private var  _imageBundle:Bundle?
    
    var imageBunle:Bundle? {
        get {
            if _imageBundle == nil {
                _imageBundle = Bundle(path: Bundle(for: self.classForCoder).path(forResource:"LinCore", ofType: "bundle")!)
            }
            return _imageBundle!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setUI()
        //录制一段10S的960*540视频, 右上角有文字水印,录制完成后写入相册
        //裁剪录制的视频为540*540, 右下角添加图片水印, 完成后写入相册
        recorder = Recorder(maximumDuration: 15)
    }
    
    func setUI(){
        
        preViewImgaeView = GPUImageView()
        preViewImgaeView.backgroundColor = UIColor.white
        recordBtn = UIButton.init(type: .custom)
        if  let imagePath = self.imageBunle?.path(forResource: "statt@2x", ofType: "png", inDirectory: "camera") {
            recordBtn.setImage(UIImage.init(contentsOfFile: imagePath),for: .normal)
        }
        if let image = self.imageBunle?.path(forResource: "stop@2x", ofType: "png", inDirectory: "camera") {
            recordBtn.setImage(UIImage.init(contentsOfFile: image), for: .selected)
        }
        recordBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        
        cancelBtn = UIButton.init(type: .custom)
        if let image = self.imageBunle?.path(forResource: "close@2x", ofType: "png", inDirectory: "camera") {
            cancelBtn.setImage(UIImage.init(contentsOfFile: image), for: .normal)
        }
        
         cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        preViewImgaeView.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        recordBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(preViewImgaeView)
        self.view.addSubview(recordBtn)
        self.view.addSubview(cancelBtn)
        
        self.view.addConstraints([
            NSLayoutConstraint.init(item: preViewImgaeView, attribute: .top, relatedBy: .equal, toItem:self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: preViewImgaeView, attribute:.leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: preViewImgaeView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: preViewImgaeView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.view.addConstraints([
            NSLayoutConstraint.init(item: recordBtn, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: recordBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -40)
        
            ])
        self.view.addConstraints([
            NSLayoutConstraint.init(item: cancelBtn, attribute: .centerY, relatedBy: .equal, toItem: self.recordBtn, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint.init(item: cancelBtn, attribute: .right, relatedBy: .equal, toItem: recordBtn, attribute: .left, multiplier: 1, constant:-80)])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AVCaptureDevice.requestAccess(for: .video) { (allow) in
            if allow != true { self.showMsgAndExit("没有相机权限!") }
        }
        AVCaptureDevice.requestAccess(for: .audio) { (allow) in
            if allow != true { self.showMsgAndExit("没有麦克风权限!") }
        }
        PHPhotoLibrary.requestAuthorization { (status) in
            print("status = \(status)")
            if status != .authorized { self.showMsgAndExit("没有相册权限!") }
        }
    }

    
    @objc func recordAction(_ sender: Any) {
        if recordBtn.isSelected {
            stop()
        }else {
            start()
        }
    }
    
    @objc func cancelAction(_ sender: Any) {
        recorder?.stop()
        dismiss(animated: true, completion: nil)
    }
    
    func start() {

        recorder?.delegate = self
        recorder?.previewView = preViewImgaeView
        recorder?.start()
        recordBtn.isSelected = true
    }
    func stop() {
        recorder?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RecordVideoViewController: RecorderDelegate {
    func recordingFinished(with outputURL: URL) {
        print("录制+水印视频输出: \(outputURL)")
        
        //写入相册
        
         PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }) { (right, error) in
            print(error)
        }
        
        recordBtn.isSelected = false
        finishRecordHandle?(outputURL)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.showMsgAndExit(outputURL.absoluteString)
//            let player = AVPlayer(url: outputURL)
//            let controller = AVPlayerViewController()
//            controller.player = player
//            self.present(controller, animated: true, completion: nil)
        }
    }
    func recordingFailed(with error: Error) {
        print("录制+水印失败！")
        recordBtn.isSelected = false
    }
}

//extension ViewController: EditerDelegate {
//    func editingFinished(_ editor: Editer, output videoURL: URL) {
//        print("裁剪+水印成功！")
//        print("录制+水印视频输出: \(videoURL)")
//    }
//    func editingFailed(_ editor: Editer, with error: Error) {
//        print("裁剪+水印失败！")
//    }
//}

extension RecordVideoViewController {
    
    fileprivate func showMsgAndExit(_ msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
