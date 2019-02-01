//
//  NewAlarm.swift
//  AlarmClock
//
//  Created by Александр Сенин on 22/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class NewAlarm: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    var datePicker: UIDatePicker!
    var backButton: UIButton!
    var completeButton: UIButton!
    var tableView: UITableView!
    var titleView: UILabel!
    var textField: UITextField!
    var trig = true
    var cells: [String : UITableViewCell] = [:]
    var alarm: Alarm!
    
    
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let newAlarm = storyboard.instantiateInitialViewController() as? NewAlarm
        newAlarm!.navigation = navigation
        return newAlarm
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let viewHight = view.frame.height
        let viewWidth = view.frame.width
        
        if alarm == nil{
            alarm = Alarm(dateTrig: Date(), weekDays: [], song: "123", title: "Alarm")
        }
        let backButtnFrame = CGRect(x: 0,
                                    y:  viewHight / 20,
                                    width: viewWidth / 4,
                                    height: viewHight / 20)
        backButton = UIButton(frame: backButtnFrame)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(#colorLiteral(red: 0.2437882423, green: 0.430860281, blue: 1, alpha: 1), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchDown)
        view.addSubview(backButton)
        
        let completeButtonFrame = CGRect(x: viewWidth - viewWidth / 4,
                                         y:  viewHight / 20,
                                         width: viewWidth / 4,
                                         height: viewHight / 20)
        completeButton = UIButton(frame: completeButtonFrame)
        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(#colorLiteral(red: 0.2437882423, green: 0.430860281, blue: 1, alpha: 1), for: .normal)
        completeButton.addTarget(self, action: #selector(complete), for: .touchDown)
        view.addSubview(completeButton)
        
        let titleViewFrame = CGRect(x: viewWidth / 2 - viewWidth / 8,
                                    y:  viewHight / 20,
                                    width: viewWidth / 4,
                                    height: viewHight / 20)
        titleView = UILabel(frame: titleViewFrame)
        titleView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleView.text = "Edit alarm"
        titleView.textAlignment = .center
        view.addSubview(titleView)
        
        
        let datePickerFrame = CGRect(x: 0,
                                     y:  backButtnFrame.maxY,
                                     width: viewWidth,
                                     height: viewHight / 3.5)
        datePicker = UIDatePicker(frame: datePickerFrame)
        datePicker.datePickerMode = .time
        datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKey: "textColor")
        view.addSubview(datePicker)
        
        let tableViewFrame = CGRect(x: 0,
                                     y: datePickerFrame.maxY,
                                     width: viewWidth,
                                     height: UITableViewCell().frame.height * 3)
        tableView = UITableView(frame: tableViewFrame, style: .grouped)
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        view.addSubview(tableView)
        
        
        
    }
    

    @objc func back(){
        navigation.transitionToView(viewControllerType: ViewController(), special: nil)
    }
    
    @objc func complete(){
        alarm.dateTrig = datePicker.date
        alarm.titleAlarm = textField.text
        navigation.transitionToView(viewControllerType: ViewController(), special: {(viewController) in
            let main = viewController as! ViewController
            main.alarms.append(self.alarm)
            main.checkTimer()
        })
    }
    
    

}

extension NewAlarm: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.separatorInset         = .init(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor        = #colorLiteral(red: 0.1122680381, green: 0.1219585612, blue: 0.1349610686, alpha: 1)
        cell.textLabel?.textColor   = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        switch indexPath.row {
        case 0:
            let nameCell                = "Repeat"
            cell.accessoryType          = .disclosureIndicator
            cell.textLabel?.text        = nameCell
            reloadWeekDay(cell: cell)
            cells[nameCell]             = cell
        case 1:
            let nameCell                = "Melody"
            cell.accessoryType          = .disclosureIndicator
            cell.textLabel?.text        = nameCell
            cell.detailTextLabel?.text  = alarm.song
            cells[nameCell]             = cell
        case 2:
            let nameCell                = "Title"
            cell.textLabel?.text        = nameCell
            cell.selectionStyle         = .none
            cells[nameCell]             = cell
            
            let textFieldFrame = CGRect(x: view.frame.width / 2.2,
                                        y: 0,
                                        width: view.frame.width / 2,
                                        height: cell.frame.height)
            textField = UITextField(frame: textFieldFrame)
            textField.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            textField.textAlignment = .right
            textField.text = alarm.titleAlarm
            textField.delegate = self
            cell.addSubview(textField)
        default:break
        }
        
        if (indexPath.row == 0) && trig{
            trig = false
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigation.transitionToView(viewControllerType: WeekTable(), special: {(viewController) in
                let weekTable = viewController as! WeekTable
                if !self.alarm.weekDays.isEmpty{
                    if self.alarm.weekDays[0] == .Always{
                        self.alarm.weekDays = [.Mo, .Tu, .We, .Th, .Fr, .Sa, .Su]
                    }
                }
                weekTable.alarm = self.alarm
            })
        default:break
        }
    }
    
    func reloadWeekDay(cell: UITableViewCell){
        var textWeek = ""
        if !alarm.weekDays.isEmpty{
            for i in alarm.weekDays{
                textWeek = textWeek + "\(i), "
            }
            let endInd = textWeek.index(textWeek.endIndex, offsetBy: -2)
            textWeek                    = String(textWeek[ ..<endInd])
            cell.detailTextLabel?.text  = textWeek
        }else{
            cell.detailTextLabel?.text  = "No repeat"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
