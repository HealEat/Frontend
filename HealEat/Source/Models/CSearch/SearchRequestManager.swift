

























class SearchRequestManager {
    static let shared = SearchRequestManager()
    
    private init() {}

    // ✅ 기본값 설정
    var query: String = ""
    var x: String = "37.550874837441"
    var y: String = "126.925554591431"
    var categoryIdList: [Int] = []
    var featureIdList: [Int] = []
    var minRating: Float = 0.0
    var searchBy: SearchBy = .accuracy
    var sortBy: SortBy = .rating

    // ✅ 현재 값으로 `CSearchRequest` 생성
    var currentRequest: CSearchRequest {
        return CSearchRequest(
            query: query,
            x: x,
            y: y,
            categoryIdList: categoryIdList,
            featureIdList: featureIdList,
            minRating: minRating,
            searchBy: searchBy.rawValue,
            sortBy: sortBy.rawValue
        )
    }

    // ✅ 선택적으로 특정 값만 변경 가능
    func updateFilters(
        query: String? = nil,
        x: String? = nil,
        y: String? = nil,
        categoryIdList: [Int]? = nil,
        featureIdList: [Int]? = nil,
        minRating: Float? = nil,
        searchBy: SearchBy? = nil,
        sortBy: SortBy? = nil
    ) {
        self.query = query ?? self.query
        self.x = x ?? self.x
        self.y = y ?? self.y
        self.categoryIdList = categoryIdList ?? self.categoryIdList
        self.featureIdList = featureIdList ?? self.featureIdList
        self.minRating = minRating ?? self.minRating
        self.searchBy = searchBy ?? self.searchBy
        self.sortBy = sortBy ?? self.sortBy
        
        print("✅ 필터 업데이트 완료:")
        print("- query: \(self.query)")
        print("- x: \(self.x), y: \(self.y)")
        print("- categoryIdList: \(self.categoryIdList)")
        print("- featureIdList: \(self.featureIdList)")
        print("- minRating: \(self.minRating)")
        print("- searchBy: \(self.searchBy.rawValue), sortBy: \(self.sortBy.rawValue)")
    }
}
