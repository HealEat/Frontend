// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import KakaoMapsSDK
import CoreLocation
import Moya

class MapsVC: UIViewController, MapControllerDelegate {
    
    var la : Double!
    var lo : Double!
    var currentPositionMarker: Poi? // 현재 위치 마커
    var currentDirectionArrow: Poi? // 방향 화살표
    var currentHeading: Double = 0.0 // 현재 방향 (라디안)
    var isTracking: Bool = false // 추적 모드 여부
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool
    var _auth: Bool
    var _appear: Bool
    
    public lazy var searchBar = MapSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.healeatGray5,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        $0.searchBar.attributedPlaceholder = NSAttributedString(string: "검색", attributes: attributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(coder: aDecoder)
    }
    
    init() {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMapView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    private func setupMapView() {
            // KMViewContainer 초기화 및 추가
            let container = KMViewContainer(frame: self.view.bounds)
            container.autoresizingMask = [.flexibleWidth, .flexibleHeight] // 화면 크기 변화에 대응
            self.view.addSubview(container)
            mapContainer = container
            
            guard let mapContainer = mapContainer else {
                fatalError("KMViewContainer is not initialized properly")
            }
            
            // KMController 초기화
            mapController = KMController(viewContainer: mapContainer)
            if mapController == nil {
                fatalError("KMController initialization failed")
            }
            
            mapController?.delegate = self
            setupLocationManager()
            // 지도 추가
            addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    // 인증 성공시 delegate 호출.
    func authenticationSucceeded() {
        // 일반적으로 내부적으로 인증과정 진행하여 성공한 경우 별도의 작업은 필요하지 않으나,
        // 네트워크 실패와 같은 이슈로 인증실패하여 인증을 재시도한 경우, 성공한 후 정지된 엔진을 다시 시작할 수 있다.
        if _auth == false {
            _auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break;
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    func addViews() {
        
        guard let mapController = mapController else {
            print("Error: mapController is nil")
            return
        }

        if !mapController.isEnginePrepared {
            print("Error: Kakao Maps engine is not prepared")
            return
        }
        
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 126.9255545914, latitude: 37.550874837)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 16)
        
        //KakaoMap 추가.
        mapController.addView(mapviewInfo)
        
        createCurrentLocationMarker()
        
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds    //뷰 add 도중에 resize 이벤트가 발생한 경우 이벤트를 받지 못했을 수 있음. 원하는 뷰 사이즈로 재조정.
        viewInit(viewName: viewName)
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
       
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        _observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        _observerAdded = false
    }
    
    func setupLocationManager() {
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.startUpdatingLocation()
        LocationManager.shared.startUpdatingHeading()

        // ✅ 권한 변경 감지
        LocationManager.shared.onAuthorizationChange = { [weak self] status in
            print("onAuthorization change 콜백")
            self?.handleAuthorizationChange(status)
        }

        // ✅ 위치 오류 처리
        LocationManager.shared.onLocationError = { [weak self] error in
            print("onLocationError change 콜백")
            self?.showLocationError(error)
        }


        // ✅ 방향 업데이트 처리
        LocationManager.shared.onHeadingUpdate = { [weak self] heading in
            //print("onHeadingUpdate change 콜백")
            self?.updateHeading(heading)
        }
    }
    
    
    func startTracking() {
        isTracking = true
        LocationManager.shared.startUpdatingLocation()
    }
    
    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let currentPosition = MapPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            mapView.moveCamera(CameraUpdate.make(target: currentPosition, zoomLevel: 16, mapView: mapView))
        }
    }
    
    
    func createCurrentLocationMarker() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        _ = mapView.getLabelManager()

        // 현재 위치 마커
        let markerOptions = PoiOptions(styleID: "positionMarkerStyle", poiID: "currentPosition")
        markerOptions.rank = 1
        _ = MapPoint(longitude: 127.10980993945, latitude: 37.34698042338)

        // 방향 화살표
        let arrowOptions = PoiOptions(styleID: "directionArrowStyle", poiID: "directionArrow")
        arrowOptions.rank = 2

        // 동기화
        currentPositionMarker?.shareTransformWithPoi(currentDirectionArrow!)
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
   
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }

    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                                        toastLabel.alpha = 0.0
                                    },
                       completion: { (finished) in
                                        toastLabel.removeFromSuperview()
                                    })
    }
    
    
    
    
    public func updateMapPosition(lat: Double, lon: Double) {
        print("현재 위치 업데이트됨: \(lat), \(lon)")

        // 지도 중심 이동
        let currentPosition = MapPoint(longitude: lon, latitude: lat)
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            mapView.moveCamera(CameraUpdate.make(target: currentPosition, zoomLevel: 16, mapView: mapView))
        }

        moveCameraToCurrentLocation(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        startTracking()
    }

    private func handleAuthorizationChange(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 승인됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            LocationManager.shared.requestAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            break
        }
    }
    
    private func showLocationError(_ error: Error) {
        print("🚨 위치 오류 발생: \(error.localizedDescription)")
        showToast(self.view, message: "위치 정보를 가져오는데 실패했습니다.")

        // ✅ CLError 타입으로 다운캐스팅하여 상세 오류 처리
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("❌ 위치 서비스가 비활성화되었습니다. 설정에서 활성화해주세요.")
                showToast(self.view, message: "위치 서비스가 꺼져 있습니다. 설정에서 활성화해주세요.")

            case .network:
                print("🌐 네트워크 오류 발생")
                showToast(self.view, message: "네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.")

            case .locationUnknown:
                print("📍 위치 정보를 찾을 수 없습니다.")
                showToast(self.view, message: "위치 정보를 찾을 수 없습니다. 잠시 후 다시 시도해주세요.")

            default:
                print("⚠️ 알 수 없는 오류 발생")
                showToast(self.view, message: "알 수 없는 오류가 발생했습니다.")
            }
        }
    }

    private func updateHeading(_ heading: Double) {
        //print("🧭 방향 업데이트: \(heading)")
        currentDirectionArrow?.rotateAt(heading, duration: 100)
    }
}

