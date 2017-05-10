//
//  LocationService.swift
//  AIAMobile_Swift
//
//  Created by Sonic Lin on 7/20/16.
//  Copyright © 2016 PricewaterhouseCoopers. All rights reserved.
//

import UIKit
import MapKit
protocol LocationServiceProtocol: NSObjectProtocol {
    func userLocatedInSpecialArea(isIn: Bool)
    func trackingLocationDidFailWithError(error: NSError)
    func stopLocating()
    func locationTimeOut() -> Void
    //  func uploadcurrentLocation()
}

class LocationService: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: LocationService{
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LocationService? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationService()
        }
        return Static.instance!
    }
    //定义定位超时时间
    var locationTimeOutInterval: Int = 100
    var timer: NSTimer?
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    weak var delegate: LocationServiceProtocol?
    var locationAddress: String?
    //add detail infomation
    var locationDetailAddress: String?
    var locationIsUpdate: Bool = false
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else{
            return
        }
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        //    locationManage
        locationManager.delegate = self
    }
    
    func startUpdateLocation() -> Void{
        //    self.locationManager?.requestLocation()
        if timer != nil {
            return
        }
        locationIsUpdate = false
        self.locationManager?.startUpdatingLocation()
        //开始定位,设置定位超时
        locationTimeOutInterval = 30
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(LocationService.updateLocationTime) , userInfo: nil, repeats: true)
        //        timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(LocationService.updateLocationTime) , userInfo: nil, repeats: true)
        //        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        //        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    //检测定位时间
    func updateLocationTime() -> Void {
        //超时检测
        locationTimeOutInterval = locationTimeOutInterval - 1
        if locationIsUpdate {
            return
        }else{
            if locationTimeOutInterval < 0 {
                delegate?.locationTimeOut()
                stopUpdateLocation()
                return
            }
            
        }
    }
    
    func stopUpdateLocation() -> Void{
        self.locationIsUpdate = false
        self.locationManager?.stopUpdatingLocation()
        
        timer?.invalidate()
        timer = nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //    self.locationManager?.stopUpdatingLocation()
        print("location updated")
        guard let location = locations.last else{
            return
        }
        let lastLocationTime = location.timestamp
        let howRecent = NSDate().timeIntervalSinceDate(lastLocationTime)
        print("Time to evaluate problem: \(howRecent) seconds")
        // 2 mintues  change 2m to 15m
        if abs(howRecent) < 15 * 60 {
            manager.stopUpdatingLocation()
            locationIsUpdate = true
            print("location changed")
            self.lastLocation = location
            
            timer?.invalidate()
            timer = nil
            
            updateLocation(location)
            
        }else{
            
        }
        
        
        
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        guard let delegate = self.delegate else{
            return
        }
        
        
        timer?.invalidate()
        timer = nil
        
        
        delegate.trackingLocationDidFailWithError(error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            break
        case .Restricted:
            break
        case .Denied:
            break
        case .AuthorizedAlways:
            manager.startUpdatingLocation()
        case .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
        }
        
    }
    
    private func updateLocation(currentLocation: CLLocation) -> Void{
        
        guard let delegate = self.delegate else{
            return
        }
        let geoCode: CLGeocoder = CLGeocoder()
        geoCode.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error == nil{
                if let placemark: CLPlacemark = placemarks![(placemarks?.count)! - 1] as CLPlacemark {
                    if  let addressDic = placemark.addressDictionary {
                        if  let country = addressDic["Country"] as? String {
                            self.locationAddress = country
                            if let state = addressDic["State"] as? String {
                                self.locationDetailAddress = country + " " + state
                                if let street = addressDic["Thoroughfare"] as? String {
                                    self.locationDetailAddress =  country + " " + state + " " + street
                                    if let streetNo = addressDic["SubThoroughfare"] as? String {
                                        
                                        self.locationDetailAddress = country + " " +  " "  + state + " " + street + " " + streetNo
                                        
                                        //
                                    }
                                    
                                }}
                            
                            
                            
                            
                            if country  == "中国香港" || country == "香港" || country == "Hong Kong" || country == "中国澳门特别行政区" || country == "澳门" || country == "Macau" || country == "Macao" || country == "澳門" {
                                delegate.userLocatedInSpecialArea(true)
                            }else{
                                if projectIsDeveloperMode {
                                    delegate.userLocatedInSpecialArea(true)
                                }else{
                                    delegate.userLocatedInSpecialArea(false)
                                }
                                
                            }
                        }
                        
                    }
                    
                }
            }else{
                // error is existed
                delegate.trackingLocationDidFailWithError(error!)
            }
        }
    }
    
}
