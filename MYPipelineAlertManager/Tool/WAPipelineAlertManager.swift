//
//  WAPipelineAlertManager.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit
import RxCocoa
import RxSwift

class WAPipelineAlertManager: NSObject {

    weak var vc: UIViewController?
    
    var nowAlertVC: PiplineItemViewController?
    
    var observationItems: BehaviorRelay<[PiplineItemViewController]> = .init(value: [])
    
    var disposable: Disposable?
    
    var isEmpty: Bool {
        observationItems.value.isEmpty
    }
    
    init(vc: UIViewController) {
        self.vc = vc
        super.init()
        // 默认开启订阅
        subscribeIfNeed()
    }
    
    deinit {
        disposable?.dispose()
        disposable = nil
    }
    
    func addVC(item: PiplineItemViewController) {
        let items = addVCByShowRule(item: item, items: observationItems.value)
        observationItems.accept(items)
    }
    
    private func addVCByShowRule(item: PiplineItemViewController, items: [PiplineItemViewController]) -> [PiplineItemViewController] {
        var items = items
        if item.showType == .last {
            items.append(item)
        } else if item.showType == .first {
            if items.first?.isAlerting ?? false { // 第一个已经展示，则放在第二个
                items.insert(item, at: 1)
            } else {
                items.insert(item, at: 0)
            }
        } else {
            var isAdd = false
            for (index, tmpItem) in items.enumerated() {
                if tmpItem.showType == .last {
                    isAdd = true
                    items.insert(item, at: index)
                    break
                }
            }
            
            if !isAdd {
                items.append(item)
            }
        }
        return items
    }
    
    func removeVCIfCan(index: Int) {
        var items = observationItems.value
        guard index >= 0 && index < items.count else {
            return
        }
        let item = items[index]
        guard !item.isAlerting else {
            return
        }
        
        items.remove(at: index)
        observationItems.accept(items)
    }
    
    func removeVCIfCan(item: PiplineItemViewController) {
        let items = observationItems.value
        for (index, tmpItem) in items.enumerated() {
            if item == tmpItem {
                removeVCIfCan(index: index)
            }
        }
    }
    
    func alertFirstIfExist() {
        guard nowAlertVC == nil else { return }
        let items = observationItems.value
        guard let first = items.first else { return }
        guard let vc else { return }
        
        first.isAlerting = true
        first.scheduleDelegate = self
        first.modalPresentationStyle = .overFullScreen
        first.modalTransitionStyle = .crossDissolve
        vc.present(first, animated: true)
        
        nowAlertVC = first
        
        subscribeIfNeed()
    }
    
    // 订阅列表，观察数据变化
    func subscribeIfNeed() {
        guard disposable == nil else { return }
        
        disposable = observationItems.asObservable().subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            guard let first = items.first else { return }
            guard !first.isAlerting else { return }
            
            alertFirstIfExist()
        })
    }
}

extension WAPipelineAlertManager: PiplineItemScheduleInformDelegate {
    
    func end(isOpenedVC: Bool) {
        var items = observationItems.value
        let first = items.removeFirst()
        first.scheduleDelegate = nil
        nowAlertVC = nil
        // 打开了活动，则等下次展示在继续打开
        if isOpenedVC {
            // 关掉订阅，再更新列表
            disposable?.dispose()
            disposable = nil
            observationItems.accept(items)
        } else {
            observationItems.accept(items)
            
            alertFirstIfExist()
        }
    }
}
