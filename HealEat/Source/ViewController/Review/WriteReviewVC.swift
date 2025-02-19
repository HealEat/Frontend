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
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        writeReviewView.mainView.snp.updateConstraints({ make in
            make.top.equalTo(writeReviewView.separatorView0.snp.bottom).inset(keyboardFrame.height)
            make.bottom.equalToSuperview().inset(keyboardFrame.height)
        })
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.writeReviewView.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        writeReviewView.mainView.snp.updateConstraints({ make in
            make.top.equalTo(writeReviewView.separatorView0.snp.bottom)
            make.bottom.equalToSuperview()
        })
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.writeReviewView.layoutIfNeeded()
        }
    }
    
    private lazy var writeReviewView: WriteReviewView = {
        let view = WriteReviewView()
        view.topStarsView.delegate = self
        view.navigationTitleLabel.text = param.storeDetailResponseModel.storeInfoDto.placeName
        view.topTitleLabel.text = "'\(param.storeDetailResponseModel.storeInfoDto.placeName)'의\n건강 평점을 남겨주세요!"
        view.ratingReviewView.initializeView(
            totalHealthScore: param.storeDetailResponseModel.isInDBDto.totalHealthScore,
            totalCount: param.storeDetailResponseModel.isInDBDto.reviewCount,
            tasteScore: 0,
            cleanScore: 0,
            freshScore: 0,
            nutritionScore: 0
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
        
//        StoreRepository.shared.postReview(reviewWriteRequest: param)
        StoreRepository.shared.testPostReview(reviewWriteRequest: param)
            .sinkHandledCompletion(receiveValue: { [weak self] reviewWriteResponseModel in
                print(reviewWriteResponseModel)
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellable)
    }
    
    private func reloadImageCollectionView() {
        writeReviewView.imageCollectionView.reloadData()
        writeReviewView.updateCollectionViewWidth()
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
