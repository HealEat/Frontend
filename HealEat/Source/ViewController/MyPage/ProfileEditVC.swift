// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster

class ProfileEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var newImage: UIImage?
    
    // MARK: - UI Properties
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    private lazy var textfield = UITextField().then {
        $0.backgroundColor = .healeatGray2
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
        $0.layer.borderWidth = 1.5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        
        let text = "닉네임 입력하기"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: UIColor.healeatGray5, .font: UIFont.systemFont(ofSize: 16, weight: .light)])
        $0.attributedPlaceholder = attributedString
        $0.addLeftPadding()
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .left
    }
    private lazy var editButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }
    private lazy var profileStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
        $0.distribution = .fill
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        configureTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProfile()
    }
    
    // MARK: - UI Methods
    private func setUp() {
        view.backgroundColor = .white
        [imageView, textfield].forEach(profileStack.addArrangedSubview(_:))
        [profileStack, editButton].forEach {
            view.addSubview($0)
        }
        
        profileStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8) //1.0이 중앙
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        textfield.snp.makeConstraints { make in
            make.width.equalTo(260)
            make.height.equalTo(40)
        }
        editButton.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(36)
            make.trailing.equalTo(textfield.snp.trailing).offset(5)
            make.top.equalTo(textfield.snp.bottom).offset(20)
        }
        
        editButton.addTarget(self, action: #selector(postProfile), for: .touchUpInside)

    }
    
    //MARK: - Setup Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureTapGesture() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        imageView.addGestureRecognizer(imageTap)
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        viewTap.cancelsTouchesInView = false
        view.addGestureRecognizer(viewTap)
    }
    
    // 프로필 이미지 선택
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            newImage = selectedImage
        } else {
            print("⚠️ 이미지 선택 실패")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func postProfile() {
        guard let nickname = textfield.text else {
            Toaster.shared.makeToast("닉네임을 입력해주세요.")
            return
        }
        let selectedImageData: Data? = newImage?.jpegData(compressionQuality: 0.8)

        changeProfile(name: nickname, image: selectedImageData) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - API call
    private func fetchProfile() {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let profile):
                print(profile)
                guard let data = profile.result else { return }
                let profileImgURL = URL(string: data.profileImage)
                self.imageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profile"))
            case .failure(let error):
                print("프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func changeProfile(name: String, image: Data?, completion: (() -> Void)? = nil) {
        MyPageManager.changeProfile(name: name, image: image) { isSuccess, response in
            if isSuccess {
                print("프로필 수정 성공: \(response)")
                completion?()
            } else {
                if let data = response?.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    
                }
            }
        }
    }

}


