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
    
    // 定义回调 --> 返回存储地址
    typealias VideoEditEndClousre = ((String,UIImage?) -> Void)
    var videoEditEndClousre: VideoEditEndClousre?
    
    // 是否需要保存编辑的视频文件到相册 默认开启
    open var saveEditedVideoToAlbum: Bool = true
    private var isMov: Bool = false
    /// 视频添加水印
    /// - Parameters:
    ///   - videoUrl: 视频地址
    ///   - marks: 水印(文字、图片)
    public func mixVideoWithText(_ videoUrl: URL, marks: [HSImageLayer]) {
        if videoUrl.absoluteString.utf16.count == 0 {
            print("URL 为空")
            return
        }
        isMov = videoUrl.absoluteString.hasSuffix("MOV")
        let videoAsset: AVURLAsset = AVURLAsset.init(url: videoUrl)
        let compositionArray = self.addVideoAsset(videoAsset: videoAsset,marks: marks)
        self.videoExport(mixConposition: compositionArray.firstObject as! AVMutableComposition, videoComposition: compositionArray.lastObject as! AVVideoComposition, destinationPath: self.getVideoSavePath(videoName: "editVideo"), avaset: videoAsset)
    }
}

// MARK: 视频添加水印
extension HSVideoEditManager {
    /// 视频添加水印准备工作
    /// - Parameters:
    ///     - viedeoAsset: 视频素材
    /// - Returns: 视频存储路径
    private func addVideoAsset(videoAsset: AVAsset, marks:[HSImageLayer]) -> NSArray {
        // 创建AVMutableComposition 实例
        let mixComposition: AVMutableComposition = AVMutableComposition.init()
        
        // 视频通道
        let compositionVideoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let clipVideoTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        try? compositionVideoTrack.insertTimeRange(CMTimeRange.init(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
        
        // 音频通道
        let compositionAudioTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let audioTracks: [AVAssetTrack] = videoAsset.tracks(withMediaType: AVMediaType.audio)
        if audioTracks.count != 0 {
            let clipAudioTrack: AVAssetTrack = audioTracks.first! as AVAssetTrack
            try? compositionAudioTrack.insertTimeRange(CMTimeRange.init(start: CMTime.zero, duration: videoAsset.duration), of: clipAudioTrack, at: CMTime.zero)
        }
        
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
        self.applyVideoWatermarkElementToComposition(composition: mainCompositionInst, videoSize: naturalSize, marks: marks)
        
        return [mixComposition,mainCompositionInst]
    }
    
    /// 添加视频上的水印元素
    /// - Parameters:
    ///     - composition: 视频轨道
    ///     - videoSize: 视频尺寸
    private func applyVideoWatermarkElementToComposition(composition: AVMutableVideoComposition, videoSize: CGSize, marks: [HSImageLayer]) {
        
        let videoLayer: CALayer = CALayer.init()
        videoLayer.frame = CGRect.init(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        
        let parentLayer: CALayer = CALayer.init()
        parentLayer.frame = CGRect.init(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        // 因为layer的坐标系和视频的坐标系的冲突会导致y轴反向，需要下面这句调整y轴
        parentLayer.isGeometryFlipped = true
        parentLayer.addSublayer(videoLayer)
        for markLayer in marks {
            parentLayer.addSublayer(markLayer)
        }
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    /// 导出视频
    /// - Parameters:
    ///     - mixConposition: 视频混合轨道
    ///     - videoComposition : 视频
    ///     - destinationPath: 视频导出路径
    private func videoExport(mixConposition: AVMutableComposition, videoComposition: AVVideoComposition, destinationPath: String, avaset: AVAsset) {
        let presetArrays: [String] = AVAssetExportSession.exportPresets(compatibleWith: avaset)
        var presetName: String = AVAssetExportPresetHighestQuality
        
        if !presetArrays.contains(presetName) {
            presetName = AVAssetExportPresetMediumQuality
        }
        
        guard let exportSession: AVAssetExportSession = AVAssetExportSession.init(asset: isMov ? avaset : mixConposition, presetName: presetName) else {
            return
        }
        
        exportSession.outputURL = URL.init(fileURLWithPath: destinationPath)
        exportSession.outputFileType = AVFileType.mov
        // 指示输出文件应针对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = true
        // 文件大小的设置
        exportSession.fileLengthLimit = 30 * 1024 * 1024
        exportSession.videoComposition = videoComposition
        
        exportSession.exportAsynchronously { [weak self] in
            switch exportSession.status {
            case.completed:
                self?.videoEditEndClousre?(destinationPath,self?.getVideoImageWithTime(currentTime: 1.0, videoPath: destinationPath))
                if !(self?.saveEditedVideoToAlbum ?? false) {
                    return
                }
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, #selector(self?.didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
                }
            case.failed:
                print("AVAssetExportSessionStatusFailed\(String(describing: exportSession.error))")
            case.cancelled:
                print("Export Cancelled")
            case.exporting:
                print("导出进度\(exportSession.progress)")
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
        let documentDicrectory: NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let destinationPath: String = documentDicrectory.appendingFormat("/out_%@.mov", dateFormatter.string(from: Date())) as String
        print("path: \(destinationPath)")
        return destinationPath
    }
}

// MARK: 获取视频中的某一帧图片
extension HSVideoEditManager {
    /// 获取视频的 某一帧
    /// - Parameters:
    ///     - currentTime: 某一时刻单位 s
    ///     - videoPath: 视频路径
    /// - Returns: 某一帧图片
    private func getVideoImageWithTime(currentTime: CGFloat, videoPath: String) -> UIImage? {
        let loaclAvasset: AVURLAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: videoPath))
        let gen: AVAssetImageGenerator = AVAssetImageGenerator.init(asset: loaclAvasset)
        gen.appliesPreferredTrackTransform = true
        // 精确提取某一帧
        gen.requestedTimeToleranceAfter = .zero
        gen.requestedTimeToleranceBefore = .zero
        let time: CMTime = CMTime.init(seconds: currentTime, preferredTimescale: 600)
        var acturalTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: 0)
        var thumbImg: UIImage?
        do {
            let image = try gen.copyCGImage(at: time, actualTime: &acturalTime)
            thumbImg = UIImage.init(cgImage: image)
        } catch {
            print("截图发生错误了")
        }
        return thumbImg
    }
}
