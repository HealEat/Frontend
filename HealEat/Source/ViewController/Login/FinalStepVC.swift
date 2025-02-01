import UIKit
import SnapKit

class FinalStepVC: UIViewController {
    // MARK: - UI Elements
    private let messageLabel = UILabel().then {
        $0.text = "김현우님을 위한 추천 매장을\n선정하고 있습니다."
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "잠시만 기다려주세요!"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .black
        $0.startAnimating()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(messageLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(activityIndicator)

        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
