//
//  VideoSpliceViewController.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/9.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SVProgressHUD

final class VideoSpliceController: UIViewController {

    fileprivate var assetResource: PHAssetResource!
    fileprivate var resourceManager: PHAssetResourceManager!
    
    fileprivate var previewView: UIView?
    fileprivate var playBtn: UIImageView?
    fileprivate var timelineView: TimeLineView?
    
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var player: AVPlayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var sourceAsset: AVURLAsset!
    fileprivate var outputURL: URL!
    
    fileprivate var startTime: CMTime!
    fileprivate var endTime: CMTime!
    
    private var progressTimer: Timer!
    private var exportSession: AVAssetExportSession!
    fileprivate var maxTimeInterval = 15.0
    private var hasSound = false
    
    convenience init(asset:PHAsset) {
        
        self.init(nibName: nil, bundle: nil)
        if #available(iOS 9.0, *) {
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            
            assetResource = PHAssetResource.assetResources(for: asset).filter{ $0.type == .video }.first
            resourceManager = PHAssetResourceManager.default()
        } else {
            // Fallback on earlier versions
        }
    }
    
    convenience init(asset: PHAsset,time interval:Double) {
        self.init(nibName: nil, bundle: nil)
        if #available(iOS 9.0, *) {
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            
            assetResource = PHAssetResource.assetResources(for: asset).filter{ $0.type == .video }.first
            resourceManager = PHAssetResourceManager.default()
            self.maxTimeInterval = interval
        } else {
            // Fallback on earlier versions
        }
    }
    convenience init(asset: PHAsset,time interval:Double,needSound:Bool) {
        self.init(nibName: nil, bundle: nil)
        if #available(iOS 9.0, *) {
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            assetResource = PHAssetResource.assetResources(for: asset).filter{ $0.type == .video }.first
            resourceManager = PHAssetResourceManager.default()
            self.maxTimeInterval = interval
            self.hasSound = needSound
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "剪辑"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextAction))
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setupUI()
        loadData()
    }
    func fileSize(_ path:URL)->Double {
        if let d = try? Data.init(contentsOf: path) {
            let data = d as NSData
            
            let size =  Double(data .length) / 1024.00 / 1024.0
            
            print("size:\(size)M\n")
            return Double(data .length) / 1024.00 / 1024.0
        }
        return 0.00
    }
    
    @objc func nextAction() {
        
        player?.pause()
        playBtn?.isHidden = false
        if   !self.timeOver() {
            SVProgressHUD.showError(withStatus: "导出长度最长为\(maxTimeInterval)秒")
            return
        }
        var  size = CGSize(width: 960, height: 540)
        if self.timeLarge() > 60 {
            size = CGSize.init(width: 640, height: 480)
        }
        let splice = Splice(asset: sourceAsset,sound:hasSound)
        
        splice.makeEditParamaters(startTime: startTime, endTime: endTime, outputSize:  size)

        guard let session = splice.makeExportable() else { return }
        exportSession = session
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        exportSession.exportAsynchronously { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.progressTimer.invalidate()
                SVProgressHUD.dismiss()
                
                if strongSelf.exportSession.status == .completed, let outputURL = strongSelf.exportSession.outputURL {
                    
                    self?.fileSize(outputURL)
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:outputURL)
//                    }, completionHandler: { (finish, error) in
//                    })
                    
//
                    if let picker = strongSelf.navigationController as? VideoPickerController {
                        picker.pickerDelegate?.videoPickerController(picker, didPickVideoAt: outputURL)
                    }
                }else {
                    print("error = \(strongSelf.exportSession.error)")
                }
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func timerAction() {
        SVProgressHUD.showProgress(exportSession.progress, status: "导出中...")
    }
    
    func timeOver()->Bool{
        
        if timeLarge() > Double(TimeInterval(maxTimeInterval)){
            return false
        }
        return true
    }
    
    func timeLarge()->Double {
        
        let endsecond = Double(endTime.value) / Double(endTime.timescale)
        let startSecond = Double(startTime.value) / Double(startTime.timescale)
        
        return endsecond - startSecond
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 200)
        playBtn?.center = previewView?.center ?? CGPoint.zero
        timelineView?.frame = CGRect(x: 0, y: view.bounds.height - 200, width: view.bounds.width, height: 200)
        playerLayer?.frame = previewView?.bounds ?? CGRect.zero
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//数据
extension VideoSpliceController {
    func loadData() {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("pickerOutput.mp4")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        let requestOption = PHAssetResourceRequestOptions()
        requestOption.isNetworkAccessAllowed = true
        resourceManager.writeData(for: assetResource, toFile: fileURL, options: requestOption) { (error) in
            if error == nil {
                self.loadPlayerWithURL(fileURL)
                self.generateThumbnails()
            }
        } 
    }
    
    func loadPlayerWithURL(_ url: URL) {
        sourceAsset = AVURLAsset(url: url)
        playerItem = AVPlayerItem(asset: sourceAsset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        previewView?.layer.insertSublayer(playerLayer!, below: playBtn?.layer)
        timelineView?.duration = CGFloat(CMTimeGetSeconds(sourceAsset.duration))
        startTime = kCMTimeZero
        endTime = sourceAsset.duration
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 10), queue: nil, using: { [weak self](time) in
            guard let strongSelf = self else { return }
            guard strongSelf.playBtn!.isHidden else { return }
            if CMTimeCompare(time, strongSelf.endTime) == 1 {
                strongSelf.player?.seek(to: kCMTimeZero)
                strongSelf.player?.play()
            }
        })
    }
    
    func generateThumbnails() {
        let generator = AVAssetImageGenerator(asset: sourceAsset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 160, height: 160)
        var generatorTimes = [NSValue]()
        generatorTimes.append(NSValue(time: kCMTimeZero))
        let duration = CMTimeGetSeconds(sourceAsset.duration)
        let timescale = sourceAsset.duration.timescale
        var second: Int64 = 0
        for _ in 1...6 {
            second += Int64(duration) / 7
            let time = CMTimeMake(second * Int64(timescale), timescale)
            generatorTimes.append(NSValue(time: time))
        }
        generatorTimes.append(NSValue(time: sourceAsset.duration))
        generator.generateCGImagesAsynchronously(forTimes: generatorTimes) { (before, image, after, result, error) in
            if let image = image  {
                self.timelineView?.addImage(image)
            }
        }
    }
    
    @objc func playerPlayToEndTime() {
        player?.seek(to: startTime)
        player?.play()
    }
}

