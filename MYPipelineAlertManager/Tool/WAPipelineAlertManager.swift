//
//  WAPipelineAlertManager.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit

class WAPipelineAlertManager: NSObject {

    weak var vc: UIViewController? {
        didSet {
            alertFirstIfExist()
        }
    }
    
    var nowAlertVC: PiplineItemViewController?
    
    var needAlertViewControllers: [PiplineItemViewController] = []
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func addVC(item: PiplineItemViewController) {
        needAlertViewControllers.append(item)
        
        if needAlertViewControllers.count == 1 {
            alertFirstIfExist()
        }
    }
    
    func removeVCIfCan(index: Int) {
        guard index >= 0 && index < needAlertViewControllers.count else {
            return
        }
        let item = needAlertViewControllers[index]
        guard !item.isAlerting else {
            return
        }
        needAlertViewControllers.remove(at: index)
    }
    
    func removeVCIfCan(item: PiplineItemViewController) {
        for (index, tmpItem) in needAlertViewControllers.enumerated() {
            if item == tmpItem {
                removeVCIfCan(index: index)
            }
        }
    }
    
    func alertFirstIfExist() {
        guard nowAlertVC == nil else { return }
        guard let first = needAlertViewControllers.first else { return }
        guard let vc else { return }
        
        first.isAlerting = true
        first.scheduleDelegate = self
        first.modalPresentationStyle = .overFullScreen
        first.modalTransitionStyle = .crossDissolve
        vc.present(first, animated: true)
        
        nowAlertVC = first
    }
}

extension WAPipelineAlertManager: PiplineItemScheduleInformDelegate {
    
    func end() {
        let first = needAlertViewControllers.removeFirst()
        first.scheduleDelegate = nil
        nowAlertVC = nil
        alertFirstIfExist()
    }
}
