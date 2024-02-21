//
//  Foundation+Extension.swift
//  BaseProject
//
//  Created by Serhii Babii on 21.02.2024.
//

import UIKit

func + <T>(lhs: [T], rhs: T) -> [T] {
    var copy = lhs
    copy.append(rhs)
    return copy
}

func daysInSeconds(numberOfDays: Int) -> Int {
    return (numberOfDays * 60 * 60 * 24)
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}



extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    func rounded(toPlaces places: Int, roundingMode: NumberFormatter.RoundingMode? = nil) -> Float {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = places
        nf.maximumFractionDigits = places
        
        if let _roundingMode = roundingMode {
            nf.roundingMode = _roundingMode
        }
        
        guard var string = nf.string(from: self as NSNumber) else { return self }
        string = string.replacingOccurrences(of: " ", with: "")
                       .replacingOccurrences(of: ",", with: ".")
        return Float(string) ?? self
    }
}

extension String {
    func formattedNumber(mask: String = "+XX (XXX) XXX-XX-XX") -> String {
        let cleanPhoneNumber = self.map{ Int(String( $0 )) }.filter{ $0 != nil}
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append("\(cleanPhoneNumber[index]!)")
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeAllPluses() -> String {
        return self.replacingOccurrences(of: "+", with: "")
    }
    
    func toCleanPhoneFormatSymbols() -> String {
        var cleanSTR = self.replacingOccurrences(of: "+", with: "")
        cleanSTR = cleanSTR.replacingOccurrences(of: "(", with: "")
        cleanSTR = cleanSTR.replacingOccurrences(of: ")", with: "")
        cleanSTR = cleanSTR.replacingOccurrences(of: "-", with: "")
        cleanSTR = cleanSTR.replacingOccurrences(of: " ", with: "")
        return cleanSTR
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

