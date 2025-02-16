// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import PhotosUI
import SnapKit
import Combine

class WriteReviewVC: UIViewController {
    
    struct Param {
        let storeDetailResponseModel: StoreDetailResponseModel
    }
    
    var param: Param!
    
    private var images: [UIImage] = []
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = writeReviewView
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        view.topStarsView.delegate = self
        view.navigationTitleLabel.text = param.storeDetailResponseModel.storeInfoDto.placeName
        view.topTitleLabel.text = "'\(param.storeDetailResponseModel.storeInfoDto.placeName)'의\n건강 평점을 남겨주세요!"
        view.ratingReviewView.initializeView(
            totalHealthScore: param.storeDetailResponseModel.isInDBDto.totalHealthScore,
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
        view.submitButton.addTarget(self, action: #selector(onClickSubmit), for: .touchUpInside)
        view.imageCollectionView.delegate = self
        view.imageCollectionView.dataSource = self
        view.reviewTextView.delegate = self
        return view
    }()
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onClickAddImage() {
        guard images.count < 10 else { return }
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10 - images.count
        
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
    
    @objc private func onClickSubmit() {
        let param = ReviewWriteRequest(
            placeId: param.storeDetailResponseModel.storeInfoDto.placeId,
            images: images.compactMap({ $0.jpegData(compressionQuality: 1.0) }),
            request: ReviewWriteRequest.Request(healthScore: writeReviewView.topStarsView.star, tastyScore: writeReviewView.ratingReviewView.tasteReviewView.value, cleanScore: writeReviewView.ratingReviewView.cleanReviewView.value, freshScore: writeReviewView.ratingReviewView.freshReviewView.value, nutrScore: writeReviewView.ratingReviewView.nutritionReviewView.value, body: writeReviewView.reviewTextView.text)
        )
        
        StoreRepository.shared.postReview(reviewWriteRequest: param)
            .sinkHandledCompletion(receiveValue: { reviewWriteResponseModel in
                print(reviewWriteResponseModel)
            })
            .store(in: &cancellable)
    }
    
    private func reloadImageCollectionView() {
        writeReviewView.imageCollectionView.reloadData()
        writeReviewView.updateCollectionViewWidth()
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
                    self?.images.append(image)
                    self?.reloadImageCollectionView()
                }
            }
        }
    }
}

extension WriteReviewVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        writeReviewView.submitButton.isHidden = textView.text.isEmpty || writeReviewView.topStarsView.star == 0
        writeReviewView.reviewSubLabel.text = textView.text.isEmpty ? "사진 최대 10장, 글자 최대 300자" : "\(textView.text.count) / 300"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count - range.length + text.count
        return newLength <= 300
    }
}

extension WriteReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PreviewCollectionViewCell.self), for: indexPath) as? PreviewCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.previewImageView.image = images[indexPath.row]
        cell.previewImageView.layer.cornerRadius = 10
        cell.xButton.isHidden = false
        cell.xButton.tag = indexPath.row
        cell.xButton.addTarget(self, action: #selector(onClickRemove(sender: )), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    @objc func onClickRemove(sender: UIButton) {
        images.remove(at: sender.tag)
        reloadImageCollectionView()
    }
}

extension WriteReviewVC: StarsViewDelegate {
    func onClicked() {
        writeReviewView.submitButton.isHidden = writeReviewView.reviewTextView.text.isEmpty || writeReviewView.topStarsView.star == 0
    }
}
