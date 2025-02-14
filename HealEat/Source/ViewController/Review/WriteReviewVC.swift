// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import PhotosUI
import SnapKit

class WriteReviewVC: UIViewController {
    
    struct Param {
        let storeDetailResponseModel: StoreDetailResponseModel
    }
    
    var param: Param!
    
    private var reviewImageCollectionViewHandler = ReviewImageCollectionViewHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = writeReviewView
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        view.navigationTitleLabel.text = param.storeDetailResponseModel.storeInfoDto.placeName
        view.topTitleLabel.text = "'\(param.storeDetailResponseModel.storeInfoDto.placeName)'의\n건강 평점을 남겨주세요!"
        view.ratingReviewView.initializeView(
            totalScore: param.storeDetailResponseModel.isInDBDto.totalScore,
            totalCount: param.storeDetailResponseModel.isInDBDto.reviewCount,
            tasteScore: param.storeDetailResponseModel.totalStatDto.tastyScore,
            cleanScore: param.storeDetailResponseModel.totalStatDto.cleanScore,
            freshScore: param.storeDetailResponseModel.totalStatDto.freshScore,
            nutritionScore: param.storeDetailResponseModel.totalStatDto.nutrScore
        )
        view.reviewTitleLabel.text = "후기를 작성해주세요!"
        view.reviewSubLabel.text = "사진 최대 10장, 글자 최대 300자"
        view.navigationBackButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        view.addImageButton.addTarget(self, action: #selector(onClickAddImage), for: .touchUpInside)
        view.imageCollectionView.delegate = reviewImageCollectionViewHandler
        view.imageCollectionView.dataSource = reviewImageCollectionViewHandler
        return view
    }()
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onClickAddImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
}

extension WriteReviewVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // The client is responsible for presentation and dismissal
        picker.dismiss(animated: true)
        for phPickerResult in results {
            let itemProvider = phPickerResult.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self?.reviewImageCollectionViewHandler.images.append(image)
                    self?.writeReviewView.imageCollectionView.reloadData()
                    self?.writeReviewView.updateCollectionViewWidth()
                }
            }
        }
    }
}
