//
//  MyTimeView.swift
//  MyDateChoose
//
//  Created by Myron on 2021/1/21.
//
//  时分秒 时分

import Foundation
import UIKit

protocol MyTimeViewDelegate: NSObjectProtocol {
    func pickTimeView(hour:Int,minute:Int,second:Int)
}

class MyTimeView: BasePickView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let calendar = Calendar.init(identifier: .gregorian)
    var currentHour: Int?
    var currentMinute: Int?
    var currentSecond: Int?
    var selectHour: Int?
    var selectMinute: Int?
    var selectSecond: Int?
    var defaultHour: Int?
    var defaultMinute: Int?
    var defaultSecond: Int?
    var isShowSecond = true {
        didSet{
            if !isShowSecond {
                selectSecond = nil
            }
        }
    }
    weak var delegate: MyTimeViewDelegate?
    
    override func initPickView() {
        super.initPickView()
        titleString = "请选择时间"
        let components = calendar.dateComponents([.hour,.minute,.second], from: Date())
        currentHour = components.hour
        currentMinute = components.minute
        currentSecond = components.second
        defaultHour = components.hour
        defaultMinute = components.minute
        defaultSecond = components.second
        pickView.dataSource = self
        pickView.delegate = self
        setDefaultTime(hour: defaultHour!, minute: defaultMinute!, second: defaultSecond!)
    }
    
    func setDefaultTime(hour:Int,minute:Int,second:Int) {
        if hour >= 0 {
            defaultHour = hour
        }
        if minute >= 0 {
            defaultMinute = minute
        }
        if second >= 0 {
            defaultSecond = second
        }
        
        pickView.selectRow(defaultHour!, inComponent: 0, animated: false)
        pickView.selectRow(defaultMinute!, inComponent: 1, animated: false)
        if isShowSecond {
            pickView.selectRow(defaultSecond!, inComponent: 2, animated: false)
        }
        
    }
    
    override func confirmClick(button: UIButton) {
        super.confirmClick(button: button)
        refreshPickViewData()
        if let second =  selectSecond{
            delegate?.pickTimeView(hour: selectHour!, minute: selectMinute!, second: second)
        }else {
            delegate?.pickTimeView(hour: selectHour!, minute: selectMinute!, second: 0)
        }
        
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isShowSecond {
            return 3
        }else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return 24;
        }else if(component == 1) {
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
    
    
    // MARK: UIPickerViewDelegate
    // pickView上面自定义显示的View
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text = ""
        if (component == 0) {
            text = "\(row)时"
        }else if (component == 1){
            text = "\(row)分"
        }else{
            text = "\(row)秒"
        }
       
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func refreshPickViewData() {
        selectHour = pickView.selectedRow(inComponent: 0)
        selectMinute = pickView.selectedRow(inComponent: 1)
        if isShowSecond {
            selectSecond = pickView.selectedRow(inComponent: 2)
        }
    }

}
