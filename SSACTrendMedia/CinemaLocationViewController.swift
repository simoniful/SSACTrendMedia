//
//  CinemaLocationViewController.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/10/20.
//

import UIKit
import MapKit

enum FilterStatus: Int {
    case basic, megabax, cgv, lotte, all
}

class CinemaLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var filterStatus: FilterStatus = .basic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterBtnClicked))

        let location = CLLocationCoordinate2D(latitude: 37.56628617342109, longitude: 126.9768530730982)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

//        let annotations = mapView.annotations
//        mapView.removeAnnotations(annotations)
   
    }
    
    func setTitleAddr(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks else {
                fatalError("No Placemarks Provided \(String(describing: error?.localizedDescription))")
            }
            let placemark = placemarks[0]
            let result = "\(placemark.locality!) \(placemark.subLocality!)"
            self.title = result
        })
    }
    
    func changeFilterStauts(_ input:FilterStatus) {
        filterStatus = input
        locationManager.startUpdatingLocation()
    }
    
    func setAnnoation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    @objc func filterBtnClicked() {
        // 1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2. UIAlertAction 생성: 버튼들..
        let megabox = UIAlertAction(title: "메가박스", style: .default, handler: {(action: UIAlertAction!) in self.changeFilterStauts(.megabax)})
        let lotte = UIAlertAction(title: "롯데시네마", style: .default, handler:{(action: UIAlertAction!) in self.changeFilterStauts(.lotte)})
        let cgv = UIAlertAction(title: "CGV", style: .default, handler:{(action: UIAlertAction!) in self.changeFilterStauts(.cgv)})
        let all = UIAlertAction(title: "전체보기", style: .default, handler:{(action: UIAlertAction!) in self.changeFilterStauts(.all)})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        // 3. 1+2
        alert.addAction(megabox)
        alert.addAction(lotte)
        alert.addAction(cgv)
        alert.addAction(all)
        alert.addAction(cancel)
        
        // 4. Present
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goSetting() {
        let alert = UIAlertController(title: "위치 권한 설정이 되어 있지 않습니다.", message: "앱 설정 화면으로 이동하시겠습니까?", preferredStyle: .alert)

        let ok = UIAlertAction(title: "확인", style: .default, handler: {(action: UIAlertAction!) -> Void in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
    
}

extension CinemaLocationViewController: CLLocationManagerDelegate {
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // iOS14 이상에만 사용 가능
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus() // iOS14 미만 사용
        }
        
        // iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            // 권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            // setting을 바꿔 달라는 alert 요청
            print("iOS 위치 서비스를 켜주세요")
            goSetting()
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            // p.list의 허용 항목과 일치
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도를 심도 깊게 잡은 경우 배터리 소모 증가
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() // 위치 접근 시작 - didUpdateLocations 실행
        case .restricted, .denied:
            print("Denied, 설정 유도")
            goSetting()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // 위치 접근 시작 - didUpdateLocations 실행
        case .authorizedAlways:
            print("Always")
        @unknown default:
            print("Default")
        }
        
        // 정확도가 떨어지는 경우 작동이 되지 않는 앱이 있기에
        // 정확도 체크: 정확도가 감소가 되어 있을 경우, 1시간 4번 호출의 제한 및 미리 알림이 동작하지 않은 가능성 O
        // 배터리는 오래 사용 가능, 워치 신버전 부터 정확도 부분 동기화
        if #available(iOS 14.0, *) {
            let accurancyState = locationManager.accuracyAuthorization
            switch accurancyState {
            case .fullAccuracy:
                print("Full")
            case .reducedAccuracy:
                print("Reduce")
            @unknown default:
                print("Default")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        switch filterStatus {
        case .basic:
            if let coordinate = locations.last?.coordinate {
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                setAnnoation(latitude: 37.484765596198585, longitude: 126.9817847215812, title: "메가박스 이수")
                setAnnoation(latitude: 37.50171997265172, longitude: 126.88226688480663, title: "CGV 구로")
                setAnnoation(latitude: 37.51789518768726, longitude: 126.9027910393312, title: "CGV 영등포")
                setAnnoation(latitude: 37.48401458378906, longitude: 126.93015742690906, title: "롯데시네마 신림")
                setAnnoation(latitude: 37.48258529155677, longitude: 126.95197377006207, title: "롯데시네마 서울대입구")
                setAnnoation(latitude: 37.479588394090634, longitude: 126.89034733620078, title: "롯데시네마 가산디지털")
                mapView.setRegion(region, animated: true)
                setTitleAddr(location: locations.last!)
                locationManager.stopUpdatingLocation()
            } else {
                print("Location Cannot Find")
            }
        case .megabax:
            mapView.removeAnnotations(mapView.annotations)
            setAnnoation(latitude: 37.484765596198585, longitude: 126.9817847215812, title: "메가박스 이수")
            locationManager.stopUpdatingLocation()
            
        case .cgv:
            mapView.removeAnnotations(mapView.annotations)
            setAnnoation(latitude: 37.50171997265172, longitude: 126.88226688480663, title: "CGV 구로")
            setAnnoation(latitude: 37.51789518768726, longitude: 126.9027910393312, title: "CGV 영등포")
            mapView.showAnnotations(self.mapView.annotations, animated: true)
            locationManager.stopUpdatingLocation()
        
        case .lotte:
            mapView.removeAnnotations(mapView.annotations)
            setAnnoation(latitude: 37.48401458378906, longitude: 126.93015742690906, title: "롯데시네마 신림")
            setAnnoation(latitude: 37.48258529155677, longitude: 126.95197377006207, title: "롯데시네마 서울대입구")
            setAnnoation(latitude: 37.479588394090634, longitude: 126.89034733620078, title: "롯데시네마 가산디지털")
            mapView.showAnnotations(self.mapView.annotations, animated: true)
            locationManager.stopUpdatingLocation()
        
        case .all:
            mapView.removeAnnotations(mapView.annotations)
            setAnnoation(latitude: 37.484765596198585, longitude: 126.9817847215812, title: "메가박스 이수")
            setAnnoation(latitude: 37.50171997265172, longitude: 126.88226688480663, title: "CGV 구로")
            setAnnoation(latitude: 37.51789518768726, longitude: 126.9027910393312, title: "CGV 영등포")
            setAnnoation(latitude: 37.48401458378906, longitude: 126.93015742690906, title: "롯데시네마 신림")
            setAnnoation(latitude: 37.48258529155677, longitude: 126.95197377006207, title: "롯데시네마 서울대입구")
            setAnnoation(latitude: 37.479588394090634, longitude: 126.89034733620078, title: "롯데시네마 가산디지털")
            mapView.showAnnotations(self.mapView.annotations, animated: true)
            setTitleAddr(location: locations.last!)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
}

extension CinemaLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("여기있어요!")
    }
}

