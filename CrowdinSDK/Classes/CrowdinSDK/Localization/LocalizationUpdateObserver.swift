//
//  LocalizationUpdateObserver.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 4/22/19.
//

import Foundation

typealias LocalizationUpdateDownload = () -> Void
typealias LocalizationUpdateError = ([Error]) -> Void

protocol LocalizationUpdateObserverProtocol {
    var downloadHandlers: [Int: LocalizationUpdateDownload] { get }
    var errorHandlers: [Int: LocalizationUpdateError] { get }
    
    func subscribe()
    func unsubscribe()
}

class LocalizationUpdateObserver {
    var downloadHandlers: [Int: LocalizationUpdateDownload] = [:]
    var errorHandlers: [Int: LocalizationUpdateError] = [:]
    
    init() {
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDownloadLocalization), name: Notification.Name(Notifications.ProviderDidDownloadLocalization.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadError(with:)), name: Notification.Name(Notifications.ProviderDownloadError.rawValue), object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addDownloadHandler(_ handler: @escaping LocalizationUpdateDownload) -> Int {
        let newKey = (downloadHandlers.keys.max() ?? 0) + 1
        downloadHandlers[newKey] = handler
        return newKey
    }
    
    func removeDownloadHandler(_ id: Int) {
        downloadHandlers.removeValue(forKey: id)
    }
    
    func removeAllDownloadHandlers() {
        downloadHandlers.removeAll()
    }
    
    func addErrorHandler(_ handler: @escaping LocalizationUpdateError) -> Int {
        let newKey = (errorHandlers.keys.max() ?? 0) + 1
        errorHandlers[newKey] = handler
        return newKey
    }
    
    func removeErrorHandler(_ id: Int) {
        errorHandlers.removeValue(forKey: id)
    }
    
    func removeAllErrorHandlers() {
        errorHandlers.removeAll()
    }
    
    @objc func didDownloadLocalization() {
        downloadHandlers.forEach({ $1() })
    }
    
    @objc func downloadError(with notification: Notification) {
        guard let errors = notification.object as? [Error] else { return }
        errorHandlers.forEach({ $1(errors) })
    }
}
