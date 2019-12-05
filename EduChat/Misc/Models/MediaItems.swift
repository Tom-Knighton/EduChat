//
//  ImageMediaItem.swift
//  EduChat
//
//  Created by Tom Knighton on 26/11/2019.
//  Copyright © 2019 Tom Knighton. All rights reserved.
//

import Foundation
import MessageKit
import SDWebImage

public struct ImageMediaItem : MediaItem {
    public var url: URL?
    
    public var image: UIImage?
    
    public var placeholderImage: UIImage
    
    public var size: CGSize
    
    public init(imageURL: String) {
        self.url = URL(string: imageURL)
        self.placeholderImage = UIImage(named: "image-lg") ?? UIImage()
        self.image = UIImage(named: "image-lg") ?? UIImage()
        self.size = CGSize(width: 240, height: 240)

        
        self.image = UIImage()
    }
    
    public init(image: UIImage, imageURL: String) {
        self.url = URL(string: imageURL)
        self.placeholderImage = UIImage()
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        
    }
}
