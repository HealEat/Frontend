// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ImageViewerVC: UIViewController {
    
    struct Param {
        let imageModels: [ImageModel]
        var index: Int
    }
    var param: Param!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = imageViewerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageViewerView.profileView.isHidden = false
        imageViewerView.xButton.isHidden = false
        setImage()
    }
    
    private lazy var imageViewerView: ImageViewerView = {
        let view = ImageViewerView()
        view.previousButton.addTarget(self, action: #selector(previousImage), for: .touchUpInside)
        view.nextButton.addTarget(self, action: #selector(nextImage), for: .touchUpInside)
        view.purposeButton.addTarget(self, action: #selector(onClickPurpose), for: .touchUpInside)
        view.xButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.profileImageView.image = UIImage(resource: .defaultProfile)
        return view
    }()
    
    @objc private func previousImage() {
        param.index = max(0, param.index - 1)
        setImage()
    }
    @objc private func nextImage() {
        param.index = min(param.imageModels.count - 1, param.index + 1)
        setImage()
    }
    @objc private func onClickPurpose() {
        if param.imageModels[param.index].type != .daum { return }
        guard let url = param.imageModels[param.index].info.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private func setImage() {
        if let size = param.imageModels[param.index].size {
            imageViewerView.mainImageView.snp.updateConstraints({ make in
                make.height.equalTo(view.bounds.width * size.height / size.width)
            })
        }
        imageViewerView.nameLabel.text = param.imageModels[param.index].info.name
        switch param.imageModels[param.index].type {
        case .review:
            imageViewerView.purposeButton.configuration?.attributedTitle = AttributedString(param.imageModels[param.index].info.currentPurposes.joined(separator: ", "), attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 10, weight: .light),
                .foregroundColor: UIColor.healeatGray1,
            ]))
            imageViewerView.profileImageView.kf.setImage(with: param.imageModels[param.index].info.url, placeholder: UIImage(resource: .defaultProfile))
        case .daum:
            imageViewerView.purposeButton.configuration?.attributedTitle = AttributedString(param.imageModels[param.index].info.url?.absoluteString ?? "", attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 10, weight: .light),
                .foregroundColor: UIColor.healeatGray1,
            ]))
            imageViewerView.profileImageView.image = UIImage(resource: .defaultProfile)
        }
        imageViewerView.mainImageView.kf.setImage(with: param.imageModels[param.index].imageUrl)
        
        imageViewerView.previousButton.isHidden = param.index == 0
        imageViewerView.nextButton.isHidden = param.index == param.imageModels.count - 1
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
}
