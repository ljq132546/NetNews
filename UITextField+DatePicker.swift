//
//  UITextField+DatePicker.swift
//  TestField的测试
//
//  Created by Jiqing J Liu on 5/3/17.
//  Copyright © 2017 jiqing. All rights reserved.
//

import Foundation
import UIKit

//创建几种Picker
/*
 Average Daily Calorie Intake ADCI 0-3550  start: 2000    50 incre
 Average Daily Active Calories  0-1000 start 400  50 incre
 Workouts Per Week 0-20 1 in
 
 
 
 Workout Intensity
 
 Low Intensity
 Medium intensity
 High intensity
 
 
 Blood Pressure Levels- Systolic mmHG 20 - 170  1 incre
 Blood Pressure Levels- Diastolic     20 - 150  1 incre 
 Glucose   mg/dL 72 - 180 1 incre
 Total Cholesterol mg/dL  150-250  1 incre
 LDL mg/dL 90 - 160 1 incre 
 Weight lb 88-440  kg  40-200kgs
 
 */
protocol DateTextFieldDelegate: NSObjectProtocol {
    func didSelectRowOfPicker(cstring: String) -> Void
}
enum PickerType {
    case datePicker, ADCIPicker, ADACPicker, workPicker, workInPicker, BPLSPicker, BPLDPicker, glPicker, tcPicker, LDLPicker, weightPicker, agePicker
}

class DateTextField: UITextField {
    var type: PickerType = .datePicker {
        didSet{
            switch type {
            case .datePicker:
                let birthPickerView = UIDatePicker()
                birthPickerView.date = HealthDataModel.shareInstance.birthOfDateN
                birthPickerView.maximumDate = Date()
                birthPickerView.minimumDate = HealthDataModel.shareInstance.birthOfDateN
                birthPickerView.backgroundColor = UIColor.white
                birthPickerView.datePickerMode = .date
                birthPickerView.addTarget(self, action: #selector(DateTextField.observerTheDatePickerValueChange(datePicker:)), for: UIControlEvents.valueChanged)
            
                self.inputView = birthPickerView
                break
            case .weightPicker:
                let pickerView = UIPickerView()
                //设置代理
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.backgroundColor = UIColor.white
                self.inputView = pickerView
                weightComponetOne = 0
                weightComponetTwp = 0
                weightComponetThree = 0
                break
//            case .agePicker:
//                
//                break
            default:
                let pickerView = UIPickerView()
                //设置代理
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.backgroundColor = UIColor.white
                self.inputView = pickerView
                break
            }
            
            
            
            
        }
    }
   weak var pickerDelegate: DateTextFieldDelegate?
    
    //创建datePicker的监听方法
    func observerTheDatePickerValueChange(datePicker: UIDatePicker) -> Void {
        let dateString = HelpManager.getDateStrignFrom(date: datePicker.date)
        self.pickerDelegate?.didSelectRowOfPicker(cstring: dateString)
    }
    //创建selectOption
    var weightComponetOne: Int = 0
    var weightComponetTwp: Int = 0
    var weightComponetThree: Int = 0
    
}


extension DateTextField {
    
    
    
//    func setDatePickerInputView(type: PickerType) -> Void {
//        //重新创建一个Picker
//        
//        let pickerView = UIPickerView()
//        //设置代理
//        pickerView.delegate = self
//        pickerView.dataSource = self
//
//        self.inputView = pickerView
//        switch type {
//        case .datePicker:
//            //创建datePickerView
//            let datePickerView = UIDatePicker()
//            self.inputView
//
//            break
//        case .ADCIPicker:
//            
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//        case .datePicker:
//            break
//            
//        default:
//            break
//        }
////        self.inputView =
//    }
    
    
    
    
}
//创建几种Picker
/*
 Average Daily Calorie Intake ADCI 0-3550  start: 2000    50 incre
 Average Daily Active Calories  0-1000 start 400  50 incre
 Workouts Per Week 0-20 1 in
 
 
 
 Workout Intensity
 
 Low Intensity
 Medium intensity
 High intensity
 
 
 Blood Pressure Levels- Systolic mmHG 20 - 170  1 incre
 Blood Pressure Levels- Diastolic     20 - 150  1 incre
 Glucose   mg/dL 72 - 180 1 incre
 Total Cholesterol mg/dL  150-250  1 incre
 LDL mg/dL 90 - 160 1 incre
 Weight lb 88-440  kg  40-200kgs
 
 */

let workInContent = ["Low Intensity", "Medium intensity", "High intensity"]

extension DateTextField: UIPickerViewDelegate,UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .datePicker:
           return 0
       
