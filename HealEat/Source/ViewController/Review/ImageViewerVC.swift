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
        setImage()
    }
    
    private lazy var imageViewerView: ImageViewerView = {
        let view = ImageViewerView()
        view.previousButton.addTarget(self, action: #selector(previousImage), for: .touchUpInside)
        view.nextButton.addTarget(self, action: #selector(nextImage), for: .touchUpInside)
        view.profileImageView.image = UIImage(resource: .defaultProfile)
        view.nameLabel.text = "사무엘"
        view.purposeLabel.text = "과민성 대장 증후군"
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
    private func setImage() {
        if let size = param.imageModels[param.index].size {
            imageViewerView.mainImageView.snp.updateConstraints({ make in
                make.height.equalTo(view.bounds.width * size.height / size.width)
            })
        }
        imageViewerView.mainImageView.kf.setImage(with: param.imageModels[param.index].url)
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
}
