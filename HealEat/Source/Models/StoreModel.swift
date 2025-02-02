// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct StoreModel
{
    let storename : String
    let storeaddress : String
}

final class dummyStoreModel {
    static let storeDatas: [StoreModel] = [
        StoreModel(storename: "본죽", storeaddress: "서울시 마포구 상수동 77번지"),
        StoreModel(storename: "본죽", storeaddress: "서울시 마포구 상수동 77번지"),
        StoreModel(storename: "본죽", storeaddress: "서울시 마포구 상수동 77번지"),
    ]
}