        case .ADCIPicker:
            return 31
        case .ADACPicker:
            return 13
        case .workPicker:
            return 21
            
        case .workInPicker:
            return 3
        case .BPLSPicker:
            return 151
            
        case .BPLDPicker:
            return 131
            
        case .glPicker:
            return 109
        case .tcPicker:
            return 101
            
        case .LDLPicker:
            return 71
            
        case .weightPicker:
            if component == 0 {
                if weightComponetThree == 0 {
                    return 658
                }else{
                    return 801
                }
            }else if component == 1 {
                return 100
            }
            else{
               return 2
            }
           
        case .agePicker:
          return  HealthDataModel.shareInstance.ageN - 17
        default:
            return 0
        }
        
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if type == .weightPicker {
            return 3
        }
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .datePicker:
            return ""
        case .ADCIPicker:
            return "\(2000+row*50)"
            
            
     
        case .ADACPicker:
            return "\(400+row*50)"
           
        case .workPicker:
            return "\(row)"
            
        case .workInPicker:
            //返回三个字符串
            return workInContent[row]
            
        case .BPLSPicker:
            return "\(20 + row)"
            
        case .BPLDPicker:
            return "\(20 + row)"
        case .glPicker:
            return "\(72 + row)"
        case .tcPicker:
            return "\(150 + row)"
        case .LDLPicker:
            return "\(90 + row)"
        case .weightPicker:
            if component == 2 {
                return weightunit[row]
            }else{
                return "\(row)"
            }
        case .agePicker:
            //进行计算
            return "\(18 + row)"
        default:
            return ""
        }
    }
    
    //计算age的行数

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //判断当前的type
        var temporyString: String = ""
        switch type {
        case .datePicker:
            break
            
        case .ADCIPicker:
            //设置代理
             temporyString = "\(2000+row*50)"
            
            
        case .ADACPicker:
            temporyString = "\(400+row*50)"
        case .workPicker:
            temporyString = "\(row)"
            
        case .workInPicker:
            temporyString = workInContent[row]
        case .BPLSPicker:
            temporyString = "\(20 + row)"
            
        case .BPLDPicker:
            temporyString = "\(20 + row)"
            
        case .glPicker:
            temporyString = "\(72 + row)"
        case .tcPicker:
            temporyString = "\(150 + row)"
            
        case .LDLPicker:
            temporyString = "\(90 + row)"
            
        case .weightPicker:
            if component == 2 {
                self.weightComponetThree = row
            }else if component == 1 {
                self.weightComponetTwp = row
            }else{
                self.weightComponetOne = row
            }
            //处理体重
            if weightComponetThree == 0 {
                let factw = (Double(weightComponetOne) + Double(weightComponetTwp)/100) * 2.205
                let factK = Double(weightComponetOne) + Double(weightComponetTwp)/100
                temporyString = String(format: "%.2flb (%.2fkg)", factw, factK)
            }else{
                let factw = Double(weightComponetOne) + Double(weightComponetTwp)/100
                let factK = factw * 0.454
                temporyString = String(format: "%.2flb (%.2fkg)", factw, factK)
            }
            
            break
        case .agePicker:
            temporyString = "\(18 + row)"
        default:
            break
           
        }
        self.pickerDelegate?.didSelectRowOfPicker(cstring: temporyString)
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if type == .workInPicker{
        return 200
        }else{
            return 70
        }
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    
}

