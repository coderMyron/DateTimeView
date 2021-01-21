//
//  ViewController.swift
//  MyDateChoose
//
//  Created by Myron on 2021/1/20.
//

import UIKit

class ViewController: UIViewController, MyDateViewDelegate, MyTimeViewDelegate, MyDateTimeViewDelegate {
    
    var label: UIButton!
    var myDateView: MyDateView!
    var myTimeView: MyTimeView!
    var myDateTimeView: MyDateTimeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = UIButton.init(frame: CGRect.init(x: 20, y: 100, width: 100, height: 50))
        label.setTitleColor(UIColor.red, for: .normal)
        label.setTitle("选择时间", for: .normal)
        label.backgroundColor = UIColor.cyan
        label.addTarget(self, action: #selector(chooseDate(button:)), for: .touchUpInside)
        self.view.addSubview(label)
        
        // 日期选择
        myDateView = MyDateView.init()
        //myDateView.isShowDay = false
        myDateView.delegate = self
        //myDateView.setDefaultDate(year: 2000, month: 2, day: 4)
        
        // 时间选择
        myTimeView = MyTimeView.init()
        myTimeView.delegate = self
        //myTimeView.isShowSecond = false
        //myTimeView.setDefaultTime(hour: 7, minute: 2, second: 56)
        
        // 日期时间选择器
        myDateTimeView = MyDateTimeView.init()
        myDateTimeView.delegate = self
        //myDateTimeView.isShowSecond = false
        //myDateTimeView.setDefaultDateTime(year: 2000, month: 3, day: 12, hour: 11, minute: 4, second: 0)
    }
    
    @objc func chooseDate(button:UIButton) {
//        myDateView.showView()
//        myTimeView.showView()
        myDateTimeView.showView()
    }

    func pickDateView(year: Int, month: Int, day: Int) {
        print("year \(year),month \(month),day \(day)")
    }
    
    func pickTimeView(hour: Int, minute: Int, second: Int) {
        print("hour \(hour),minute \(minute),second \(second)")
    }

    func pickDateTimeView(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        print("year \(year),month \(month),day \(day),hour \(hour),minute \(minute),second \(second)")
    }

}

