//
//  MusicPlayer.swift
//  PlayingSongsWithLRC
//
//  Created by benjamin on 14-6-26.
//  Copyright (c) 2014 variadic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum PlayTypeEnum : Int {
    case danQuXunHuan
    case xunHuanBoFang
    case suiJiBoFang
}

enum NextLastEnum: Int{
    case next
    case last
}
class MusicPlayer {
    

    var audioPlayer: AVAudioPlayer?
    var songs: Array<Song>?
    var volume: Float
    var playType: PlayTypeEnum
    var currentSong: Song?
    var currentIndex: Int?
    var currentLRCLine: Int?
    var timer: NSTimer?
    var danQuXunHuan: Bool
    init(volume: Float, songs: Array<Song>, playType: PlayTypeEnum) {
        self.volume = volume
        self.songs = songs
        self.playType = .xunHuanBoFang
        self.currentSong = self.songs![0]
        self.currentIndex = 0
        self.currentLRCLine = 0
        self.danQuXunHuan = false
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.songs![0].songURL, error: nil) as AVAudioPlayer
        self.audioPlayer!.volume = self.volume
    }
    convenience init(volume: Float, playType: PlayTypeEnum, songs: String...) {
        var songsArray: Song[] = Song.songsArray(songs)
        self.init(volume: volume, songs: songsArray, playType: playType)
    }
    func playPause(isPlaying: Bool) {
        if isPlaying {
            self.audioPlayer!.play()
        } else {
            self.audioPlayer!.pause()
        }
    }
    
    
    func lastNextSong(value: NextLastEnum) {
        
        if self.playType == .suiJiBoFang {
            var songCount = self.songs?.count
            var ranInt: Int = Int(rand()) % songCount!
            self.currentIndex = ranInt
            self.playSongAtIndex(ranInt)
        } else if self.danQuXunHuan == false{
            if value == .next {
                var tempIndex: Int = self.currentIndex! + 1
                if tempIndex < self.songs!.count {
                    self.currentIndex = tempIndex
                } else {
                    tempIndex = 0
                    self.currentIndex = tempIndex
                }
                self.playSongAtIndex(tempIndex)
            } else {
                var tempIndex: Int = self.currentIndex! - 1
                if tempIndex >= 0 {
                    self.currentIndex = tempIndex
                } else {
                    tempIndex = self.songs!.count - 1
                    self.currentIndex = tempIndex
                }
                self.playSongAtIndex(tempIndex)
            }
        } else {
            self.playSongAtIndex(self.currentIndex!)
        }
    }
    
    func manualPlay(value: NextLastEnum) {
        
        if self.playType == .suiJiBoFang {
            var songCount = self.songs?.count
            var ranInt: Int = Int(rand()) % songCount!
            self.currentIndex = ranInt
            self.playSongAtIndex(ranInt)
        } else{
            if value == .next {
                var tempIndex: Int = self.currentIndex! + 1
                if tempIndex < self.songs!.count {
                    self.currentIndex = tempIndex
                } else {
                    tempIndex = 0
                    self.currentIndex = tempIndex
                }
                self.playSongAtIndex(tempIndex)
            } else {
                var tempIndex: Int = self.currentIndex! - 1
                if tempIndex >= 0 {
                    self.currentIndex = tempIndex
                } else {
                    tempIndex = self.songs!.count - 1
                    self.currentIndex = tempIndex
                }
                self.playSongAtIndex(tempIndex)
            }
        }
    }
    
    func adjustVolume(value: Float) {
        self.volume = value
        self.audioPlayer!.volume = value
    }
    
    func setPlayType(playType: PlayTypeEnum) {
        if playType == .danQuXunHuan {
            self.danQuXunHuan = true
        } else {
            self.danQuXunHuan = false
        }
        self.playType = playType
    }
    
    func playSongAtIndex(index: Int) {
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.songs?[index].songURL, error: nil)
        self.audioPlayer!.play()
        self.audioPlayer!.volume = volume
        self.currentSong = self.songs?[index]
        self.currentLRCLine = 0
    }
}

