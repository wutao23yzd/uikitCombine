//
//  AlertConfirmView.swift
//  uikitCombine
//
//  Created by admin on 2025/5/31.
//

import UIKit
import Combine

class AlertConfirmView: UIView, AlertProtocol {
    
    var subject: PassthroughSubject<Any, any Error>?
    var cancellables = Set<AnyCancellable>()
    lazy var tipLable: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.subject?.send(0)
                self?.subject?.send(completion: .finished)
            }
            .store(in: &cancellables)
        return button
    }()
    
    lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.publisher(for: .touchUpInside)
               .sink { [weak self] _ in
                   self?.subject?.send(1)
                   self?.subject?.send(completion: .finished)
               }
               .store(in: &cancellables)
        return button
    }()
    
    lazy var actionStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cancelBtn, confirmBtn])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 0
        return sv
    }()
    
    convenience init(text:String) {
        self.init()
        self.tipLable.text = text
        backgroundColor = UIColor.white
        clipsToBounds = true
        
        addSubview(actionStackView)
        addSubview(tipLable)
        
        translatesAutoresizingMaskIntoConstraints = false
        tipLable.translatesAutoresizingMaskIntoConstraints = false
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 90),
            heightAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            tipLable.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tipLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tipLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            actionStackView.topAnchor.constraint(equalTo: tipLable.bottomAnchor),
            actionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}



