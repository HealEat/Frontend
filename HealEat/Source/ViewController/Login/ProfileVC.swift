import UIKit

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    private let profileView = ProfileView()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupTextFieldObserver() // ✅ 닉네임 입력 감지 추가
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
            DispatchQueue.main.async {
                self.profileView.errorLabel.text = "닉네임을 입력해주세요."
                self.profileView.errorLabel.isHidden = false
                self.profileView.nicknameTextField.layer.borderColor = UIColor.red.cgColor // ✅ 테두리 빨간색 변경
            }
            return
        }

        DispatchQueue.main.async {
            self.profileView.errorLabel.isHidden = true
            self.profileView.nicknameTextField.layer.borderColor = UIColor.lightGray.cgColor // ✅ 정상 상태로 변경
        }

        let purposeVC = PurposeVC()
        purposeVC.modalPresentationStyle = .fullScreen
        purposeVC.modalTransitionStyle = .crossDissolve
        present(purposeVC, animated: true, completion: nil)
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
