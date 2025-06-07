//
//  AlertView.swift
//  uikitCombine
//
//  Created by admin on 2025/5/31.
//

import UIKit
import Combine


protocol AlertProtocol {
    var subject: PassthroughSubject<Any, Error>? { get set }
}

class AlertView: UIView {
    var cancellables = Set<AnyCancellable>()
    var alertView: (AlertProtocol & UIView)?
    var subject = PassthroughSubject<Any, Error>()
    lazy var container: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.clipsToBounds = true
        container.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        container.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return container
    }()
    
    func show() {
        self.container.alpha = 1
        self.container.transform = CGAffineTransform.identity
    }
    
    func hide() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.container.alpha = 0.0
            self.container.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        binds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binds() {
        subject
            .sink(receiveCompletion: {[weak self] _ in
                self?.hide()
            }, receiveValue: { [weak self] _ in
            })
            .store(in: &cancellables)
    }

    func addContent(alert:AlertProtocol&UIView) {
        self.alertView = alert
        self.alertView?.subject = subject
        self.container.addSubview(alert)
        self.addSubview(self.container)
    
        alert.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alert.topAnchor.constraint(equalTo: container.topAnchor),
            alert.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            alert.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            alert.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}


extension AlertView {
    static public func show(content: AlertProtocol & UIView, parentView: UIView) -> PassthroughSubject<Any, Error> {
        let alert = AlertView(frame: UIScreen.main.bounds)
        alert.addContent(alert: content)
        parentView.addSubview(alert)
        alert.show()
        return alert.subject
    }

    static public func show(text: String, parentView: UIView) -> AnyPublisher<Int, Never> {
        let alert = AlertConfirmView(text: text)
        return show(content: alert, parentView: parentView)
            .map { $0 as? Int ?? 0 }
            .catch { _ in Just(0) }
            .eraseToAnyPublisher()
    }

}
