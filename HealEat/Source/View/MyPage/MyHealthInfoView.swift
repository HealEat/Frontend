// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

class MyHealthInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "나의 건강 목표"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }

    private let tagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    } // 태그들을 담을 스택 뷰
    
    private func setViews() {
        
        addSubview(titleLabel)
        addSubview(tagStackView)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(122.5)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(21)
        }

        tagStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32.5)
            $0.leading.trailing.equalToSuperview()
            
        }
    }

    func updateUI(with healthInfo: MyHealthInfoResponse) {
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if !healthInfo.diseases.isEmpty {
            addTagSection(title: "질병으로 인한 건강 상의 불편함", tags: healthInfo.diseases)
        }
        if healthInfo.vegetarian != "NONE" {
            addTagSection(title: "비건 종류", tags: [healthInfo.vegetarian])
        }
        if healthInfo.diet != "NONE" {
            addTagSection(title: "나에게 필요한 식사", tags: [healthInfo.diet])
        }
        for qna in healthInfo.qnas {
            addTagSection(title: qna.question, tags: qna.answers)
        }
    }

    // 태그 섹션 추가
    private func addTagSection(title: String, tags: [String]) {
        let sectionLabel = UILabel()
        sectionLabel.text = title
        sectionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        sectionLabel.textColor = .black

        let tagStack = UIStackView()
        tagStack.axis = .horizontal
        tagStack.spacing = 8
        tagStack.alignment = .leading

        for tag in tags {
            let tagLabel = createTagLabel(text: tag)
            tagStack.addArrangedSubview(tagLabel)
        }

        let sectionStack = UIStackView(arrangedSubviews: [sectionLabel, tagStack])
        sectionStack.axis = .vertical
        sectionStack.spacing = 5
        tagStackView.addArrangedSubview(sectionStack)
    }

    private func createTagLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return label
    }
}


extension UILabel {
    private struct Padding {
        static var edgeInsets = UIEdgeInsets()
    }

    var padding: UIEdgeInsets {
        get { return Padding.edgeInsets }
        set {
            Padding.edgeInsets = newValue
            setNeedsDisplay()
        }
    }

    override open var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + padding.left + padding.right
        let height = size.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
