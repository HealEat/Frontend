// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster
import SDWebImage
import PhotosUI

class HGBottomSheetVC: UIViewController, DropDownDataSourceDelegate  {
    
    weak var delegate: HealthGoalUpdateDelegate?

    var planId: Int?
    var goalNum: Int?
    var duration: String?
    var count: Int?
    var goal: String?
    
    var existingImages: [MemoImage] = [] // 기존 서버에서 받은 이미지 (URL + ID)
    var imagesToShow: [(id: Int?, image: UIImage)] = [] // 모든 이미지 저장 (기존 + 신규)
    var imageToSave: [UIImage] = [] // 새로 추가된 이미지
    var imageToDelete: [Int] = [] // 삭제할 기존 이미지 ID 리스트

    private let dateDataSource = DropDownDataSource(items: HealthPlanDuration.allCases.map { $0.title })
    private let countDataSource = DropDownDataSource(items: (1...10).map { "\($0)회"})
    
    
    // MARK: - UI Properties
    private lazy var goalNumLabel = createLabel(text: "목표 \(goalNum ?? 0)", fontSize: 16, textColor: .black)
    private lazy var durationLabel = createLabel(text: "기간")
    private lazy var countLabel = createLabel(text: "횟수")
    private lazy var goalLabel = createLabel(text: "목표")

