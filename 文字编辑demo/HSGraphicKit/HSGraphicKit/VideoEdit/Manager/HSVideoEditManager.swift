//
//  HSVideoEditManager.swift
//  HSGraphicKit
//
//  Created by 苍蓝猛兽 on 2022/7/12.
//

import UIKit
import AVFoundation

// MARK: 工具类 -- 管理视频图片水印的生成
class HSVideoEditManager: NSObject {
    
    public func mixVideoWithText(_ videoUrl: NSURL) {
        if videoUrl.absoluteString?.utf16.count == 0 {
            print("URL 为空")
            return
        }
        let videoAsset: AVURLAsset = AVURLAsset.init(url: videoUrl as URL)
        let compositionArray = self.addVideoAsset(videoAsset: videoAsset)
        self.videoExport(mixConposition: compositionArray.firstObject as! AVMutableComposition, videoComposition: compositionArray.lastObject as! AVVideoComposition, destinationPath: self.getVideoSavePath(videoName: "editVideo"))
    }
}

// MARK: 视频添加水印
extension HSVideoEditManager {
    /// 视频添加水印准备工作
    /// - Parameters:
    ///     - viedeoAsset: 视频素材
    /// - Returns: 视频存储路径
    private func addVideoAsset(videoAsset: AVAsset) -> NSArray {
        // 创建AVMutableComposition 实例
        let mixComposition: AVMutableComposition = AVMutableComposition.init()
        
        // 视频通道
        let compositionVideoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let clipVideoTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        try? compositionVideoTrack.insertTimeRange(CMTimeRange.init(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
        
        // 音频通道
        let compositionAudioTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let clipAudioTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0] as AVAssetTrack
        try? compositionAudioTrack.insertTimeRange(CMTimeRange.init(start: CMTime.zero, duration: videoAsset.duration), of: clipAudioTrack, at: CMTime.zero)
        
        // AVMutableVideoCompositionInstruction 视频轨道中的一个视频,可以缩放、旋转等
        let mainInstruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction.init()
        mainInstruction.timeRange = CMTimeRange.init(start: CMTime.zero, duration: videoAsset.duration)
        
        // AVMutableVideoCompositionLayerInstruction 一个视频轨道,包含了这个轨道上的所有视频素材
        let videoLayerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: compositionVideoTrack)
        var isVideoAssetPortrait: Bool = false
        if clipVideoTrack.preferredTransform.a == 0 && clipVideoTrack.preferredTransform.b == 1.0 && clipVideoTrack.preferredTransform.c == -1.0 && clipVideoTrack.preferredTransform.d == 0 {
            isVideoAssetPortrait = true
        }
        if clipVideoTrack.preferredTransform.a == 0 && clipVideoTrack.preferredTransform.b == -1.0 && clipVideoTrack.preferredTransform.c == 1.0 && clipVideoTrack.preferredTransform.d == 0 {
            isVideoAssetPortrait = true
        }
        videoLayerInstruction.setTransform(clipVideoTrack.preferredTransform, at: CMTime.zero)
        videoLayerInstruction.setOpacity(0.0, at: videoAsset.duration)

        // 添加 instrustions
        mainInstruction.layerInstructions = [videoLayerInstruction]
        
        // AVMutableVideoComposition 管理所有视频轨道,水印添加在这上面
        let mainCompositionInst: AVMutableVideoComposition = AVMutableVideoComposition.init()
        
        // 获取视频尺寸
        var naturalSize: CGSize = clipVideoTrack.naturalSize
        // 如果视频宽度为空,手动赋值
        if isVideoAssetPortrait {
            naturalSize = CGSize.init(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        }
        
        mainCompositionInst.renderSize = naturalSize
        mainCompositionInst.instructions = [mainInstruction]
        mainCompositionInst.frameDuration = CMTime.init(value: 1, timescale: 30)
        
        // 添加水印元素
        self.applyVideoWatermarkElementToComposition(composition: mainCompositionInst, videoSize: naturalSize)
        
        return [mixComposition,mainCompositionInst]
    }
    
    /// 添加视频上的水印元素
    /// - Parameters:
    ///     - composition: 视频轨道
    ///     - videoSize: 视频尺寸
    private func applyVideoWatermarkElementToComposition(composition: AVMutableVideoComposition, videoSize: CGSize) {
        let waterImg: UIImage = UIImage.init(named: "icon_express_textimgprint")!
        let imgLayer: CALayer = CALayer.init()
        imgLayer.contents = waterImg.cgImage
        imgLayer.frame = CGRect.init(x: 80, y: 80, width: waterImg.size.width, height: waterImg.size.height)
        imgLayer.opacity = 1.0
        
        let videoLayer: CALayer = CALayer.init()
        videoLayer.frame = CGRect.init(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        
        let parentLayer: CALayer = CALayer.init()
        parentLayer.frame = CGRect.init(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(imgLayer)
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    /// 导出视频
    /// - Parameters:
    ///     - mixConposition: 视频混合轨道
    ///     - videoComposition : 视频
    ///     - destinationPath: 视频导出路径
    private func videoExport(mixConposition: AVMutableComposition, videoComposition: AVVideoComposition, destinationPath: String) {
        let exportSession: AVAssetExportSession = AVAssetExportSession.init(asset: mixConposition, presetName: AVAssetExportPresetMediumQuality)!
        exportSession.outputURL = URL.init(fileURLWithPath: destinationPath)
        exportSession.outputFileType = AVFileType.mov
        // 指示输出文件应针对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = true
        // 文件大小的设置
        exportSession.fileLengthLimit = 30 * 1024 * 1024
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case.completed:
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, #selector(self.didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
                }
            case.failed:
                print("AVAssetExportSessionStatusFailed\(String(describing: exportSession.error))")
            case.cancelled:
                print("Export Cancelled")
            default:
                break
            }
        }
    }
    
    // 相册保存成功的回调方法
    @objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
            if error != nil{
                print("Finished saving video with error\(String(describing: error))")
            }else{
                print("saving video")
            }
    }
}

// MARK: 获取视频存储路径
extension HSVideoEditManager {
    /// 获取视频路径
    /// - Parameters:
    ///     - videoName: 视频名字
    /// - Returns: 视频存储路径
    private func getVideoSavePath(videoName: String) -> String {
        let documentDicrectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let destinationPath: String = documentDicrectory.appendingFormat("/out_%@.mov", dateFormatter.string(from: Date())) as String
        print("path: \(destinationPath)")
        return destinationPath
    }
}
