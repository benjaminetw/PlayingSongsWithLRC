//
//  PlayerView.swift
//  PlayingSongsWithLRC
//
//  Created by benjamin on 14-6-27.
//  Copyright (c) 2014年 variadic. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    let xianuo: CGFloat = 10.0
    
    weak var mainViewController: MainViewController?
    var progressSlider: UISlider?
    var playPauseBtn: UIButton?
    var nextSongBtn: UIButton?
    var lastSongBtn: UIButton?
    var playTypeBtn: UIButton?
    var beginTimeLabel: UILabel?
    var endTimeLabel: UILabel?
    var volumeSlider: UISlider?
    var isPlaying: Bool
    var playType: PlayTypeEnum
    
    init(frame: CGRect, main: MainViewController) {
        
        self.isPlaying = false
        self.playType = .xunHuanBoFang
        self.mainViewController = main
        super.init(frame: frame)
        
        
        self.setUpUI()
    }
    
    convenience init(mainViewController: MainViewController, songs: String...) {
        
        var rect = CGRectMake(0, 468, 320, 100)
        self.init(frame: rect, main: mainViewController)
    }
    
    func setUpUI() {
        
        var circleOpenPNG = UIImage(named: "circleOpen.png")
        self.playTypeBtn = UIButton.buttonWithType(.Custom) as? UIButton
        self.playTypeBtn!.setImage(circleOpenPNG, forState: .Normal)
        self.playTypeBtn!.frame = CGRectMake(20, 35 + xianuo, 30, 30)
        
        var lastSongPNG = UIImage(named: "aboveMusic.png")
        self.lastSongBtn = UIButton.buttonWithType(.Custom) as? UIButton
        self.lastSongBtn!.setImage(lastSongPNG, forState: .Normal)
        self.lastSongBtn!.frame = CGRectMake(self.playTypeBtn!.frame.origin.x + self.playTypeBtn!.frame.size.width + 35, 35 + xianuo, 30, 30)
        
        var playPNG = UIImage(named: "play.png")
        self.playPauseBtn = UIButton.buttonWithType(.Custom) as? UIButton
        self.playPauseBtn!.setImage(playPNG, forState: .Normal)
        self.playPauseBtn!.frame = CGRectMake(self.lastSongBtn!.frame.origin.x + self.lastSongBtn!.frame.size.width + 35, 35 + xianuo, 30, 30)
        
        var nextSongPNG = UIImage(named: "nextMusic.png")
        self.nextSongBtn = UIButton.buttonWithType(.Custom) as? UIButton
        self.nextSongBtn!.setImage(nextSongPNG, forState: .Normal)
        self.nextSongBtn!.frame = CGRectMake(self.playPauseBtn!.frame.origin.x + self.playPauseBtn!.frame.size.width + 35, 35 + xianuo, 30, 30)
        
        self.beginTimeLabel = UILabel(frame:CGRectMake(23, 4 + xianuo, 35, 35))
        self.beginTimeLabel!.font = UIFont.systemFontOfSize(10) as UIFont
        
        self.endTimeLabel = UILabel(frame:CGRectMake(self.frame.size.width - 40, 4 + xianuo, 35, 35))
        self.endTimeLabel!.font = UIFont.systemFontOfSize(10) as UIFont
        
        self.progressSlider = UISlider(frame: CGRectMake(0, 0, self.frame.size.width, 34))
        self.progressSlider!.maximumValue = 1.0
        self.progressSlider!.minimumValue = 0.0
        self.progressSlider!.value = 0.0
        
        
        self.addSubview(self.playPauseBtn)
        self.addSubview(self.playTypeBtn)
        self.addSubview(self.lastSongBtn)
        self.addSubview(self.nextSongBtn)
        self.addSubview(self.beginTimeLabel)
        self.addSubview(self.endTimeLabel)
        self.addSubview(self.progressSlider)
        
        self.playTypeBtn!.addTarget(self.mainViewController, action: "playType:", forControlEvents: .TouchUpInside)
        self.playPauseBtn!.addTarget(self.mainViewController, action: "playPause:", forControlEvents: .TouchUpInside)
        self.nextSongBtn!.addTarget(self.mainViewController, action: "nextSong:", forControlEvents: .TouchUpInside)
        self.lastSongBtn!.addTarget(self.mainViewController, action: "lastSong:", forControlEvents: .TouchUpInside)
        self.progressSlider!.addTarget(self.mainViewController, action: "adjustProgress:", forControlEvents: .ValueChanged)
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
