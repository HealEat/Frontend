// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class ImageViewerVC: UIViewController {
    
    struct Param {
        let imageModel: ImageModel
    }
    var param: Param!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = imageViewerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let size = param.imageModel.size {
            imageViewerView.mainImageView.snp.makeConstraints({ make in
                make.height.equalTo(view.bounds.width * size.height / size.width)
            })
        }
        imageViewerView.mainImageView.kf.setImage(with: param.imageModel.url)
    }
    
    private lazy var imageViewerView: ImageViewerView = {
        let view = ImageViewerView()
        return view
    }()
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
}
