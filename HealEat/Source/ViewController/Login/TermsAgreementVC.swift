






import UIKit
import SnapKit
import Then

class TermsAgreementVC: UIViewController {
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "LogoImage")
        $0.contentMode = .scaleAspectFit
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private let termsOptions = [
        "이용 약관 동의 (필수)",
        "개인정보 수집 및 이용 동의 (필수)",
        "위치기반 정보 수집 동의 (필수)"
    ]
    
    private var termsIcons: [UIImageView] = []

    private let dividerView = UIView().then {
        $0.backgroundColor = UIColor.lightGray
    }

    private let allAgreeStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let allAgreeIcon = UIImageView().then {
        $0.image = UIImage(systemName: "circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true // ✅ 터치 가능하도록 설정
    }

    private let allAgreeLabel = UILabel().then {
        $0.text = "전체 동의"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }

    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
        $0.setTitleColor(UIColor(hex: "#009459"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.alpha = 0.5
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
    }

    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }

    private var selectedTerms: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
        setupActions()
    }
    
    private func setupViews() {
        view.addSubview(contentStackView)
        view.addSubview(nextButton)

        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addArrangedSubview(containerView)

        containerView.addSubview(mainStackView)
        
        for option in termsOptions {
            let icon = UIImageView().then {
                $0.image = UIImage(systemName: "circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
                $0.tintColor = .gray
                $0.contentMode = .scaleAspectFit
                $0.isUserInteractionEnabled = true // ✅ 터치 가능하도록 설정
            }

            let label = UILabel().then {
                $0.text = option
                $0.font = UIFont.systemFont(ofSize: 16)
                $0.textColor = .black
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termTapped(_:)))
            icon.addGestureRecognizer(tapGesture) // ✅ 동그라미 터치 가능하도록 제스처 추가

            let textStack = UIStackView(arrangedSubviews: [icon, label]).then {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.alignment = .center
                $0.isUserInteractionEnabled = true
            }

            let rowStack = UIStackView(arrangedSubviews: [textStack]).then {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.alignment = .center
                $0.distribution = .equalSpacing
            }
            
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(18)
            }

            termsIcons.append(icon) // ✅ 아이콘 배열에 추가
            mainStackView.addArrangedSubview(rowStack)
        }

        mainStackView.addArrangedSubview(dividerView)

        let allAgreeRowStack = UIStackView(arrangedSubviews: [allAgreeStack, UIView()]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }

        allAgreeStack.addArrangedSubview(allAgreeIcon)
        allAgreeStack.addArrangedSubview(allAgreeLabel)
        mainStackView.addArrangedSubview(allAgreeRowStack)
    }
    
    private func setupLayout() {
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }

        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }

        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        allAgreeIcon.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }

        allAgreeStack.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(20) // ✅ Stack 바로 아래 위치
            make.trailing.equalToSuperview().inset(20) // ✅ 오른쪽 정렬
            make.height.equalTo(40) // ✅ 높이 36
            make.width.equalTo(74) // ✅ 너비 74
        }
    }
    
    private func setupActions() {
        let allAgreeTapGesture = UITapGestureRecognizer(target: self, action: #selector(allAgreeTapped))
        allAgreeIcon.addGestureRecognizer(allAgreeTapGesture) // ✅ 전체 동의도 터치 가능하도록 수정
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func termTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedIcon = sender.view as? UIImageView else { return }

        if let index = termsIcons.firstIndex(of: tappedIcon) {
            let term = termsOptions[index]

            if selectedTerms.contains(term) {
                selectedTerms.remove(term)
                animateCheckmark(for: tappedIcon, isChecked: false)
            } else {
                selectedTerms.insert(term)
                animateCheckmark(for: tappedIcon, isChecked: true)
            }

            updateNextButtonState()
        }
    }

    @objc private func allAgreeTapped() {
        let isAllSelected = selectedTerms.count == termsOptions.count

        UIView.animate(withDuration: 0.2) {
            if isAllSelected {
                self.selectedTerms.removeAll()
                self.termsIcons.forEach { self.animateCheckmark(for: $0, isChecked: false) }
                self.animateCheckmark(for: self.allAgreeIcon, isChecked: false)
            } else {
                self.selectedTerms = Set(self.termsOptions)
                self.termsIcons.forEach { self.animateCheckmark(for: $0, isChecked: true) }
                self.animateCheckmark(for: self.allAgreeIcon, isChecked: true)
            }
        }

        updateNextButtonState()
    }
    
    private func animateCheckmark(for icon: UIImageView, isChecked: Bool) {
        let iconName = isChecked ? "checkmark.circle.fill" : "circle"
        UIView.transition(with: icon, duration: 0.2, options: .transitionCrossDissolve, animations: {
            icon.image = UIImage(systemName: iconName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
            icon.tintColor = isChecked ? UIColor(hex: "#009459") : .gray
        }, completion: nil)
    }

    private func updateNextButtonState() {
        let allSelected = selectedTerms.count == termsOptions.count
        nextButton.isEnabled = allSelected
        nextButton.alpha = allSelected ? 1.0 : 0.5
    }
    
    @objc private func nextButtonTapped() {
        guard selectedTerms.count == termsOptions.count else { return }
        let profileVC = ProfileVC()
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: false, completion: nil)
    }

}
