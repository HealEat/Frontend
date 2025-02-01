import UIKit

class PurposeVC: UIViewController {
    private let purposeView = PurposeView()
    private var selectedPurposes: [String] = []
    private var hasDisplayedCommonQuestions = false

    override func loadView() {
        self.view = purposeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        purposeView.diseaseManagementButton.addTarget(self, action: #selector(diseaseManagementTapped), for: .touchUpInside)
        purposeView.vegetarianButton.addTarget(self, action: #selector(vegetarianTapped), for: .touchUpInside)
        purposeView.dietButton.addTarget(self, action: #selector(dietTapped), for: .touchUpInside)
        purposeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func diseaseManagementTapped() {
        toggleButtonState(button: purposeView.diseaseManagementButton, title: "질병 관리")
    }

    @objc private func vegetarianTapped() {
        toggleButtonState(button: purposeView.vegetarianButton, title: "베지테리언")
    }

    @objc private func dietTapped() {
        toggleButtonState(button: purposeView.dietButton, title: "다이어트")
    }

    private func toggleButtonState(button: UIButton, title: String) {
        if selectedPurposes.contains(title) {
            selectedPurposes.removeAll { $0 == title }
            button.backgroundColor = UIColor(hex: "#E8F5E9")
        } else {
            selectedPurposes.append(title)
            button.backgroundColor = UIColor(hex: "#A5D6A7")
        }
    }

    @objc private func nextButtonTapped() {
        guard !selectedPurposes.isEmpty else { return }
        navigateToNextPurpose()
    }

    private func navigateToNextPurpose() {
        if selectedPurposes.isEmpty {
            // 🚀 **모든 목적이 끝나야만 Need 시리즈 실행**
            if !hasDisplayedCommonQuestions {
                hasDisplayedCommonQuestions = true
                navigateToCommonQuestions()
            }
            return
        }

        let nextPurpose = selectedPurposes.removeFirst()

        switch nextPurpose {
        case "질병 관리":
            let diseaseVC = DiseaseManagementVC()
            diseaseVC.delegate = self
            present(diseaseVC, animated: true, completion: nil)
        case "베지테리언":
            let vegetarianVC = VegetarianVC()
            vegetarianVC.delegate = self
            present(vegetarianVC, animated: true, completion: nil)
        case "다이어트":
            let dietVC = DietVC()
            dietVC.delegate = self
            present(dietVC, animated: true, completion: nil)
        default:
            break
        }
    }

    private func navigateToCommonQuestions() {
        let needDietVC = NeedDietVC()
        needDietVC.delegate = self
        needDietVC.modalPresentationStyle = .fullScreen
        present(needDietVC, animated: true, completion: nil)
    }
}

extension PurposeVC: PurposeCompletionDelegate {
    func didCompletePurpose() {
        // 🚀 **목적이 남아있으면 계속 실행, 비어야만 Need 시리즈 실행**
        if selectedPurposes.isEmpty {
            if !hasDisplayedCommonQuestions {
                hasDisplayedCommonQuestions = true
                navigateToCommonQuestions()
            }
        } else {
            navigateToNextPurpose()
        }
    }
}
