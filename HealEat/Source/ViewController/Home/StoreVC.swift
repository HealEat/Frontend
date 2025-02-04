// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

protocol StoreVCDelegate: AnyObject {
    func didTapHealthSetting()
}

class StoreVC: UIViewController {
    weak var delegate: StoreVCDelegate?
    private var storeData: [dummyModel] = dummyModel.storedummy()
    public let storeview = StoreView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = storeview
        setupCollectionView()
        storeview.healthsettingButton.addTarget(self, action: #selector(healthsettingTapped), for: .touchUpInside)
                                                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.reloadCollectionView()
        }
        fetchStoreData()
    }
    
    private func fetchStoreData() {
        APIManager.HomeProvider.request(.getStores(lat: 37.5665, lon: 126.9780)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(HomeResponse.self, from: response.data)
                    self.storeData = decodedData.storeList.map { store in
                        StoreModel(storename: store.place_name, storeaddress: store.address_name)
                    }
                    DispatchQueue.main.async {
                        self.reloadCollectionView()
                    }
                } catch {
                    print("JSON 디코딩 오류:", error)
                }
            case .failure(let error):
                print("API 요청 실패:", error)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reloadCollectionView()
    }

    private func setupCollectionView() {
        storeview.storeCollectionView.dataSource = self
        storeview.storeCollectionView.delegate = self
        storeview.storeCollectionView.bounces = false
        storeview.storeCollectionView.contentInsetAdjustmentBehavior = .never
        storeview.storeCollectionView.reloadData()
    }

    public func reloadCollectionView() {
        storeview.storeCollectionView.reloadData()
        storeview.updateCollectionViewHeight()
    }
                                                
    @objc private func healthsettingTapped() {
        delegate?.didTapHealthSetting() //HomeVC에 버튼 클릭 이벤트 전달
    }
}

extension StoreVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("📌 컬렉션 뷰 데이터 개수: \(storeData.count)")
        return storeData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.identifier, for: indexPath) as? StoreCollectionViewCell else {
            return UICollectionViewCell()
        }

        let model = storeData[indexPath.row]
        cell.storeconfigure(model: model)

        return cell
    }
}
