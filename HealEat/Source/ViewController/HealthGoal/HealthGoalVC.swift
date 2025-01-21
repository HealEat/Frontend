// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then

class HealthGoalVC: UIViewController {
    var userName: String?
    
    // MARK: - UI Properties
    private let makeGoalsView = MakeGoalsView()
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(makeGoalsView)
        setUpConstraints()
    }
    

    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        makeGoalsView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(285)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    
    
    //MARK: - Setup Actions
    
    
    
    //MARK: - API call


}
