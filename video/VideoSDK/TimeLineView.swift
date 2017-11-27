//
//  TimeLineView.swift
//  VideoSDK
//
//  Created by qian on 2017/11/10.
//  Copyright © 2017年 devjia. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "thumbnailCell"

//fileprivate

enum TimeEditType {
    case unknown
    case begin
    case end
}

class TimeLineView: UIView {

    fileprivate var collectionView: UICollectionView!
    fileprivate var bar: TimeBar!
    fileprivate var label: TimeLabel!
    
    fileprivate var thumbnails = [CGImage]()
    fileprivate var editType: TimeEditType = .unknown
    var duration: CGFloat! {
        didSet {
            editBeginTime = 0
            editEndTime = duration
            pps = (ScreenSize.width - 30) / duration
            spp = duration / (ScreenSize.width - 30)
            label.time = duration
        }
    }
    weak var delegate: TimeLineViewDelegate?
    
    fileprivate var editBeginTime: CGFloat!
    fileprivate var editEndTime: CGFloat!
    // point per second
    fileprivate var pps: CGFloat!
    // second per point
    fileprivate var spp: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (ScreenSize.width - 30) / 8, height: 80)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 15, y: 60, width: ScreenSize.width - 30, height: 80), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isUserInteractionEnabled = false
        bar = TimeBar(frame: CGRect(x: 0, y: 60, width: ScreenSize.width, height: 80))
        label = TimeLabel(frame: CGRect(x: ScreenSize.width - 50 - 4, y: 30, width: 50, height: 20))
        addSubview(collectionView)
        addSubview(bar)
        addSubview(label)
        addPanGestureRecognizer()
    }
    
    func addImage(_ image: CGImage) {
        DispatchQueue.main.async {
            self.thumbnails.append(image)
            self.collectionView.reloadData()
        }
    }
}

extension TimeLineView: UIGestureRecognizerDelegate {
    
    func addPanGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .changed:
            updateTimeBarWithTranslationX(pan.translation(in: self).x)
            pan.setTranslation(.zero, in: self)
        case .ended, .cancelled:
            guard editType != .unknown else { return }
            delegate?.timelineView(self, submit: editBeginTime, endTime: editEndTime)
            label.time = editEndTime - editBeginTime
            label.center = CGPoint(x: ScreenSize.width - 29, y: 40)
            editType = .unknown
        default:
            break
        }
    }
    
    func updateTimeBarWithTranslationX(_ translationX: CGFloat) {
        
        func updateBeginTimeBarWithTranslationX(_ translationX: CGFloat) {
            let frame = bar.frame.moveMinXBy(offset: translationX)
            if isValidFrame(frame) {
                bar.frame = frame
                editBeginTime = frame.minX * spp
                delegate?.timelineView(self, moveTo: editBeginTime)
                label.time = editBeginTime
                label.center = CGPoint(x: max(29, frame.minX + 8), y: 40)
            }
        }
        func updateEndTimeBarWithTranslationX(_ translationX: CGFloat) {
            let frame = bar.frame.moveMaxXBy(offset: translationX)
            if isValidFrame(frame) {
                bar.frame = frame
                editEndTime = (frame.maxX - 30) * spp
                delegate?.timelineView(self, moveTo: editEndTime)
                label.time = editEndTime
                label.center = CGPoint(x: min(ScreenSize.width - 29, frame.maxX - 8), y: 40)
            }
        }
        func isValidFrame(_ frame: CGRect) -> Bool {
            guard frame.minX >= 0 else { return false }
            guard frame.maxX <= ScreenSize.width else { return false }
            guard frame.width - 30 >= pps * 3 else { return false }
            return true
        }
        
        if editType == .begin {
            updateBeginTimeBarWithTranslationX(translationX)
        }else if editType == .end{
            updateEndTimeBarWithTranslationX(translationX)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        if bar.frame.contains(touchPoint) {
            let leftBarFrame = CGRect(x: bar.frame.minX, y: bar.frame.minY, width: 15, height: bar.frame.height)
            let rightBarFrame = CGRect(x: bar.frame.maxX - 15, y: bar.frame.minY, width: 15, height: bar.frame.height)
            if leftBarFrame.contains(touchPoint) {
                editType = .begin
                return true
            }
            else if rightBarFrame.contains(touchPoint) {
                editType = .end
                return true
            }
        }
        return false
    }
}

extension TimeLineView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ThumbnailCell
        cell.imageView.image = UIImage(cgImage: thumbnails[indexPath.item])
        return cell
    }
}

protocol TimeLineViewDelegate: NSObjectProtocol {
    func timelineView(_ timelineView: TimeLineView, moveTo time: CGFloat)
    func timelineView(_ timelineView: TimeLineView, submit beginTime: CGFloat, endTime: CGFloat)
}

fileprivate class TimeBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var frame: CGRect {
        didSet{
            if frame.width < 31 {
                frame = oldValue
            }
            setNeedsDisplay()
        }
    }
    
    private var leftPath: UIBezierPath {
        get {
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 15, height: bounds.height))
            return path
        }
    }
    
    private var topPath: UIBezierPath {
        get {
            let path = UIBezierPath(rect: CGRect(x: 15, y: 0, width: bounds.width - 30, height: 8))
            return path
        }
    }
    
    private var rightPath: UIBezierPath {
        get {
            let path = UIBezierPath(rect: CGRect(x: bounds.width - 15, y: 0, width: 15, height: bounds.height))
            return path
        }
    }
    
    private var bottomPath: UIBezierPath {
        get {
            let path = UIBezierPath(rect: CGRect(x: 15, y: bounds.height - 8, width: bounds.width - 30, height:8))
            return path
        }
    }
    
     override func draw(_ rect: CGRect) {
        UIColor.yellow.setFill()
        leftPath.fill()
        topPath.fill()
        rightPath.fill()
        bottomPath.fill()
     }
}

fileprivate class TimeLabel: UIView {
    
    var time: CGFloat = 0 {
        didSet {
            label.text = timeString(time)
        }
    }
    
    fileprivate var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        label = UILabel()
        label.text = "0.0"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
    
    private func timeString(_ seconds: CGFloat) -> String {
        let floor = Int(floorf(Float(seconds)))
        let m = floor / 60
        let s = floor % 60
        let f = Int((seconds - CGFloat(floor)) * 10)
        if m > 0 {
            return NSString(format: "%d:%d.%d", m, s, f) as String
        }else {
            return NSString(format: "%d.%d", s, f) as String
        }
    }
}


fileprivate class ThumbnailCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
}

fileprivate extension CGRect {
    
    func moveMinXBy(offset: CGFloat) -> CGRect {
        return CGRect(x: origin.x + offset, y: origin.y, width: width - offset, height: height)
    }
    
    func moveMaxXBy(offset: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: width + offset, height: height)
    }
}