//UI
extension VideoSpliceController {
    func setupUI() {
        previewView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: view.bounds.height - 200))
        previewView?.backgroundColor = UIColor(red: 0.921569, green: 0.921569, blue: 0.921569, alpha: 1)
        view.addSubview(previewView!)
        let image = UIImage(named: "play", in: Bundle(for: VideoSpliceController.self), compatibleWith: nil)
        playBtn = UIImageView(image: image)
        playBtn?.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        playBtn?.center = previewView?.center ?? CGPoint.zero
        previewView?.addSubview(playBtn!)
        timelineView = TimeLineView(frame: CGRect(x: 0, y: view.bounds.height - 200, width: ScreenSize.width, height: 200))
        timelineView?.delegate = self
        view.addSubview(timelineView!)
        
        previewView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc func tapAction() {
        if playBtn!.isHidden == false {
            playBtn?.isHidden = true
            player?.play()
        }else {
            playBtn?.isHidden = false
            player?.pause()
        }
    }
}

extension VideoSpliceController: TimeLineViewDelegate {
    func timelineView(_ timelineView: TimeLineView, moveTo time: CGFloat) {
        player?.pause()
        playBtn?.isHidden = false
        let seekTime = CMTimeMake(Int64(time * CGFloat(sourceAsset.duration.timescale)), sourceAsset.duration.timescale)
        player?.seek(to: seekTime)
    }
    func timelineView(_ timelineView: TimeLineView, submit beginTime: CGFloat, endTime: CGFloat) {
        self.startTime = CMTimeMake(Int64(beginTime * CGFloat(sourceAsset.duration.timescale)), sourceAsset.duration.timescale)
        self.endTime = CMTimeMake(Int64(endTime * CGFloat(sourceAsset.duration.timescale)), sourceAsset.duration.timescale)
        player?.seek(to: self.startTime)
    }

}


