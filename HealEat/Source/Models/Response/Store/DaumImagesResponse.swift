// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct DaumImageResponseEntity: Codable {
    let image_url: String?
    let width: String?
    let height: String?
    let display_sitename: String?
    let doc_url: String?
}

struct DaumImageResponseModel: Codable {
    let image_url: URL?
    let width: Int
    let height: Int
    let display_sitename: String
    let doc_url: URL?
    
    init(daumImageResponseEntity: DaumImageResponseEntity) {
        self.image_url = URL(string: daumImageResponseEntity.image_url ?? "")
        self.width = Int(daumImageResponseEntity.width ?? "") ?? 0
        self.height = Int(daumImageResponseEntity.height ?? "") ?? 0
        self.display_sitename = daumImageResponseEntity.display_sitename ?? ""
        self.doc_url = URL(string: daumImageResponseEntity.doc_url ?? "")
    }
}
