import UIKit
import Combine

class CaptchaView: UIView {
    
    var value: String?
    var action: AnyPublisher<Any, Never>?

    let count: Int = 60
    
    var cancellables = Set<AnyCancellable>()
    private let tapSubject = PassthroughSubject<Void, Never>()

    lazy var captchaBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(UIColor.gray, for: .disabled)
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    deinit {
        print("WMEditCaptchaView deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        addSubview(captchaBtn)
        captchaBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captchaBtn.heightAnchor.constraint(equalToConstant: 34),
            captchaBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            captchaBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            captchaBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            captchaBtn.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 0),
            captchaBtn.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 0)
        ])
        bind()
    }
    
    
    @objc private func buttonTapped() {
        tapSubject.send(())
    }
    
    func bind() {
        tapSubject
            .flatMap { [weak self] _ -> AnyPublisher<Any, Never> in
               guard let self = self, let action = self.action else {
                   return Just(-1).eraseToAnyPublisher()
               }
               return action
            }
            .compactMap { $0 as? Int }
            .filter { $0 != -1 }
            .handleEvents(receiveOutput: { _ in
               // pop "验证码发送成功"
            })
            .flatMap { [weak self] value -> AnyPublisher<Int, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                let initialCount = self.count
                return Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .scan(initialCount) { count, _ in count - 1 }
                    .prepend(initialCount)
                    .prefix(while: { $0 >= 0 })
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] remaining in
               guard let self = self else { return }
               if remaining == 0 {
                   self.captchaBtn.isEnabled = true
                   self.captchaBtn.setTitle("重新获取", for: .normal)
                   self.captchaBtn.setAttributedTitle(nil, for: .normal)
                   
               } else {
                   self.captchaBtn.isEnabled = false
                   let attrTitle = NSAttributedString(
                       string: "\(remaining)s",
                       attributes: [.font: UIFont.systemFont(ofSize: 14)]
                   )
                   self.captchaBtn.setAttributedTitle(attrTitle, for: .normal)
                   self.captchaBtn.setTitle(nil, for: .normal)
               }
            }
            .store(in: &cancellables)
    }
    
    func reset() {
        cancellables.removeAll()
        bind()
        captchaBtn.setAttributedTitle(nil, for: .normal)
        captchaBtn.setTitle("获取验证码", for: .normal)
        captchaBtn.isEnabled = true
    }
}
