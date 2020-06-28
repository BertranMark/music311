//
//  CMTime + Extention.swift
//  music311
//
//  Created by Bertran on 17.06.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString () -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minuts = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minuts, seconds)
        return timeFormatString
        
    }
}
