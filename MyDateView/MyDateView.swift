//
//  MyDateView.swift
//  MyDateChoose
//
//  Created by Myron on 2021/1/20.
//

import Foundation
import UIKit

protocol MyDateViewDelegate: NSObjectProtocol {
    func pickDateView(year:Int,month:Int,day:Int)
}

class MyDateView: BasePickView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let calendar = Calendar.init(identifier: .gregorian)
    var currentYear: Int?
    var currentMonth: Int?
    var currentDay: Int?
    var selectYear: Int?
    var selectMonth: Int?
    var selectDay: Int?
    var defaultYear: Int?
    var defaultMonth: Int?
    var defaultDay: Int?
    // 最小年份
    let minShowYear = 1900
    var yearSum = 0
    var isShowDay = true {
        didSet{
            if !isShowDay {
                selectDay = nil
            }
        }
    }
    weak var delegate: MyDateViewDelegate?
    
    override func initPickView() {
        super.initPickView()
        
        titleString = "请选择日期"
        let components = calendar.dateComponents([.year,.month,.day,.weekday], from: Date())
        currentYear = components.year
        currentMonth = components.month
        currentDay = components.day
        defaultYear = components.year
        defaultMonth = components.month
        defaultDay = components.day
        yearSum = components.year! - minShowYear + 1
        pickView.dataSource = self
        pickView.delegate = self
        setDefaultDate(year: defaultYear!, month: defaultMonth!, day: defaultDay!)
    }
    
    func setDefaultDate(year:Int,month:Int,day:Int) {
        if year > 0 {
            defaultYear = year
        }
        if month > 0 {
            defaultMonth = month
        }
        if day > 0 {
            defaultDay = day
        }
        if defaultYear! - minShowYear < 0 {
            defaultYear = currentYear! + 1
            defaultMonth = 1
            defaultDay = 1
        }
        pickView.selectRow(defaultYear! - minShowYear, inComponent: 0, animated: false)
        pickView.selectRow(defaultMonth! - 1, inComponent: 1, animated: false)
        if isShowDay {
            pickView.reloadComponent(2)
            pickView.selectRow(defaultDay! - 1, inComponent: 2, animated: false)
        }
        
    }
    
    override func confirmClick(button: UIButton) {
        super.confirmClick(button: button)
        refreshPickViewData()
        //print("year \(selectYear),month \(selectMonth),day \(selectDay)")
        if let day =  selectDay{
            delegate?.pickDateView(year: selectYear!, month: selectMonth!, day: day)
        }else {
            delegate?.pickDateView(year: selectYear!, month: selectMonth!, day: 0)
        }
        
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isShowDay {
            return 3
        }else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return self.yearSum;
        }else if(component == 1) {
            return 12;
        }else {
            // selectedRow取的是从0开始的，所以要加上1
            let year = pickView.selectedRow(inComponent: 0) + minShowYear
            let month = pickView.selectedRow(inComponent: 1) + 1
            //return getDaysWithYearAndMonth(year: year, month: month)
            return getDaysWithYearAndMonth2(year: year, month: month)
        }
    }
    
    // 获取当月有多少天
    func getDaysWithYearAndMonth2(year:Int, month:Int) -> Int {
        var dayComponents = DateComponents.init()
        dayComponents.year = year
        dayComponents.month = month
        dayComponents.day = 1
        let firstDay = calendar.date(from: dayComponents)
        let timeZone = TimeZone.current
        let seconds = timeZone.secondsFromGMT(for: firstDay!)
        let day = firstDay!.addingTimeInterval(TimeInterval(seconds))
        // 当月有多少天
        let range = calendar.range(of: .day, in: .month, for: day)
        return range?.count ?? 0
    }
    
    // 获取当月有多少天
    func getDaysWithYearAndMonth(year:Int, month:Int) -> Int{
        switch (month) {
            case 1:
                return 31
            case 2:
                if (year % 400==0 || (year % 100 != 0 && year % 4 == 0)) {
                    return 29
                }else{
                    return 28
                }
            case 3:
                return 31
            case 4:
                return 30
            case 5:
                return 31
            case 6:
                return 30
            case 7:
                return 31
            case 8:
                return 31
            case 9:
                return 30
            case 10:
                return 31
            case 11:
                return 30
            case 12:
                return 31
            default:
                return 0
        }
    }
    
    // MARK: UIPickerViewDelegate
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return "111"
//    }
    
    // pickView上面自定义显示的View
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text = ""
        if (component == 0) {
            text = "\(row + minShowYear)年"
        }else if (component == 1){
            text = "\(row + 1)月"
        }else{
            text = "\(row + 1)日"
        }
       
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
            case 0:
                if isShowDay {
                    pickerView.reloadComponent(2)
                }
            case 1:
                if (isShowDay) {
                    pickerView.reloadComponent(2)
                }
            default: break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func refreshPickViewData() {
        selectYear = pickView.selectedRow(inComponent: 0) + minShowYear
        selectMonth = pickView.selectedRow(inComponent: 1) + 1
        if isShowDay {
            selectDay = pickView.selectedRow(inComponent: 2) + 1
        }
    }

}