    private lazy var durationButton = DropDownButton().then {
        $0.label.text = duration ?? "기간"
        $0.addTarget(self, action: #selector(dateBtnClicked), for: .touchUpInside)
    }
    private lazy var countButton = DropDownButton().then {
        if let count = count {
            $0.label.text = "\(count)회"
        } else {
            $0.label.text = "횟수를 선택하세요."
        }
        $0.addTarget(self, action: #selector(countBtnClicked), for: .touchUpInside)
    }
    
    private lazy var goalTextField = UITextField().then {
        $0.text = goal ?? "목표"
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        let placeholderText = "목표를 작성하세요."
        let attributedString = NSMutableAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.healeatGray5, .font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        $0.attributedPlaceholder = attributedString
        $0.addLeftPadding()
        $0.textColor = UIColor.healeatGray5
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textAlignment = .left
    }
    
    private lazy var imageSelectCollectionView = ImageSelectionCollectionView().then {
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }
    
    private lazy var deleteButton = createButton(title: "삭제", titleColor: .healeatGray5, backgroundColor: .healeatGray3, action: #selector(saveBtnClicked))
    private lazy var saveButton = createButton(title: "저장", titleColor: .healeatGreen1, backgroundColor: .healeatLightGreen, action: #selector(saveBtnClicked))
    
    private lazy var durationStack = createStackView([durationLabel, durationButton])
    private lazy var countStack = createStackView([countLabel, countButton])
    private lazy var goalStack = createStackView([goalLabel, goalTextField])
    private lazy var buttonStack = createStackView([deleteButton, saveButton], alignment: .fill, distribution: .fillEqually, spacing: 26)
    
    private lazy var dateDropDownTableView = DropDownTableView().then {
        $0.delegate = dateDataSource
        $0.dataSource = dateDataSource
        $0.tag = 0
    }
    private lazy var countDropDownTableView = DropDownTableView().then {
        $0.delegate = countDataSource
        $0.dataSource = countDataSource
        $0.tag = 1
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setImages()
        hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - Setup UI
    private func setupView() {
        view.backgroundColor = .white
        [goalNumLabel, durationStack, countStack, goalStack, imageSelectCollectionView, buttonStack,
         dateDropDownTableView, countDropDownTableView].forEach { view.addSubview($0) }
        dateDropDownTableView.isHidden = true
        countDropDownTableView.isHidden = true
        dateDataSource.delegate = self
        countDataSource.delegate = self
        
        goalNumLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(30)
        }
        durationStack.snp.makeConstraints { make in
            make.top.equalTo(goalNumLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
        }
        durationButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        countStack.snp.makeConstraints { make in
            make.top.equalTo(durationStack.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
        }
        countButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        goalStack.snp.makeConstraints { make in
            make.top.equalTo(countStack.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(30)
        }
        goalTextField.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(32)
        }
        imageSelectCollectionView.snp.makeConstraints { make in
            make.top.equalTo(goalStack.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
            let cellWidth = (UIScreen.main.bounds.width - 50)/3
            let height = cellWidth*2 + 5
            make.height.equalTo(height)
        }
        buttonStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(120)
            make.height.equalTo(36)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        dateDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(durationButton.snp.bottom)
            make.leading.equalTo(durationButton.snp.leading)
            make.width.equalTo(durationButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
        countDropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(countButton.snp.bottom)
            make.leading.equalTo(countButton.snp.leading)
            make.width.equalTo(countButton.snp.width)
            make.height.equalTo(100)  // 고정 높이
        }
        
        imageSelectCollectionView.addImageHandler = { [weak self] in
            self?.presentImagePicker()
        }
        imageSelectCollectionView.deleteImageHandler = { [weak self] index in
            self?.deleteImage(at: index)
        }
    }
    
    
    // MARK: - Image Handling
    private func setImages() {
        imagesToShow.removeAll()
        let dispatchGroup = DispatchGroup()
        for memoImage in existingImages {
            guard let url = URL(string: memoImage.imageUrl) else {
                print("잘못된 URL: \(memoImage.imageUrl)")
                continue
            }
            
            dispatchGroup.enter()
            SDWebImageManager.shared.loadImage(with: url, options: .highPriority, progress: nil) { [weak self] image, _, _, _, _, _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let image = image {
                        self.imagesToShow.append((id: memoImage.id, image: image))
                    } else {
                        let placeholder = UIImage(named: "Placeholder") ?? UIImage()
                        self.imagesToShow.append((id: memoImage.id, image: placeholder))
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.imageSelectCollectionView.updateImages(self.imagesToShow.map { $0.image })
        }
    }
    
    private func deleteImage(at index: Int) {
        let imageInfo = imagesToShow[index]

        if let imageId = imageInfo.id {
            // 기존 이미지 삭제 → ID를 imageToDelete 배열에 추가
            imageToDelete.append(imageId)
        } else {
            //  새로 추가한 이미지 삭제 → imageToSave 배열에서 제거
            if let indexInSave = imageToSave.firstIndex(of: imageInfo.image) {
                imageToSave.remove(at: indexInSave)
            }
        }
        imagesToShow.remove(at: index)
        imageSelectCollectionView.updateImages(imagesToShow.map { $0.image })
    }
    
    private func presentImagePicker() {
        let maxImageCount = 5
        let remainingCount = maxImageCount - imagesToShow.count
        guard remainingCount > 0 else {
            Toaster.shared.makeToast("최대 5장의 이미지만 선택할 수 있습니다.")
            return
        }
        var config = PHPickerConfiguration()
        config.selectionLimit = remainingCount
        config.filter = .images  // 이미지만 선택
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: - Setup Actions
    @objc private func dateBtnClicked() {
        let isHidden = dateDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.dateDropDownTableView.isHidden = !isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func countBtnClicked() {
        let isHidden = countDropDownTableView.isHidden

        UIView.animate(withDuration: 0.3) {
            self.countDropDownTableView.isHidden = !isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func deleteBtnClicked() {
        guard let planId = planId else { return }
        deleteHealthGoalData(planId: planId)
    }
    
    @objc private func saveBtnClicked() {
        guard let planId = planId else { return }
        
        if let message = validateInputs() {
            Toaster.shared.makeToast(message)
            return
        }
        let healthgoal = createHealthGoalRequest()
        updateHealthGoalAndDismiss(planId: planId, goal: healthgoal)
    }
    
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dropDownDidSelect(item: String, from tag: Int) {
        switch tag {
        case 0:
            self.duration = item  //  날짜 선택
            durationButton.label.text = item
        case 1:
            self.count = item.extractNumber  //  횟수 선택
            countButton.label.text = item
        default:
            break
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
    
    
   
    private func validateInputs() -> String? {
        if goalTextField.text?.isEmpty ?? true {
            return "목표를 작성해주세요."
        }
        if duration == nil || HealthPlanDuration.fromKorean(duration!) == nil {
            return "기간을 입력해주세요."
        }
        if count == nil {
            return "횟수를 입력해주세요."
        }
        return nil
    }
    
    private func createHealthGoalRequest() -> ChangeHealthGoalRequest {
        let newImageData = imageToSave.compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        return ChangeHealthGoalRequest(
            updateRequest: HealthGoalRequest(
                duration: HealthPlanDuration.fromKorean(duration!)!.rawValue,
                number: count!,
                goal: goalTextField.text!,
                removeImageIds: imageToDelete
            ),
            images: newImageData
        )
    }
    

    


    //MARK: - API call
    private func deleteHealthGoalData(planId: Int) {
        showLoadingIndicator()
        HealthGoalManager.deleteHealthGoal(planId) { [weak self] isSuccess, response in
            guard let self = self else { return }
            if isSuccess {
                self.dismiss(animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.hideLoadingIndicator()
                        self.delegate?.didUpdateHealthGoal()
                    }
                }
            } else {
                Toaster.shared.makeToast("목표 삭제에 실패했습니다.")
            }
        }
    }
    
    private func updateHealthGoalAndDismiss(planId: Int, goal: ChangeHealthGoalRequest) {
        showLoadingIndicator()
        HealthGoalManager.changeHealthGoal(goal, planId: planId) { [weak self] isSuccess, response in
            guard let self = self else { return }
            
            if isSuccess {
                self.dismiss(animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.hideLoadingIndicator()
                        self.delegate?.didUpdateHealthGoal()
                    }
                }
            } else {
                Toaster.shared.makeToast("목표 저장에 실패했습니다.")
            }
        }
    }
    
    
    // MARK: - UI Helper Functions
    private func createLabel(text: String, fontSize: CGFloat = 13, weight: UIFont.Weight = .semibold, textColor: UIColor = .healeatGray5) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.textColor = textColor
            $0.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        return label
    }
    private func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.backgroundColor = backgroundColor
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: action, for: .touchUpInside)
        }
        return button
    }
    private func createStackView(
        _ views: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .center,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 15
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views).then {
            $0.axis = axis
            $0.alignment = alignment
            $0.distribution = distribution
            $0.spacing = spacing
        }
        return stackView
    }
}


extension HGBottomSheetVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            let itemProvider = result.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
                    
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let selectedImage = image as? UIImage else { return }
                    self.imageToSave.append(selectedImage)
                    self.imagesToShow.append((id: nil, image: selectedImage))
                    self.imageSelectCollectionView.updateImages(self.imagesToShow.map { $0.image })
                }
            }
        }
    }
}




protocol HealthGoalUpdateDelegate: AnyObject {
    func didUpdateHealthGoal()
}


