//
//  StepStatusController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import Reachability

class StepStatusController: UIViewController, CBCentralManagerDelegate {

    var delegate : StepContainerDelegate?
    
    let reachability = try! Reachability()
    
    var Btmanager: CBCentralManager!
 
    @IBOutlet var switchWifi: UISwitch!
    
    @IBOutlet var switchBt: UISwitch!
    

    override func viewDidLoad() {
      super.viewDidLoad()
        self.delegate = navigationController as? StepContainerDelegate
        Btmanager = CBCentralManager()
        Btmanager.delegate = self
        checkWifiStatus()
    }
    
    func checkWifiStatus(){

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.switchWifi.setOn(true, animated: true)
            } else {
                self.switchWifi.setOn(false, animated: true)
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.switchWifi.setOn(false, animated: true)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
   func isWifiEnabled() -> Bool {
       var addresses = [String]()

       var ifaddr : UnsafeMutablePointer<ifaddrs>?
       guard getifaddrs(&ifaddr) == 0 else { return false }
       guard let firstAddr = ifaddr else { return false }

       for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
           addresses.append(String(cString: ptr.pointee.ifa_name))
       }

       freeifaddrs(ifaddr)
       return addresses.contains("awdl0")
   }
    
    

    
    @IBAction func navigateToPrevious(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func navigateToNext(_ sender: Any) {
        delegate?.updateWBStatus(wifi: parseStatus(status: switchWifi.isOn), bluetooth: parseStatus(status: switchBt.isOn))
        self.performSegue(withIdentifier: "showStepSave", sender: self)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
        case .poweredOn:
            switchBt.setOn(true, animated: true)
            break
        case .poweredOff:
            switchBt.setOn(false, animated: true)
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            break
        default:
            break
        }
    }
    
    func parseStatus(status : Bool) -> String {
        return status ? "on" : "off"
    }
    
}
