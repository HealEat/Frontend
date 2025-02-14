// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager() // ✅ 싱글톤 인스턴스

    private let locationManager = CLLocationManager()
    var currentLatitude: Double = 37.550874837441
    var currentLongitude: Double = 126.925554591431
    var currentHeading: Double = 0.0
    
    // ✅ MapsVC에서 사용할 콜백 추가 (위치 업데이트 알림)
    var onLocationUpdate: ((Double, Double) -> Void)?
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var onLocationError: ((Error) -> Void)?
    var onHeadingUpdate: ((Double) -> Void)?

    private override init() { // ✅ private init()으로 외부에서 새 인스턴스 생성 방지
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization() {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if authStatus == .denied {
            print("❌ GPS 권한 거부됨. 설정에서 직접 변경해야 함.")
            // 권한 거부된 경우 사용자가 직접 설정을 변경하도록 안내 가능
        }
    }


    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
    }
    
    // ✅ 방향 업데이트 처리
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading.trueHeading * Double.pi / 180.0
        // ✅ MapsVC에서 사용할 콜백 호출
        onHeadingUpdate?(currentHeading)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("❌ 현재 위치를 가져올 수 없습니다.")
            return
        }

        let newLat = location.coordinate.latitude
        let newLon = location.coordinate.longitude

        // 동일한 위치라면 업데이트 안 함
        if newLat == currentLatitude && newLon == currentLongitude { return }

        // 업데이트된 위치 저장
        currentLatitude = newLat
        currentLongitude = newLon
        //print("📍 위치 업데이트: \(currentLatitude), \(currentLongitude)")

        // ✅ MapsVC에서 사용할 콜백 호출
        
        DispatchQueue.main.async {
            self.onLocationUpdate?(newLat, newLon)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            requestAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            //requestAuthorization() // 유저가 거부한 거라 앱에서 다시 요청 불가능
        default:
            print("GPS: Default")
        }
        
        // ✅ MapsVC에서 사용할 콜백 호출
        onAuthorizationChange?(status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
            
        onLocationError?(error)
    }

    
}
