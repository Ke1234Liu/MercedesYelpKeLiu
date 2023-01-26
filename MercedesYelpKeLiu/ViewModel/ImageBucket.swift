//
//  ImageBucket.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import UIKit
import Combine

class ImageBucket {
    
    let publisher = PassthroughSubject<Bool, Never>()
    
    private enum ImageBucketError: Error {
        case invalidDimension
    }
    
    func image(for hashable: AnyHashable) -> UIImage? {
        return imageDict[hashable]
    }
    
    func imageDownloadError(for hashable: AnyHashable) -> Bool {
        return errorSet.contains(hashable)
    }
    
    private var imageDict = [AnyHashable: UIImage]()
    private var downloadTaskDict = [AnyHashable: Task<Void, Never>]()
    private var errorSet = Set<AnyHashable>()
    
    func handleEnter(for hashable: AnyHashable?, withURL url: URL?) {
        
        guard let hashable = hashable else {
            return
        }
        
        guard let url = url else {
            return
        }
        
        // Start downloading the image, only if we need to...
        if errorSet.contains(hashable) { return }
        if downloadTaskDict[hashable] != nil { return }
        if imageDict[hashable] != nil { return }
        
        downloadTaskDict[hashable] = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeRawData)
                }
                guard image.size.width > 0.0 && image.size.height > 0.0 else {
                    throw ImageBucketError.invalidDimension
                }
                
                //if Bool.random() {
                //throw ImageBucketError.invalidDimension
                //}
                
                errorSet.remove(hashable)
                downloadTaskDict.removeValue(forKey: hashable)
                imageDict[hashable] = image
                publisher.send(true)
                
            } catch let error {
                print("thumb download error: \(error.localizedDescription)")
                print("thumb download url: \(url)")
                
                if Task.isCancelled {
                    
                    errorSet.remove(hashable)
                    downloadTaskDict.removeValue(forKey: hashable)
                    publisher.send(false)
                    
                } else {
                    
                    errorSet.insert(hashable)
                    downloadTaskDict.removeValue(forKey: hashable)
                    publisher.send(false)
                    
                }
            }
        }
    }
    
    func handleLeave(for hashable: AnyHashable?) {
        guard let hashable = hashable else {
            return
        }
        downloadTaskDict[hashable]?.cancel()
        downloadTaskDict.removeValue(forKey: hashable)
        errorSet.remove(hashable)
    }
    
    func handleMissing(for hashable: AnyHashable?) {
        guard let hashable = hashable else {
            return
        }
        errorSet.insert(hashable)
        downloadTaskDict[hashable]?.cancel()
        downloadTaskDict.removeValue(forKey: hashable)
        publisher.send(false)
    }
    
    
}
