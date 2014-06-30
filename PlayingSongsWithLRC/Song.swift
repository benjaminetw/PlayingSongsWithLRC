//
//  Song.swift
//  PlayingSongsWithLRC
//
//  Created by benjamin on 14-6-25.
//  Copyright (c) 2014 variadic. All rights reserved.
//

import Foundation

extension Song{
    
    class func songsArray(songs: String[]) -> Song[] {
        
        var songArray: Song[] = Song[]()
        
        for songName in songs {
            
            var array = songName.componentsSeparatedByString(".")
            
            var song = Song(name: array[0], type: array[1])
            
            songArray.append(song)
        }
        
        return songArray
    }
}

class Song {
    var name: String?
    var type: String?
    var lrcString: String?
    var lrcDictionary: Dictionary<String, String>
    var lrcTimeArray: Array<String>
    var lrcTimeSecondArray: Array<Int>
    var currentTime: Int?
    var songURL: NSURL?
    init(name: String, type: String) {
        
        self.name = name
        self.type = type
        var songPath = NSBundle.mainBundle().pathForResource(self.name!, ofType: self.type!)
        self.songURL = NSURL(fileURLWithPath: songPath) as NSURL
        let lrcPath: String? = NSBundle.mainBundle().pathForResource(self.name, ofType: "lrc")
        self.lrcString = NSString.stringWithContentsOfFile(lrcPath, encoding:NSUTF8StringEncoding, error: nil)
        self.lrcDictionary = Dictionary<String, String>()
        self.lrcTimeArray = Array<String>()
        self.lrcTimeSecondArray = Array<Int>()
        self.convertLrcString()
    }
    
    func timeIndexInArray(time: Double) -> Int {
        
        var intTime: Int = Int(time)
        var lastTime: Int = self.lrcTimeSecondArray[self.lrcTimeSecondArray.count-1]
        for (index, anoterTime) in enumerate(self.lrcTimeSecondArray) {
            if anoterTime > intTime {
                return index - 1
            } else if intTime > lastTime {
                return self.lrcTimeSecondArray.count - 1
            }
        }
        
        return 0
    }
    
    func convertLrcString() {
        
        if let lrcString = self.lrcString {
            
            let array1 = lrcString.componentsSeparatedByString("\n") as String[]
            
            for string in array1 {
                if string.isEmpty != true {
                    let array2 = string.componentsSeparatedByString("]") as String[]
                    if array2[1].lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 1 {
                        
                        let timeKey = array2[0].substringFromIndex(1) as String
                        
                        self.lrcDictionary.updateValue(array2[1], forKey: timeKey)
                        
                        let timeKeyNSString = timeKey as NSString
                        var time: Int = (timeKeyNSString.substringToIndex(2) as String).toInt()! * 60 + (timeKeyNSString.substringWithRange(NSRange(location: 3, length: 2))).toInt()!
                        
                        self.lrcTimeSecondArray.append(time)
                        self.lrcTimeArray.append(timeKey)
                        
                    }
                }
            }
        }
    }
}