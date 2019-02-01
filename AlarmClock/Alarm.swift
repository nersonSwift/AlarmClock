//
//  Alarm.swift
//  AlarmClock
//
//  Created by Александр Сенин on 24/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

enum Week : Int{
    case Mo
    case Tu
    case We
    case Th
    case Fr
    case Sa
    case Su
    case Always
}

class Alarm {
    var titleAlarm: String!
    var dateTrig: Date!
    var timer: Timer!
    var repitingTimer: Timer!
    var on: Bool!
    var weekDays: [Week]!
    var song: String!
    
    var repit: Bool{
        if weekDays.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    init(dateTrig: Date, weekDays: [Week], song: String, title: String) {
        self.titleAlarm = title
        self.dateTrig = dateTrig
        self.weekDays = weekDays
        self.song = song
    }
}
