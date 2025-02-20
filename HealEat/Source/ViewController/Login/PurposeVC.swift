// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class PurposeVC: UIViewController {
    private let purposeView = PurposeView()
    private var selectedPurposes: Set<String> = [] // ✅ Set 사용하여 중복 제거
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
            selectedPurposes.remove(title)
            button.backgroundColor = UIColor(hex: "#E8F5E9")
        } else {
            selectedPurposes.insert(title)
            button.backgroundColor = UIColor(hex: "#A5D6A7")
        }
    }

    @objc private func nextButtonTapped() {
        guard !selectedPurposes.isEmpty else { return }
        let hasDiseaseManagement = selectedPurposes.contains("질병 관리")
        let hasDiet = selectedPurposes.contains("다이어트")
        let hasVegetarian = selectedPurposes.contains("베지테리언")
        
        let questionBaseVC = QuestionBaseVC()
        if hasDiseaseManagement {
            questionBaseVC.viewControllers[.sick]?.append(.selectDisease)
            questionBaseVC.viewControllers[.sick]?.append(.diseaseTrouble)
            if !questionBaseVC.viewControllers[.common]!.contains(.needDiet) {
                questionBaseVC.viewControllers[.common]?.insert(.needDiet, at: 0)
            }
        }
        if hasDiet {
            questionBaseVC.viewControllers[.diet]?.append(.diet)
        }
        if hasVegetarian {
            questionBaseVC.viewControllers[.veget]?.append(.vegeterian)
        }
        present(questionBaseVC, animated: true)
    }

//    private func navigateToNextPurpose() {
//        let hasDiseaseManagement = selectedPurposes.contains("질병 관리")
//        let hasDiet = selectedPurposes.contains("다이어트")
//        let hasVegetarian = selectedPurposes.contains("베지테리언")
//
//        // ✅ 베지테리언 선택 시 유형 먼저 설정
//        if hasVegetarian {
//            let vegetarianVC = VegetarianVC()
//            vegetarianVC.delegate = self
//            present(vegetarianVC, animated: true, completion: nil)
//            return
//        }
//
//        let vegetarianType = UserDefaults.standard.string(forKey: "vegetarianType") ?? ""
//        let dietPurpose = UserDefaults.standard.string(forKey: "dietPurpose") ?? ""
//
//        // ✅ Need 시리즈를 실행해야 하는 조건
//        let shouldShowNeedSeries =
//            hasDiseaseManagement ||
//            (hasDiet && vegetarianType == "플렉시테리언") ||
//            (hasDiet && vegetarianType != "플렉시테리언" && dietPurpose != "체중 감량")
//
//        // ✅ 플렉시테리언 제외한 베지테리언 단독 선택 → FinalStep 바로 이동
//        if hasVegetarian && !hasDiet && !hasDiseaseManagement && vegetarianType != "플렉시테리언" {
//            let finalStepVC = FinalStepVC()
//            finalStepVC.modalPresentationStyle = .fullScreen
//            present(finalStepVC, animated: true, completion: nil)
//            return
//        }
//
//        // ✅ 남은 목적이 없으면 Need 시리즈 실행
//        if selectedPurposes.isEmpty {
//            if shouldShowNeedSeries && !hasDisplayedCommonQuestions {
//                hasDisplayedCommonQuestions = true
//                navigateToCommonQuestions()
//            }
//            return
//        }
//
//        // ✅ 다음 목적 실행
//        let nextPurpose = selectedPurposes.first!
//        selectedPurposes.remove(nextPurpose)
//
//        switch nextPurpose {
//        case "질병 관리":
//            let diseaseVC = DiseaseManagementVC()
//            diseaseVC.delegate = self
//            present(diseaseVC, animated: true, completion: nil)
//        case "다이어트":
//            let dietVC = DietVC()
//            dietVC.delegate = self
//            present(dietVC, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
}
