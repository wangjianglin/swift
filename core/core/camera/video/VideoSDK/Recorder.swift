//
//  Recorder.swift
//  VideoSDK
//
//  Created by qian on 2017/11/7.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit
//import GPUImage
//import ReactiveSwift
//import ReactiveCocoa
import AVFoundation

public class Recorder: NSObject {
    
    public weak var delegate: RecorderDelegate?
    public var previewView: GPUImageView?
    
    fileprivate let sessionPreset: AVCaptureSession.Preset
    fileprivate let cameraPosition: AVCaptureDevice.Position
    fileprivate var maximumDuration: CGFloat
    fileprivate var camera: GPUImageVideoCamera!
    fileprivate var processfilter: GPUImageFilter!
    fileprivate var blendFilter: GPUImageAlphaBlendFilter!
    fileprivate var overlayElement: GPUImageUIElement!
    fileprivate var outputURL: URL!
    fileprivate var writer: GPUImageMovieWriter!
    fileprivate var isStop = true
    fileprivate var isFilterUpdated = false
    
    
    /// 创建 recorder
    ///
    /// - Parameters:
    ///   - sessionPreset: 设置分辨率，默认960*540
    ///   - cameraPosition: 设置摄像头，默认后置摄像头
    ///   - maximumDuration: 设置最长录制时间，默认10秒
    public init(sessionPreset: AVCaptureSession.Preset = .iFrame960x540, cameraPosition: AVCaptureDevice.Position = .back, maximumDuration: CGFloat = 10) {
        self.sessionPreset = sessionPreset
        self.cameraPosition = cameraPosition
        self.maximumDuration = maximumDuration
        outputURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recorderOutput.mov")
        super.init()
        setup()
    }

    private func setup() {
        
        camera = GPUImageVideoCamera(sessionPreset: sessionPreset.rawValue, cameraPosition: cameraPosition)
        camera.outputImageOrientation = .portrait
        camera.addAudioInputsAndOutputs()
        processfilter = GPUImageFilter()
        camera.addTarget(processfilter)
        
        blendFilter = GPUImageAlphaBlendFilter()
        blendFilter.mix = 1.0
        processfilter.addTarget(blendFilter)
        
        overlayElement = GPUImageUIElement(view: generateOverlayUIElement())
        overlayElement.addTarget(blendFilter)
        overlayElement.update()
        //动态水印
//        processfilter.frameProcessingCompletionBlock = { [weak self] output, time in
//            guard let stongSelf = self else { return }
//            guard stongSelf.isFilterUpdated == false else { return }
//            stongSelf.overlayElement.update()
//            stongSelf.isFilterUpdated = true
//        }
    }
    
    private func generateOverlayUIElement() -> UIView {
        let boardView = UIView(frame: CGRect(x: 0, y: 0, width: 540, height: 960))
        boardView.backgroundColor = .clear
        let label = UILabel()
        label.text = "文字水印"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        let size = (label.text! as NSString).size(withAttributes: [.font: label.font])
        label.frame = CGRect(x: boardView.bounds.width - size.width - 20,
                             y: 20,
                             width: size.width,
                             height: size.height)
        boardView.addSubview(label)
        return boardView
    }
}

public extension Recorder {
    
    
    /// 开始录制
    public func start()  {
        //清空缓存
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        //writer需要每次创建
        isStop = false
        writer = GPUImageMovieWriter(movieURL: outputURL, size: CGSize(width: 540, height: 960), fileType: AVFileType.mov.rawValue, outputSettings: nil)
        writer.encodingLiveVideo = true
        writer.delegate = self
        blendFilter.addTarget(writer)
        blendFilter.addTarget(previewView)
        camera.startCapture()
        //延迟0.5秒开始写入文件
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.camera.audioEncodingTarget = strongSelf.writer
            strongSelf.writer.startRecording()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(strongSelf.maximumDuration), execute: { [weak strongSelf] in
                guard let strongSelf = strongSelf else { return }
                strongSelf.stop()
            })
        }
    }
    /// 停止录制
    public func stop()  {
        guard isStop == false else { return }
        isStop = true
        blendFilter.removeTarget(self.writer)
        camera?.audioEncodingTarget = nil
        writer.finishRecording()
        camera.stopCapture()
    }
}

extension Recorder: GPUImageMovieWriterDelegate {
    public func movieRecordingCompleted() {
        delegate?.recordingFinished(with: outputURL)
    }
    public func movieRecordingFailedWithError(_ error: Error!) {
        delegate?.recordingFailed(with: error)
    }
}

public protocol RecorderDelegate: NSObjectProtocol {
    func recordingFinished(with outputURL: URL)
    func recordingFailed(with error: Error)
}
