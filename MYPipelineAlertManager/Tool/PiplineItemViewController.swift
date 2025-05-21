//
//  PiplineItemViewController.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit

protocol PiplineItemScheduleInformDelegate: NSObjectProtocol {
    
    func end(isOpenedVC: Bool)
}

class PiplineItemViewController: UIViewController {

    // 展示方式
    enum ShowType {
        case normal // 普通
        case last // 放在最后
        case first // 放在最前
    }
    
    weak var scheduleDelegate: PiplineItemScheduleInformDelegate?
    
    var isAlerting: Bool = false
    
    var showType: ShowType = .normal
    
    func dismiss(animated flag: Bool, isOpenedVC: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        scheduleDelegate?.end(isOpenedVC: isOpenedVC)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag, isOpenedVC: false, completion: completion)
    }
}
