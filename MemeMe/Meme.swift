//
//  Meme.swift
//  MemeMe
//
//  Created by Apple on 23/11/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

import Foundation
import UIKit

class Meme {

struct Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
    
    init(topText : String, bottomText : String, originalImage : UIImage, memedImage : UIImage) {
        
    }
   
static let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0]
    
}
