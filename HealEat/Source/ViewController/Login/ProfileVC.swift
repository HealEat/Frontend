






import UIKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    private let profileView = ProfileView()
    private var selectedImageData: Data?

    // MARK: - Lifecycle
    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupTextFieldObserver() // 닉네임 입력 감지
    }

    // MARK: - Setup Actions
    private func setupActions() {
        profileView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileView.profileImageView.addGestureRecognizer(tapGesture)

        let addButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(addProfileImageTapped))
        profileView.addButton.addGestureRecognizer(addButtonTapGesture)
    }

    // ✅ 닉네임 입력 감지하여 nextButton 활성화
    private func setupTextFieldObserver() {
        profileView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldChanged), for: .editingChanged)
    }

    @objc private func nicknameTextFieldChanged() {
        let isNicknameEntered = !(profileView.nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        profileView.nextButton.isEnabled = isNicknameEntered
        profileView.nextButton.alpha = isNicknameEntered ? 1.0 : 0.5
    }

    // MARK: - Action Handlers
    @objc private func nextButtonTapped() {
        guard let nickname = profileView.nicknameTextField.text, !nickname.isEmpty else {
            profileView.errorLabel.text = "닉네임을 입력해주세요."
            profileView.errorLabel.isHidden = false
            profileView.nicknameTextField.layer.borderColor = UIColor.red.cgColor
            return
        }

        profileView.errorLabel.isHidden = true
        profileView.nicknameTextField.layer.borderColor = UIColor.lightGray.cgColor

        // ✅ API 요청 실행 (닉네임 & 이미지 전송)
        ProfileService.shared.createProfile(name: nickname, image: selectedImageData) { result in
            switch result {
            case .success:
                print("✅ 프로필 생성 성공!")
                let purposeVC = PurposeVC()
                purposeVC.modalPresentationStyle = .fullScreen
                self.present(purposeVC, animated: true, completion: nil)
            case .failure(let error):
                print("❌ 프로필 생성 실패: \(error.localizedDescription)")
            }
        }
    }

    @objc private func profileImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    @objc private func addProfileImageTapped() {
        profileImageTapped()
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let resizedImage = cropToCircle(image: selectedImage, size: profileView.profileImageView.bounds.size)
            profileView.profileImageView.image = resizedImage

            // ✅ 이미지 선택 시 `Data` 변환 후 저장
            selectedImageData = selectedImage.jpegData(compressionQuality: 0.8)

            // ✅ 이미지 선택하면 addButton 숨기기
            profileView.addButton.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Helper Functions
    private func cropToCircle(image: UIImage, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        UIBezierPath(ovalIn: rect).addClip()
        image.draw(in: rect)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}
