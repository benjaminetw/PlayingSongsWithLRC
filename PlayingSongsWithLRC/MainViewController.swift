//
//  MainViewController.swift
//  PlayingSongsWithLRC
//
//  Created by benjamin on 14-6-26.
//  Copyright (c) 2014 variadic. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {

    var lrcTableView: UITableView?
    var playerView: PlayerView?
    var volumeSlider: UISlider?
    var musicPlayer: MusicPlayer?
    var timer: NSTimer?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUp()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateTableView", userInfo: nil, repeats:true)
        self.timer?.fire()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp() {
        
        var backImage = UIImage(named:"backgroundImage5.jpg")
        var backView = UIImageView(image: backImage)
        backView.userInteractionEnabled = true
        self.view = backView
        
        self.lrcTableView = UITableView(frame: CGRectMake(60, 50, 200, 388), style: .Plain)
        self.lrcTableView!.delegate = self
        self.lrcTableView!.dataSource = self
        self.lrcTableView!.backgroundColor = UIColor.clearColor()
        self.lrcTableView!.separatorStyle = .None
        
        self.view.addSubview(self.lrcTableView)
        self.playerView = PlayerView(mainViewController: self)
        self.view.addSubview(self.playerView)
        
        

        self.musicPlayer = MusicPlayer(volume: 0.5, playType: .xunHuanBoFang, songs: "情非得已.mp3", "林俊杰-背对背拥抱.mp3", "梁静茹-偶阵雨.mp3")

        self.musicPlayer!.audioPlayer!.delegate = self
        
        self.volumeSlider = UISlider(frame: CGRectMake(10, 30, 300, 37))
        self.volumeSlider!.maximumValue = 1.0
        self.volumeSlider!.minimumValue = 0.0
        self.volumeSlider!.addTarget(self, action: "adjustVolume:", forControlEvents: .ValueChanged)
        self.volumeSlider!.value = self.musicPlayer!.volume
        self.view.addSubview(self.volumeSlider)
    }
    
    func configCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        let currentSong = self.musicPlayer!.currentSong!
        let key = currentSong.lrcTimeArray[indexPath.row]
        cell.textLabel!.text = currentSong.lrcDictionary[key]
        
        if self.musicPlayer!.currentLRCLine == indexPath.row {
            cell.textLabel!.textColor = UIColor(red: 0, green: 0, blue:0, alpha: 1.0)
            cell.textLabel!.font = UIFont.systemFontOfSize(12)
            
        } else {
            cell.textLabel!.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            cell.textLabel!.font = UIFont.systemFontOfSize(9)
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textAlignment = .Center
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.musicPlayer!.currentSong!.lrcTimeArray.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cellIdentifier: String = "LRCCell"
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if tableViewCell == nil {
            tableViewCell = UITableViewCell(style:.Default, reuseIdentifier: cellIdentifier)
        }
        self.configCell(tableViewCell!, indexPath: indexPath)
        return tableViewCell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 35.0
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.musicPlayer!.lastNextSong(.next)
        self.musicPlayer!.audioPlayer!.delegate = self
    }

    func updateTableView() {
        
        var setProgreeSlider: Double = self.musicPlayer!.audioPlayer!.currentTime / self.musicPlayer!.audioPlayer!.duration
        self.setProgreesValue(setProgreeSlider)
        
        var currentTime = self.musicPlayer!.audioPlayer?.currentTime
        var currentLRCLine = self.musicPlayer!.currentSong!.timeIndexInArray(currentTime!)
        self.musicPlayer!.currentLRCLine = currentLRCLine
        
        var currentRow = currentLRCLine
        
        var indexPath: NSIndexPath = NSIndexPath(forRow:currentRow, inSection:0)

        self.lrcTableView?.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        
        self.lrcTableView!.reloadData()
    }
    
    func adjustVolume(sender: UISlider) {
        println(sender.value)
        self.musicPlayer!.adjustVolume(sender.value)
    }
    
    func nextSong(sender: UIButton!) {
        self.musicPlayer!.manualPlay(.next)
        self.setPlayPauserPNG(true)
        self.musicPlayer!.audioPlayer!.delegate = self
    }
    
    func lastSong(sender: UIButton!) {
        self.musicPlayer!.manualPlay(.last)
        self.setPlayPauserPNG(true)
        self.musicPlayer!.audioPlayer!.delegate = self
    }
    
    func playPause(sender: UIButton!) {
        
        if self.playerView!.isPlaying == false {
            self.playerView!.isPlaying = true
            self.setPlayPauserPNG(self.playerView!.isPlaying)
            self.musicPlayer!.playPause(self.playerView!.isPlaying)
        } else {
            self.playerView!.isPlaying = false
            self.setPlayPauserPNG(self.playerView!.isPlaying)
            self.musicPlayer!.playPause(self.playerView!.isPlaying)
        }
    }
    
    func setProgreesValue(value: Double) {
        self.playerView!.progressSlider!.value = Float(value)
    }
    
    
    func setPlayPauserPNG(isPlaying: Bool) {
        if isPlaying {
            var pausePNG = UIImage(named: "pause.png")
            self.playerView!.playPauseBtn!.setImage(pausePNG, forState: .Normal)
        } else {
            var playPNG = UIImage(named: "play.png")
            self.playerView!.playPauseBtn!.setImage(playPNG, forState: .Normal)
        }
    }
    
    
    
    func adjustProgress(sender: UISlider!) {
        
        var value: Double = Double(sender.value)
        
        var setTime: Double = self.musicPlayer!.audioPlayer!.duration * value
        self.musicPlayer!.audioPlayer!.currentTime = setTime
    }
    
    func playType(sender: UIButton!) {
        
        var playTypePNG: UIImage?
        switch self.playerView!.playType {
        case .danQuXunHuan:
            self.playerView!.playType = .xunHuanBoFang
            playTypePNG = UIImage(named: "circleOpen.png")
        case .xunHuanBoFang:
            self.playerView!.playType = .suiJiBoFang
            playTypePNG = UIImage(named: "randomOpen.png")
        case .suiJiBoFang:
            self.playerView!.playType = .danQuXunHuan
            playTypePNG = UIImage(named: "circleClose.png")
            
        }
        self.playerView!.playTypeBtn!.setImage(playTypePNG, forState: .Normal)
        self.musicPlayer!.setPlayType(self.playerView!.playType)
    }

    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
