//
//  MyDateTimeView.swift
//  MyDateChoose
//
//  Created by Myron on 2021/1/21.
//

import Foundation
import UIKit

protocol MyDateTimeViewDelegate: NSObjectProtocol {
    func pickDateTimeView(year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int)
}

class MyDateTimeView: BasePickView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let calendar = Calendar.init(identifier: .gregorian)
    var currentYear: Int?
    var currentMonth: Int?
    var currentDay: Int?
    var currentHour: Int?
    var currentMinute: Int?
    var currentSecond: Int?
    var selectYear: Int?
    var selectMonth: Int?
    var selectDay: Int?
    var selectHour: Int?
    var selectMinute: Int?
    var selectSecond: Int?
    var defaultYear: Int?
    var defaultMonth: Int?
    var defaultDay: Int?
    var defaultHour: Int?
    var defaultMinute: Int?
    var defaultSecond: Int?

    // 最小年份
    let minShowYear = 1900
    var yearSum = 0
    var isShowSecond = true {
        didSet{
            if !isShowSecond {
                selectSecond = nil
            }
        }
    }
    weak var delegate: MyDateTimeViewDelegate?
    
    override func initPickView() {
        super.initPickView()
        //pickerViewHeight = 250
        titleString = "请选择时间"
        let components = calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: Date())
        currentYear = components.year
        currentMonth = components.month
        currentDay = components.day
        currentHour = components.hour
        currentMinute = components.minute
        currentSecond = components.second
        defaultYear = components.year
        defaultMonth = components.month
        defaultDay = components.day
        defaultHour = components.hour
        defaultMinute = components.minute
        defaultSecond = components.second
        yearSum = components.year! - minShowYear + 1
        pickView.dataSource = self
        pickView.delegate = self
        setDefaultDateTime(year: defaultYear!, month: defaultMonth!, day: defaultDay!,hour: defaultHour!,minute: defaultMinute!,second: defaultSecond!)
    }
    
    func setDefaultDateTime(year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int) {
        if year > 0 {
            defaultYear = year
        }
        if month > 0 {
            defaultMonth = month
        }
        if day > 0 {
            defaultDay = day
        }
        if hour >= 0 {
            defaultHour = hour
        }
        if minute >= 0 {
            defaultMinute = minute
        }
        if second >= 0 {
            defaultSecond = second
        }
        if defaultYear! - minShowYear < 0 {
            defaultYear = currentYear! + 1
            defaultMonth = 1
            defaultDay = 1
        }
        
        pickView.selectRow(defaultYear! - minShowYear, inComponent: 0, animated: false)
        pickView.selectRow(defaultMonth! - 1, inComponent: 1, animated: false)
        //日那列数据需要更新
        pickView.reloadComponent(2)
        pickView.selectRow(defaultDay! - 1, inComponent: 2, animated: false)
        pickView.selectRow(defaultHour!, inComponent: 3, animated: false)
        pickView.selectRow(defaultMinute!, inComponent: 4, animated: false)
        if isShowSecond {
            pickView.selectRow(defaultSecond!, inComponent: 5, animated: false)
        }
        
    }
    
    override func confirmClick(button: UIButton) {
        super.confirmClick(button: button)
        refreshPickViewData()
        if let second =  selectSecond{
            delegate?.pickDateTimeView(year: selectYear!, month: selectMonth!, day: selectDay!, hour: selectHour!, minute: selectMinute!, second: second)
        }else {
            delegate?.pickDateTimeView(year: selectYear!, month: selectMonth!, day: selectDay!, hour: selectHour!, minute: selectMinute!, second: 0)
        }
        
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isShowSecond {
            return 6
        }else {
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return self.yearSum;
        }else if(component == 1) {
            return 12;
        }else if (component == 2){
            // selectedRow取的是从0开始的，所以要加上1
            let year = pickView.selectedRow(inComponent: 0) + minShowYear
            let month = pickView.selectedRow(inComponent: 1) + 1
            //return getDaysWithYearAndMonth(year: year, month: month)
            return getDaysWithYearAndMonth2(year: year, month: month)
        }else if (component == 3) {
            return 24;
        }else if(component == 4) {
            return 60;
        }else {
            return 60
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
        }else if (component == 2){
            text = "\(row + 1)日"
        }else if (component == 3) {
            text = "\(row)时"
        }else if (component == 4){
            text = "\(row)分"
        }else{
            text = "\(row)秒"
        }
       
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
            case 0:
                pickerView.reloadComponent(2)
            case 1:
                pickerView.reloadComponent(2)
            default: break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func refreshPickViewData() {
        selectYear = pickView.selectedRow(inComponent: 0) + minShowYear
        selectMonth = pickView.selectedRow(inComponent: 1) + 1
        selectDay = pickView.selectedRow(inComponent: 2) + 1
        selectHour = pickView.selectedRow(inComponent: 3)
        selectMinute = pickView.selectedRow(inComponent: 4)
        if isShowSecond {
            selectSecond = pickView.selectedRow(inComponent: 5)
        }
    }

}
