// Copyright © 2025 HealEat. All rights reserved.

import UIKit

enum QuestionEnum {
    case sick
    case veget
    case diet
    case common
}

enum ViewControllerEnum {
    case selectDisease
    case diseaseTrouble
    
    case vegeterian
    
    case diet
    
    case needDiet
    case needNutrient
    case needToAvoid
    
    var viewController: UIViewController {
        switch self {
        case .selectDisease:
            return SelectDiseaseVC()
        case .diseaseTrouble:
            return DiseaseTroubleVC()
        case .vegeterian:
            return VegetarianVC()
        case .diet:
            return DietVC()
        case .needDiet:
            return NeedDietVC()
        case .needNutrient:
            return NeedNutrientVC()
        case .needToAvoid:
            return NeedToAvoidVC()
        }
    }
}

class QuestionBaseVC: UIViewController {
    
    var viewControllers: [QuestionEnum: [ViewControllerEnum]] = [
        .sick: [],
        .veget: [],
        .diet: [],
        .common: [.needNutrient, .needToAvoid]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViewController()
    }
    
    func setupContainerViewController() {
        
        if getViewControllerArray().isEmpty {
            let finalStepVC = FinalStepVC()
            finalStepVC.modalPresentationStyle = .fullScreen
            present(finalStepVC, animated: true, completion: nil)
        }
        
        guard let containerViewController = getViewControllerArray().first?.viewController else { return }
        
        addChild(containerViewController)
        containerViewController.view.frame = view.bounds
        view.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
    }
    
    func getViewControllerArray() -> [ViewControllerEnum] {
        var result: [ViewControllerEnum] = []
        if let sick = viewControllers[.sick] {
            result.append(contentsOf: sick)
        }
        if let veget = viewControllers[.veget] {
            result.append(contentsOf: veget)
        }
        if let diet = viewControllers[.diet] {
            result.append(contentsOf: diet)
        }
        if let common = viewControllers[.common] {
            result.append(contentsOf: common)
        }
        return result
    }
}
