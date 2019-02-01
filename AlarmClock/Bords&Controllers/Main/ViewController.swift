//
//  ViewController.swift
//  AlarmClock
//
//  Created by Александр Сенин on 08/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
    

class ViewController: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {return ViewController()}
    
    
    var notificationSoundLookupTable = [String: SystemSoundID]()
    var player: AVAudioPlayer!
    var playerSilens: AVAudioPlayer!
    var alarms: [Alarm] = []
    var timer: Timer!
    
    
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var lab5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lab1.text = ""
        lab2.text = ""
        lab3.text = ""
        lab4.text = ""
        lab5.text = ""
        navigation = Navigation(viewController: self)
        
        playerSilens = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "321", withExtension: "mp3")!)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                            mode: AVAudioSession.Mode.default,
                                                            options: AVAudioSession.CategoryOptions.mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        playerSilens.numberOfLoops = -1
        playerSilens.volume = 0
        
    }
    
    func checkTimer(){
        if alarms.isEmpty{
            timer.invalidate()
            timer = nil
            playerSilens.stop()
        }else if timer == nil{
            start()
        }
    }
    
    func start(){
        playerSilens.play()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.playerSilens.play()
            
            self.lab5.text = self.lab4.text
            self.lab4.text = self.lab3.text
            self.lab3.text = self.lab2.text
            self.lab2.text = self.lab1.text
            self.lab1.text = "check: \(Date())"
            print("check: start \(Date())")
            
            
            for i in 0 ..< self.alarms.count{
                let alarm = self.alarms[i]
                let nowDateComp = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
                let alarmDateComp = Calendar.current.dateComponents([.hour, .minute], from: alarm.dateTrig)
                
                if alarm.repit{
                    if alarm.weekDays[0] != .Always{
                        var next = false
                        for j in alarm.weekDays{
                            if j.rawValue == (nowDateComp.weekday! - 2){
                                next = true
                                continue
                            }
                        }
                        if !next{
                            print("check feild week")
                            
                            continue
                        }
                    }
                }
                if alarmDateComp.hour! != nowDateComp.hour!{
                    print("check: feild hour")
                    
                    continue
                }
                if alarmDateComp.minute! != nowDateComp.minute!{
                    print("check: feild min")
                    
                    continue
                }
                print("check: complite")
                self.eventWith(song: alarm.song)
                if !alarm.repit{
                    self.alarms.remove(at: i)
                }
                self.checkTimer()
            }
        }
    
    }
    
    @IBAction func stops(_ sender: Any) {
        navigation.transitionToView(viewControllerType: NewAlarm(), special: nil)
    }
    
    @IBAction func stop(_ sender: Any) {
        player.stop()
    }
    
    @objc func eventWith(song: String) {
        player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: song, withExtension: "mp3")!)
        player.numberOfLoops = -1
        player.play()
        
    }

}

