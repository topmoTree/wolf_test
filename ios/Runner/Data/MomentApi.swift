//
//  MomentApi.swift
//  WolfpackAssessment
//
//  Copyright © 2019 wolpack-assessment. All rights reserved.
//

import Foundation

enum Icon: String {
    case alarm = "baseline_alarm_black_24pt"
    case business = "baseline_business_center_black_24pt"
    case bookmark = "baseline_class_black_24pt"
    case breakfast = "baseline_free_breakfast_black_24pt"
    case home =  "baseline_home_black_24pt"
    case pharmacy = "baseline_local_pharmacy_black_24pt"
}

enum Checkbox: String {
    case empty = "checkbox_empty"
    case checkedWhite = "checkbox_checked_white"
    case checkedGreen = "checkbox_checked_green"
}

class Moment {
    
    init(named title: String, at date: Date, withIcon icon: Icon, withMedicines medicines: [Medicine], isCollapsed: Bool = true) {
        self.title = title
        self.icon = icon
        self.medicines = medicines
        self.date = date
        self.isCollapsed = isCollapsed
    }
    
    let title: String
    let icon: Icon
    let medicines: [Medicine]
    let date: Date
    var isCollapsed: Bool
}

class Medicine {
    
    init(named name: String, isTaken taken: Bool = false) {
        self.name = name
        self.taken = taken
    }
    
    let name: String
    var taken: Bool
}

class MomentApi {
    
    private static let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    private static func breakfast(at day: String) -> Moment {
        return Moment(named: "Ontbijt", at: formatter.date(from: "2019-01-\(day) 8:00")!, withIcon: .breakfast, withMedicines: [Medicine(named: "Paracetamol", isTaken: Bool.random()), Medicine(named: "Vitamine C", isTaken: Bool.random())])
    }
    
    private static func lunch(at day: String) -> Moment {
        return Moment(named: "Lunch", at: formatter.date(from: "2019-01-\(day) 12:00")!, withIcon: .home, withMedicines: [Medicine(named: "Acebutol", isTaken: Bool.random())])
    }
    
    private static func atWork(at day: String) -> Moment {
        return Moment(named: "Op 't werk", at: formatter.date(from: "2019-01-\(day) 15:00")!, withIcon: .business, withMedicines: [Medicine(named: "Paracetamol", isTaken: Bool.random())])
    }
    
    private static func bedTime(at day: String) -> Moment {
        return Moment(named: "Voor het slapen", at: formatter.date(from: "2019-01-\(day) 22:00")!, withIcon: .alarm, withMedicines: [Medicine(named: "Melatonin")])
    }
    
    private static var moments: [Moment]? = nil
    
    static func getMoments() -> [Moment] {
        if moments == nil {
            moments = [
                breakfast(at: "01"),
                lunch(at: "01"),
                
                breakfast(at: "02"),
                lunch(at: "02"),
                atWork(at: "02"),
                
                breakfast(at: "03"),
                lunch(at: "03"),
                
                breakfast(at: "04"),
                atWork(at: "04"),
                
                
                
                breakfast(at: "06"),
                lunch(at: "06"),
                atWork(at: "06"),
                
                bedTime(at: "07"),
                
                breakfast(at: "08"),
                lunch(at: "08"),
                
                breakfast(at: "09"),
                lunch(at: "09"),
                atWork(at: "09"),
                
                breakfast(at: "10"),
                lunch(at: "10"),
                
                breakfast(at: "11"),
                atWork(at: "11"),
                
                
                
                breakfast(at: "13"),
                lunch(at: "13"),
                atWork(at: "13"),
                
                bedTime(at: "14"),
            ]
            moments?.randomElement()?.isCollapsed = false;
        }
        return moments!
    }
}
