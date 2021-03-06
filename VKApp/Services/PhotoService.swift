//
//  PhotoService.swift
//  VKApp
//
//  Created by Владислав Лихачев on 05.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Alamofire

class PhotoService {
    
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    private var images = [String: UIImage]()
    
    private let container: DataReloadable
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }
        
        let url = cashesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    init(container: UITableView) {
        self.container = Table(tableView: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collectionView: container)
    }
    
    /// Получение пути к файлу из url
    /// - Parameter url
    /// - Returns: строка с адресом к файлу
    private func getFilePath(url: String) -> String? {
        guard let cashesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let hashName = url.split(separator: "/").last ?? "default"
        
        return cashesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    /// Сохранение изображения по указанному пути в файловую систему
    /// - Parameters:
    ///   - url: путь
    ///   - image: изображение
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileLocalyPath = getFilePath(url: url),
            let data = image.pngData()
            else {
                return
        }
        
        FileManager.default.createFile(atPath: fileLocalyPath, contents: data, attributes: nil)
    }
    
    /// Получение изображения из файловой системы
    /// - Parameter url
    /// - Returns: изображение
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileLocalyPath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileLocalyPath),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else {
                return nil
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileLocalyPath)
            else {
                return nil
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.images[url] = image
        }
        
        return image
    }
    
    /// Загрузка фото из сети с обновлением строки
    /// - Parameters:
    ///   - indexPath: номер строки для загрузки и обновления
    ///   - url: адрес для загрузки изображения
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        AF.request(url).responseData(
            queue: DispatchQueue.global(),
            completionHandler: { [weak self] response in
                guard let data = response.data,
                    let image = UIImage(data: data)
                    else  {
                        return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.images[url] = image
                }
                
                self?.saveImageToCache(url: url, image: image)
                
                DispatchQueue.main.async { [weak self] in
                    self?.container.reloadRow(atIndexPath: indexPath)
                }
            }
        )
    }
    
    /// получение фото из кэша или из сети
    /// - Parameters:
    ///   - indexPath: строка для обновления
    ///   - url: адрес изображения
    /// - Returns: изображение
    func getPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        return image
    }
    
}

fileprivate protocol DataReloadable {
    
    func reloadRow(atIndexPath indexPath: IndexPath)
    
}

extension PhotoService {
    
    private class Table: DataReloadable {
        
        let tableView: UITableView
        
        init(tableView: UITableView) {
            self.tableView = tableView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        
        let collectionView: UICollectionView
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
}

