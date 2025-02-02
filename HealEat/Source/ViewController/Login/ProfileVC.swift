// Copyright © 2025 HealEat. All rights reserved.

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
    }

    // MARK: - Setup Actions
    private func setupActions() {
        profileView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileView.profileImageView.addGestureRecognizer(tapGesture)

        let addButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(addProfileImageTapped))
        profileView.addButton.addGestureRecognizer(addButtonTapGesture)
    }

    // MARK: - Action Handlers
    @objc private func nextButtonTapped() {
        print("다음 버튼 눌림")
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
