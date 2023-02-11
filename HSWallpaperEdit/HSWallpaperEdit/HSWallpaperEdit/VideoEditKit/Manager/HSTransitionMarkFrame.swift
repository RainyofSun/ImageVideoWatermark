//
//  HSTransitionMarkFrame.swift
//  HSWallpaperEdit
//
//  Created by 苍蓝猛兽 on 2022/7/20.
//

import UIKit
import AVFoundation

struct ElementScaleStruct {
    /// 视频和屏幕的宽度比
    var widthScale: CGFloat
    /// 视频和屏幕的高度比
    var heightScale: CGFloat
    /// 屏幕的宽高比
    var screenWHScale: CGFloat = K_SCREEN_WIDTH/K_SCREEN_HEIGHT
    /// 视频的宽高比
    var videoWHScale: CGFloat
    
    init(widthScale: CGFloat, heightScale: CGFloat, videoWHScale: CGFloat) {
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.videoWHScale = videoWHScale
    }
}

// 单例 --> 负责坐标转换
class HSTransitionMarkFrame: NSObject {
    
    static let transitionFrameShared = HSTransitionMarkFrame.init()
    
    // 视频AVAsset
    open var videoAsset: AVAsset? {
        get {
            return wallpapaerVideoAsset
        }
    }
    
    // 视频尺寸
    open var videoSize: CGSize {
        get {
            return vSize
        }
    }
    private var vSize: CGSize = .zero
    
    // 缩放比
    open var elementScaleStruct: ElementScaleStruct {
        get {
            return eScaleStruct
        }
    }
    private var eScaleStruct: ElementScaleStruct = ElementScaleStruct.init(widthScale: 0, heightScale: 0, videoWHScale: 0)
    
    private var wallpapaerVideoAsset: AVAsset?
    
    /// 获取视频的Size
    /// - Parameters:
    ///     - videoPath: 视频路径
    /// - Returns: 视频尺寸
    func getVideoSize(videoPath: String) -> CGSize {
        let videoUrl: URL = URL.init(fileURLWithPath: videoPath)
        if videoUrl.absoluteString.utf16.count == 0 {
            print("URL 为空")
            return vSize
        }
        self.wallpapaerVideoAsset = AVURLAsset.init(url: videoUrl)
        for item in 0..<(self.wallpapaerVideoAsset?.tracks.count)! {
            let videoTrack = self.wallpapaerVideoAsset?.tracks[item]
            if videoTrack!.mediaType == .video {
                vSize = videoTrack!.naturalSize
                break
            }
        }
        print("视频尺寸 ++++++ \(vSize)")
        return vSize
    }
    
    /// 获取元素相对视频尺寸的缩放比
    /// - Parameters:
    ///     - videoPath: 视频路径
    /// - Returns: 视频尺寸
    func getScaleFactor(videoSize: CGSize) -> ElementScaleStruct {
        let wScale: CGFloat = videoSize.width/K_SCREEN_WIDTH
        let hScale: CGFloat = videoSize.height/K_SCREEN_HEIGHT
        eScaleStruct = ElementScaleStruct.init(widthScale: wScale, heightScale: hScale, videoWHScale: (videoSize.width/videoSize.height))
        print("宽 wScale = \(eScaleStruct.widthScale) 高 hScale = \(eScaleStruct.heightScale) videoWHScale = \(eScaleStruct.videoWHScale)")
        return eScaleStruct
    }
}
