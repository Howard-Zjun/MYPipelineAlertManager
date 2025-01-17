//
//  PiplineItemViewController.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit

protocol PiplineItemScheduleInformDelegate: NSObjectProtocol {
    
    func end()
}

class PiplineItemViewController: UIViewController {

    weak var scheduleDelegate: PiplineItemScheduleInformDelegate?
    
    var isAlerting: Bool = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        scheduleDelegate?.end()
    }
}
