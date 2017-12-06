//
//  Editer.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/8.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit
import GPUImage

public class Editer: NSObject {
    
    fileprivate var movie: GPUImageMovie!
    fileprivate var cropFilter: GPUImageCropFilter!
    fileprivate var overlayImage: GPUImagePicture!
    fileprivate var overlayFilter: GPUImageOverlayBlendFilter!
    fileprivate var writer: GPUImageMovieWriter!
    fileprivate var outputURL: URL!
    
    public weak var delegate: EditerDelegate?
    
    public init(videoURL: URL) {
        
        movie = GPUImageMovie(url: videoURL)
        cropFilter = GPUImageCropFilter(cropRegion: CGRect(x: 0, y: 0, width: 1, height: 0.5625))
        overlayFilter = GPUImageOverlayBlendFilter()
        overlayImage = GPUImagePicture(image: UIImage(named: "damai.png", in: Bundle(for: Editer.self), compatibleWith: nil), smoothlyScaleOutput: true)
        overlayImage.processImage()
        overlayImage.addTarget(overlayFilter)
        outputURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("editerOutput.mov")
        super.init()
    }
    
    public func start() {
        movie.addTarget(cropFilter)
        cropFilter.addTarget(overlayFilter)
        //清空缓存
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        writer = GPUImageMovieWriter(movieURL: outputURL, size: CGSize(width: 540, height: 540), fileType: AVFileType.mov.rawValue, outputSettings: nil)
        overlayFilter.addTarget(writer)
        writer.shouldPassthroughAudio = true
        movie.audioEncodingTarget = writer
        movie.enableSynchronizedEncoding(using: writer)
        writer.startRecording()
        movie.startProcessing()
        
        writer.completionBlock = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.overlayFilter.removeTarget(strongSelf.writer)
            strongSelf.movie.audioEncodingTarget = nil
            strongSelf.writer.finishRecording()
            strongSelf.delegate?.editingFinished(strongSelf, output: strongSelf.outputURL)
        }
        writer.failureBlock = { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.overlayFilter.removeTarget(strongSelf.writer)
            strongSelf.movie.audioEncodingTarget = nil
            strongSelf.writer.finishRecording()
            strongSelf.delegate?.editingFailed(strongSelf, with: error!)
        }
    }
}

public protocol EditerDelegate: NSObjectProtocol {
    func editingFinished(_ editor: Editer, output videoURL: URL)
    func editingFailed(_ editor: Editer, with error: Error)
}
