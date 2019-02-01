//
//  WeekTable.swift
//  AlarmClock
//
//  Created by Александр Сенин on 26/01/2019.
//  Copyright © 2019 Александр Сенин. All rights reserved.
//

import UIKit

class WeekTable: UIViewController, NavigationProtocol{
    var navigation: Navigation!
    var backButton: UIButton!
    var tableView: UITableView!
    var titleView: UILabel!
    var alarm: Alarm!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    static func storyboardInstance(navigation: Navigation) -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let weekTable = storyboard.instantiateInitialViewController() as? WeekTable
        weekTable!.navigation = navigation
        return weekTable
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let viewHight = view.frame.height
        let viewWidth = view.frame.width
        
        let backButtnFrame = CGRect(x: 0,
                                    y:  viewHight / 20,
                                    width: viewWidth / 4,
                                    height: viewHight / 20)
        backButton = UIButton(frame: backButtnFrame)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(#colorLiteral(red: 0.2437882423, green: 0.430860281, blue: 1, alpha: 1), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchDown)
        view.addSubview(backButton)
        
        let titleViewFrame = CGRect(x: viewWidth / 2 - viewWidth / 8,
                                    y:  viewHight / 20,
                                    width: viewWidth / 4,
                                    height: viewHight / 20)
        titleView = UILabel(frame: titleViewFrame)
        titleView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleView.text = "Repeat"
        titleView.textAlignment = .center
        view.addSubview(titleView)
        
        let tableViewFrame = CGRect(x: 0,
                                    y: backButtnFrame.maxY,
                                    width: viewWidth,
                                    height: UITableViewCell().frame.height * 8)
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
        if alarm.weekDays.count == 7{
            alarm.weekDays = [.Always]
        }
        navigation.transitionToView(viewControllerType: NewAlarm(), special: {(viewController) in
            let newAlarm = viewController as! NewAlarm
            newAlarm.reloadWeekDay(cell: newAlarm.cells["Repeat"]!)
        })
    }

}

extension WeekTable: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.separatorInset         = .init(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor        = #colorLiteral(red: 0.1122680381, green: 0.1219585612, blue: 0.1349610686, alpha: 1)
        cell.selectionStyle         = .none
        cell.textLabel?.textColor   = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.accessoryType = .none
        
        switch indexPath.row {
        case 0:
            let nameCell            = "Sunday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 6{
                    cell.accessoryType = .checkmark
                }
            }
            
            
        case 1:
            let nameCell            = "Monday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 0{
                    cell.accessoryType = .checkmark
                }
            }
            
        case 2:
            let nameCell            = "Tuesday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 1{
                    cell.accessoryType = .checkmark
                }
            }
            
        case 3:
            let nameCell            = "Wednesday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 2{
                    cell.accessoryType = .checkmark
                }
            }
            
        case 4:
            let nameCell            = "Thursday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 3{
                    cell.accessoryType = .checkmark
                }
            }
            
        case 5:
            let nameCell            = "Friday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 4{
                    cell.accessoryType = .checkmark
                }
            }
            
        case 6:
            let nameCell            = "Saturday"
            cell.textLabel?.text    = nameCell
            for i in alarm.weekDays{
                if i.rawValue == 5{
                    cell.accessoryType = .checkmark
                }
            }
            
        default:break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        var weekDay = Week.Always
        switch indexPath.row {
        case 0: weekDay = .Su
        case 1: weekDay = .Mo
        case 2: weekDay = .Tu
        case 3: weekDay = .We
        case 4: weekDay = .Th
        case 5: weekDay = .Fr
        case 6: weekDay = .Sa
        default:break
        }
        
        if cell.accessoryType == .none{
            cell.accessoryType = .checkmark
            alarm.weekDays.append(weekDay)
        }else{
            cell.accessoryType = .none
            for i in 0 ..< alarm.weekDays!.count{
                if alarm.weekDays![i] == weekDay{
                    alarm.weekDays!.remove(at: i)
                    break
                }
            }
        }
    }
}
