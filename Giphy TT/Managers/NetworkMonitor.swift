//
//  NetworkMonitor.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 23/12/2023.
//

import Foundation
import Network
import UIKit
import RxSwift
import RxCocoa

protocol NetworkMonitorDelegate: AnyObject {
    func presentInternetConnectionFailure(isConnected: Bool)
}

//final class NetworkMonitor {
//    static let shared = NetworkMonitor()
//    weak var delegate: NetworkMonitorDelegate?
//
//    private let queue = DispatchQueue.global()
//    private let monitor: NWPathMonitor
//
//    public private(set) var isConnected: Bool = false {
//        didSet {
//            didChangeHandler?(isConnected)
//        }
//    }
//
//    var didChangeHandler: ((Bool) -> Void)?
//
//    private init() {
//        monitor = NWPathMonitor()
//    }
//
//    public func startMonitoring() {
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            self?.isConnected = path.status != .unsatisfied
//            self?.didChangeHandler?(self?.isConnected ?? false)
//            self?.delegate = self
//            if !self!.isConnected {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    self!.delegate?.presentInternetConnectionFailure(isConnected: self!.isConnected)
//                }
//            }
//        }
//    }
//
//    public func stopMinotoring() {
//        monitor.cancel()
//    }
//}
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    weak var delegate: NetworkMonitorDelegate?
    
    private let disposeBag = DisposeBag()
    private let monitor = NWPathMonitor()
    public let isConnectedRelay = BehaviorRelay<Bool>(value: false)
    
    var isConnected: Bool {
        return isConnectedRelay.value
    }
    
    private init() {}
    
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedRelay.accept(path.status != .unsatisfied)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
