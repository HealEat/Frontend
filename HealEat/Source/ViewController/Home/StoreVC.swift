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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
//        let marketVC = MarketVC()
//        marketVC.param = MarketVC.Param(storeResponseModel: StoreResponseModel(
//            placeId: 99,
//            placeName: "본죽&비빔밥cafe 홍대점 (테스트)",
//            categoryName: "죽",
//            phone: "010-1234-5678",
//            addressName: "서울 마포구 홍익로 10 106호",
//            roadAddressName: "서울 마포구 홍익로 10 106호",
//            x: "37.553851",
//            y: "126.923388",
//            placeUrl: URL(string: "https://place.map.kakao.com/287510690")!,
//            features: ["속 편한 음식", "야채", "죽", "따뜻한 음식"],
//            imageUrls: [
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
//                URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
//            ],
//            isInDB: true,
//            totalScore: 4.4,
//            reviewCount: 23,
//            sickScore: 4.7,
//            sickCount: 15,
//            vegetScore: 3.4,
//            vegetCount: 13,
//            dietScore: 4.3,
//            dietCount: 5,
//            isBookMarked: false
//        ))
//        navigationController?.pushViewController(marketVC, animated: true)
    }
}
