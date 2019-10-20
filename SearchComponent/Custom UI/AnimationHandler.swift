//
//  AnimationHandler.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 19.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import Lottie

class AnimationHandler {
    
    static func startLottieAnimation(aniView: AnimationView) {
        aniView.animation = Animation.named(Constants.ResourceNames.loaderName)
        aniView.loopMode = .loop
        aniView.play()
    }
}
