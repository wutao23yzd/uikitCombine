//
//  ViewController.swift
//  uikitCombine
//
//  Created by admin on 2025/5/31.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    let vm = viewModel()
    
    lazy var phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入手机号"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    lazy var captchaTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入验证码"
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    lazy var captchaView: CaptchaView = {
        let captcha = CaptchaView()
        captcha.action = Deferred { [weak self] in
            if self?.phoneTextField.text?.isEmpty == true {
                return Just(-1 as Any)
            } else {
                return Just(0 as Any)
            }
        }.eraseToAnyPublisher()
        return captcha
    }()
    
    lazy var submitButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("登录", for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return btn
    }()
    
    lazy var agreementBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("同意用户用户协议和隐私政策", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setImage(UIImage(named: "unselect"), for: .normal)
        btn.setImage(UIImage(named: "select"), for: .selected)
        btn.adjustsImageWhenHighlighted = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    func setup() {
        view.addSubview(phoneTextField)
        view.addSubview(captchaTextField)
        view.addSubview(captchaView)
        view.addSubview(submitButton)
        view.addSubview(agreementBtn)

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        captchaTextField.translatesAutoresizingMaskIntoConstraints = false
        captchaView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        agreementBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // phoneTextField constraints
            phoneTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),

            // captchaView constraints
            captchaView.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            captchaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            captchaView.heightAnchor.constraint(equalToConstant: 50),
            captchaView.widthAnchor.constraint(equalToConstant: 100),

            // captchaTextField constraints
            captchaTextField.centerYAnchor.constraint(equalTo: captchaView.centerYAnchor),
            captchaTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            captchaTextField.trailingAnchor.constraint(equalTo: captchaView.leadingAnchor, constant: -10),
            captchaTextField.heightAnchor.constraint(equalToConstant: 50),

            // submitButton constraints
            submitButton.topAnchor.constraint(equalTo: captchaTextField.bottomAnchor, constant: 100),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            submitButton.heightAnchor.constraint(equalToConstant: 50),

            // agreementBtn constraints
            agreementBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 14),
            agreementBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    
    func bind() {
        agreementBtn.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let self = self else {
                return
            }
            self.agreementBtn.isSelected = !self.agreementBtn.isSelected
        }.store(in: &cancellables)
        
        submitButton.publisher(for: .touchUpInside)
            .handleEvents(receiveOutput: {[weak self] _ in
                self?.view.endEditing(true)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.validateSignal()
                    .catch { [weak self] error -> AnyPublisher<Void, EError> in
                        guard let self = self, error.errorCode == -2 else {
                            return Fail(error: error).eraseToAnyPublisher()
                        }
                        
                        return AlertView.show(text: "请同意《用户协议》和《隐私政策》", parentView: self.view)
                            .filter { $0 > 0 }
                            .handleEvents(receiveOutput: { _ in
                                self.agreementBtn.isSelected = true
                            })
                            .flatMap { _ in
                                self.validateSignal()
                            }
                            .eraseToAnyPublisher()
                    }
                    .catch { [weak self] error -> AnyPublisher<Void, Never> in
                        if let self = self, let message = error.message {
                            AlertView.show(text:message, parentView: self.view).sink { _ in
                            }.store(in: &self.cancellables)
                        }
                        return Empty().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .flatMap { _ -> AnyPublisher<ApiCustomResponse<UserModel>, Never> in
                return NetWork.request(ApiCustomResponse<UserModel>.self)
            }
            .handleEvents(receiveOutput: { [weak self] model in
                guard let self = self else { return }
                if model.code != .Success, let msg = model.message, !msg.isEmpty {
                    AlertView.show(text:msg, parentView: self.view).sink { _ in
                    }.store(in: &self.cancellables)
                }
            })
            .map(\.data)
            .assign(to: \.userModel, on: vm)
            .store(in: &cancellables)
        
        
        vm.$userModel
            .removeDuplicates()
            .compactMap { $0 }
            .flatMap{[weak self] userModel  -> AnyPublisher<Int, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return AlertView.show(text: "姓名:\(userModel.username), \n 年龄:\(userModel.age) \n 城市:\(userModel.city)", parentView: self.view)
            }.sink {[weak self] value in
                guard let self = self else {return}
                
        }.store(in: &cancellables)
        
        
        let phoneText = phoneTextField.textPublisher().prepend("")
        let codeText = captchaTextField.textPublisher().prepend("")
        Publishers.CombineLatest(phoneText, codeText)
            .map { (texts) in
                let phone = texts.0
                let code = texts.1
                
                return !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
    }
    
    
    func validateSignal() -> AnyPublisher<Void, EError> {
        return Future<Void, EError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(EError.failure("内部错误")))
                return
            }

            let text = self.phoneTextField.text ?? ""
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let isMobile = trimmed.count == 11 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed))
            if !isMobile {
                promise(.failure(EError.failure("请输入正确的手机号")))
                return
            }
            
            let captcha = (self.captchaTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
             if captcha.count < 6  && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: captcha)) {
                 promise(.failure(EError.failure("请输入正确的验证码")))
                 return
             }

            if self.agreementBtn.isSelected == false {
                promise(.failure(EError.failure("未同意协议", code: -2)))
                return
            }

            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

