// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct DiseaseResponseEntity: Codable {
    struct Disease: Codable {
        let id: Int?
        let name: String?
    }
    let memberId: Int?
    let diseases: [Disease]?
}

struct DiseaseResponseModel: Codable {
    struct Disease: Codable {
        let id: Int
        let name: String
        
        init(disease: DiseaseResponseEntity.Disease) {
            self.id = disease.id ?? 0
            self.name = disease.name ?? ""
        }
    }
    let memberId: Int
    let diseases: [Disease]
    
    init(diseaseResponseEntity: DiseaseResponseEntity) {
        self.memberId = diseaseResponseEntity.memberId ?? 0
        self.diseases = diseaseResponseEntity.diseases?.compactMap(Disease.init) ?? []
    }
}
