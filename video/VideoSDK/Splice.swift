//
//  Composition.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/9.
//  Copyright © 2017年 devjia. All rights reserved.
//

import Foundation
import AVFoundation

final class Splice: NSObject {

    private let sourceVideoAsset: AVURLAsset
    private var outputSize: CGSize!
    
    private var sourceVideoTrack: AVAssetTrack!
//    private var sourceAudioTrack: AVAssetTrack!

    private var composition: AVMutableComposition!
    private var videoComposition: AVMutableVideoComposition!
    private var videoCompositionInstruction: AVMutableVideoCompositionInstruction!
    private var videoCompositionLayerInstruction: AVMutableVideoCompositionLayerInstruction!
    private var videoTrack: AVMutableCompositionTrack!
    
//    private var audioTrack: AVMutableCompositionTrack!
//    private var audioMix: AVMutableAudioMix!
//    private var audioMixInputParameters: AVMutableAudioMixInputParameters!
    
    private var parentLayer: CALayer!
    private var videoLayer: CALayer!
    
    private var startTime: CMTime!
    private var endTime: CMTime!
    
    init(asset: AVURLAsset) {
        sourceVideoAsset = asset
        if let firstVideoTrack = sourceVideoAsset.tracks(withMediaType: .video).first {
            sourceVideoTrack = firstVideoTrack
        }
//        if let firstAudioTrack = sourceVideoAsset.tracks(withMediaType: .audio).first {
//            sourceAudioTrack = firstAudioTrack
//        }
        super.init()
    }

    func makeEditParamaters(startTime: CMTime, endTime: CMTime, outputSize: CGSize) {
        self.startTime = startTime
        self.endTime = endTime
        self.outputSize = outputSize
        buildComposition()
        buildVideoComposition()
        buildOverlayLayer()
        buildAudioMix()
    }
    
    func makePlayable() -> AVPlayerItem {
        let playerItem = AVPlayerItem(asset: composition.copy() as! AVAsset)
        playerItem.videoComposition = videoComposition
        //playerItem.audioMix = audioMix
        return playerItem
    }

    func makeExportable() -> AVAssetExportSession? {
        let path = NSTemporaryDirectory() + "spliceOutput.mov"
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
        let session = AVAssetExportSession(asset: composition.copy() as! AVAsset, presetName: AVAssetExportPreset960x540)
        session?.outputFileType = .mov
        session?.outputURL = URL(fileURLWithPath: path)
        if let videoComposition = videoComposition {
            session?.videoComposition = videoComposition
        }
//        if let audioMix = audioMix {
//            session?.audioMix = audioMix
//        }
        return session
    }

    private func buildComposition() {
        composition = AVMutableComposition()
        if sourceVideoTrack != nil {
            videoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video,
                                                     preferredTrackID: kCMPersistentTrackID_Invalid)
        }
//        if sourceAudioTrack != nil {
//            audioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio,
//                                                     preferredTrackID: kCMPersistentTrackID_Invalid)
//        }
        
        buildCompositionTracks()
    }

    private func buildVideoComposition() {
        guard let sourceVideoTrack = sourceVideoTrack else { return }
        videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        let scale = max(outputSize.width / sourceVideoTrack.dimensions.width,
                        outputSize.height / sourceVideoTrack.dimensions.height)
        videoComposition.renderSize = CGSize(width: sourceVideoTrack.dimensions.width * scale,
                                             height: sourceVideoTrack.dimensions.height * scale)

        buildVideoCompositionInstructions()
    }

    private func buildAudioMix() {
//        guard let audioTrack = audioTrack else { return }
//        audioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
//        audioMix = AVMutableAudioMix()
//        audioMix.inputParameters = [audioMixInputParameters]
    }

    private func buildCompositionTracks() {
        do {
            if let sourceVideoTrack = sourceVideoTrack {
                try videoTrack.insertTimeRange(CMTimeRangeFromTimeToTime(startTime, endTime), of: sourceVideoTrack, at: kCMTimeZero)
            }
//            if let sourceAudioTrack = sourceAudioTrack {
//                try audioTrack.insertTimeRange(CMTimeRangeFromTimeToTime(startTime, endTime), of: sourceAudioTrack, at: kCMTimeZero)
//            }
        } catch  {
            print(error)
        }
        
    }
    private func buildVideoCompositionInstructions() {
        guard let sourceVideoTrack = sourceVideoTrack else { return }
        videoCompositionInstruction = AVMutableVideoCompositionInstruction()
        videoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeSubtract(endTime, startTime))
        videoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let scale = max(outputSize.width / sourceVideoTrack.dimensions.width,
                        outputSize.height / sourceVideoTrack.dimensions.height )
        let transform = sourceVideoTrack.preferredTransform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
        videoCompositionLayerInstruction.setTransform(transform, at: kCMTimeZero)
        videoCompositionInstruction.layerInstructions = [videoCompositionLayerInstruction]
        videoComposition.instructions = [videoCompositionInstruction]
    }

    private func buildOverlayLayer() {
        
        let overlayString = "文字水印"
        let fontSize = 20 * (videoComposition.renderSize.width / ScreenSize.width)
        let font = UIFont.systemFont(ofSize: fontSize)
        let overlayLayer = CATextLayer()
        overlayLayer.font = font
        overlayLayer.fontSize = font.pointSize
        overlayLayer.string = overlayString
        overlayLayer.foregroundColor = UIColor.red.cgColor
        overlayLayer.alignmentMode = kCAAlignmentCenter
        overlayLayer.backgroundColor = UIColor.clear.cgColor
        let size = (overlayString as NSString).size(withAttributes: [.font: font])
        overlayLayer.frame = CGRect(x: videoComposition.renderSize.width - size.width - 20, y: videoComposition.renderSize.height - size.height - 20, width: size.width, height: size.height)
        //overlayLayer.add(build3DSpinAnimation(), forKey: nil)

        parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: videoComposition.renderSize.width, height: videoComposition.renderSize.height)
        
        videoLayer = CALayer()
        videoLayer.frame = CGRect(x: 0, y: 0, width: videoComposition.renderSize.width, height: videoComposition.renderSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

    }

    private func build3DSpinAnimation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi * -1
        animation.beginTime = AVCoreAnimationBeginTimeAtZero
        animation.duration = CFTimeInterval(5)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
}

fileprivate extension AVAssetTrack {
    var dimensions: CGSize {
        let result = naturalSize.applying(preferredTransform)
        return CGSize(width: CGFloat(fabsf(Float(result.width))), height: CGFloat(fabsf(Float(result.height))))
    }
}
