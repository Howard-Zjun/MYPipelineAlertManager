//
//  ViewController.swift
//  MYPipelineAlertManager
//
//  Created by ios on 2025/1/17.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var manager: WAPipelineAlertManager = {
        let manager = WAPipelineAlertManager(vc: self)
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.addVC(item: TmpViewController(text: "1", bgColor: .red))
        manager.addVC(item: TmpViewController(text: "2", bgColor: .blue))
        manager.addVC(item: TmpViewController(text: "3", bgColor: .orange))
    }
}

extension ViewController {
    
    class TmpViewController: PiplineItemViewController {
        
        let text: String
        
        let bgColor: UIColor
        
        lazy var lab: UILabel = {
            let lab = UILabel(frame: .init(x: 0, y: (view.frame.height - 50) * 0.5, width: view.frame.width, height: 50))
            lab.textColor = .black
            lab.text = text
            lab.textAlignment = .center
            return lab
        }()
        
        init(text: String, bgColor: UIColor) {
            self.text = text
            self.bgColor = bgColor
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = bgColor
            view.addSubview(lab)
            view.addGestureRecognizer({
                UITapGestureRecognizer(target: self, action: #selector(dismissHandle))
            }())
        }
        
        @objc func dismissHandle() {
            dismiss(animated: true, isOpenedVC: false)
        }
    }
}

