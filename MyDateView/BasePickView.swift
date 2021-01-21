//
//  BasePickView.swift
//  MyDateChoose
//
//  Created by Myron on 2021/1/20.
//

import Foundation
import UIKit

class BasePickView: UIView {
    // 背景视图
    private var contentView: UIView!
    // 选择器
    var pickView: UIPickerView!
    // 取消按钮
    private var cancelButton: UIButton!
    // 确定按钮
    private var confirmButton: UIButton!
    // 选择器高度
    var pickerViewHeight: CGFloat = 280 {
        didSet{
            undateView()
        }
    }
    private var titleLabel: UILabel!
    var titleString: String? {
        didSet{
            titleLabel.text = titleString
        }
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        contentView = UIView.init(frame:CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: pickerViewHeight))
        contentView.backgroundColor = UIColor.white
        contentView.addGestureRecognizer(UITapGestureRecognizer.init())
        addSubview(contentView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        addGestureRecognizer(tap)
        
        pickView = UIPickerView.init(frame: CGRect.init(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        contentView.addSubview(pickView)
        
        let topViewHeight: CGFloat = 40
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: contentView.frame.size.width, height: topViewHeight))
        topView.backgroundColor = UIColor.white
        contentView.addSubview(topView)
        titleLabel = UILabel.init(frame: topView.bounds)
        titleLabel.text = titleString
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        //titleLabel.backgroundColor = UIColor.blue
        topView.addSubview(titleLabel)
//        titleLabel.center = CGPoint.init(x: topView.frame.size.width * 0.5, y: topView.frame.size.height * 0.5)
        cancelButton = UIButton.init(frame: CGRect.init(x: 10, y: 0, width: 50, height: topView.frame.size.height))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelClick(button:)), for: .touchUpInside)
        topView.addSubview(cancelButton)
        confirmButton = UIButton.init(frame: CGRect.init(x: topView.frame.size.width - cancelButton.frame.size.width - cancelButton.frame.origin.x, y: cancelButton.frame.origin.y, width: cancelButton.frame.size.width, height: cancelButton.frame.size.height))
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.setTitleColor(UIColor.black, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmClick(button:)), for: .touchUpInside)
        topView.addSubview(confirmButton)
        
        // 初始化数据
        initPickView()
    }
    
    // 子类重写
    func initPickView() {
        
    }
    
    private func undateView() {
        var frame = contentView.frame
        frame.size.height = pickerViewHeight
        contentView.frame = frame
        pickView.frame = CGRect.init(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    @objc func dismissView() {
        var frame = contentView.frame
        frame.origin.y = frame.origin.y + pickerViewHeight
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame = frame
        } completion: { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelClick(button:UIButton) {
        dismissView()
    }
    
    @objc func confirmClick(button:UIButton) {
        dismissView()
    }
    
    func showView() {
        let window = getKeyWindow()
        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        var frame = contentView.frame
        frame.origin.y = frame.origin.y - contentView.frame.size.height
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame = frame
        }
        
    }
    
    private func getKeyWindow() -> UIWindow? {
        var window: UIWindow? = nil
        if #available(iOS 13.0, *) {
            for windowScene: UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    window = windowScene.windows.first
                    break
                }
            }
            
        return window
    } else {
            return UIApplication.shared.keyWindow
        }
    }


}
