// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SDWebImage

class MyPageVC: UIViewController {

    var selectedImage: UIImage? {
        didSet {
            profileImageView.image = selectedImage
        }
    }
    let menu = ["나의 건강 정보", "저장 목록", "내가 남긴 후기"]
    
    // MARK: - UI Properties
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
        //$0.layer.borderWidth = 5
        $0.layer.cornerRadius = 42
        $0.clipsToBounds = true
    }
    private lazy var profileLabel = UILabel().then {
        $0.text = "이용자"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    private lazy var profileEditButton = UIButton().then {
        $0.setTitle("프로필 수정하기", for: .normal)
        $0.setTitleColor(UIColor(hex: "#5A5A5A"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(hex: "#5A5A5A")?.cgColor //gray6으로 변경
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
    }
    private lazy var profileStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 20
        $0.distribution = .fill
    }
    private lazy var profileDetailStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 15
        $0.distribution = .fill
    }
    private lazy var tableview = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
    }
    private lazy var separator = UIView().then {
        $0.backgroundColor = .healeatGray4
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

        navigationItem.backButtonTitle = "마이페이지"
        navigationController?.navigationBar.tintColor = .black // 원하는 색상으로 변경
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchProfile {
            // 🔥 API 응답이 완료된 후 실행
            self.view.layoutIfNeeded()
            print("\(self.selectedImage)")
        }
    }
    
    // MARK: - UI Methods
    private func setUp() {
        [profileLabel, profileEditButton].forEach(profileDetailStack.addArrangedSubview(_:))
        [profileImageView, profileDetailStack].forEach(profileStack.addArrangedSubview(_:))
        [profileStack, separator ,tableview].forEach {
            view.addSubview($0)
        }
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // ✅ 기본 셀 등록
        
        profileEditButton.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        
        profileStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.4)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(85)
        }
        profileEditButton.snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(24)
        }
        tableview.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.bottom.equalTo(tableview.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Setup Actions
    @objc private func editBtnClicked() {
        let editVC = ProfileEditVC()
        editVC.onImageSelected = { [weak self] image in
            self?.selectedImage = image
            print("✅ 클로저를 통해 받은 이미지: \(image)")
        }
        navigationController?.pushViewController(editVC, animated: true)
    }

    //MARK: - API call
    private func fetchProfile(completion: (() -> Void)? = nil) {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let profile):
                print(profile)
                guard let data = profile.result else { return }
                DispatchQueue.main.async {
                    self.profileLabel.text = "\(data.name)"
                    completion?()
                }
                
                let profileImgURL = URL(string: data.profileImage)
                //self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profile"))
            case .failure(let error):
                print("프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    

}


extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = .black
        cell.accessoryView = image
        
        let separator = UIView()
        separator.backgroundColor = .healeatGray4
        separator.frame = CGRect(x: 0, y: cell.bounds.height - 1, width: cell.bounds.width, height: 1) // 원하는 두께 설정
        cell.addSubview(separator)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    
    
}
