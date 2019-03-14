import Foundation

class BaseConverter {
    //Numeral Alphabet Elements
    static private let numerals0to9 = getLetters(startUnicode: 0x0030, numberOfLetters: 10)
    static private let lettersAtoZLowerCase = getLetters(startUnicode: 0x0061, numberOfLetters: 26)
    static private let lettersAtoZUpperCase = getLetters(startUnicode: 0x0041, numberOfLetters: 26)
    static private let lettersGreek = getLetters(startUnicode: 0x03B1, numberOfLetters: 25)
    static private let lettersKatakana = ["グ", "ダ", "バ", "ム", "ヰ", "ァ", "ケ", "チ", "メ", "ヱ", "ヂ", "ヒ", "モ", "ヲ", "ィ", "コ", "ッ", "ビ", "ャ", "ン", "イ", "ゴ", "ツ", "ヤ", "ヴ", "ゥ", "サ", "ヅ", "フ", "ュ", "ヵ", "ウ", "ザ", "テ", "ブ", "ユ", "ヶ", "ェ", "シ", "デ", "ョ", "エ", "ト", "ヘ", "ヨ", "ォ", "ス", "ド", "ベ", "ラ", "オ"]
    
    //Numeral Alphabet Elements for Base58 (does not use 0, l, I, O)
    static private let numerals1to9 = getLetters(startUnicode: 0x0031, numberOfLetters: 9)
    static private let lettersAtoKLowerCase = getLetters(startUnicode: 0x0061, numberOfLetters: 11)
    static private let lettersMtoZLowerCase = getLetters(startUnicode: 0x006D, numberOfLetters: 14)
    static private let lettersAtoHUpperCase = getLetters(startUnicode: 0x0041, numberOfLetters: 8)
    static private let lettersJtoNUpperCase = getLetters(startUnicode: 0x004A, numberOfLetters: 5)
    static private let lettersPtoZUpperCase = getLetters(startUnicode: 0x0050, numberOfLetters: 11)
    
    //Numeral Alphabets
    static private let base58Numerals = numerals1to9 + lettersAtoKLowerCase + + lettersMtoZLowerCase + lettersAtoHUpperCase + lettersJtoNUpperCase + lettersPtoZUpperCase
    static private let base64Numerals = lettersAtoZUpperCase + lettersAtoZLowerCase + numerals0to9 + ["+", "/"]
    static private let base85Numerals = numerals0to9 + lettersAtoZUpperCase + lettersAtoZLowerCase + ["!", "#", "$", "%", "&", "(", ")", "*", "+", "-", ";", "<", "=", ">", "?", "@", "^", "_", "'", "{", "|", "}", "~"]
    static private let base160Numerals = numerals0to9 + lettersAtoZLowerCase + lettersAtoZUpperCase + [".", "-", ":", "+", "=", "^", "!", "/", "*", "?", "&", "<", ">", "(", ")", "[", "]", "{", "}", "@", "%", "$", "#"] + lettersGreek + lettersKatakana
    
    /**
     Converts an integer in any base >= 1 to any base between 1 and 160
     - parameter number: The number that is to be converted as string (so that non-numeral characters can be part of it). Number can be negative.
     - parameter fromBase: The base the number is converted from. Must be >= 1 and <= 160
     - parameter toBase: The base the number is converted to. Must be >= 1 and <= 160
     - returns: The converted number as string in the declared base. Nil if conversion fails
     */
    static func convert(_ number: String, fromBase oldBase: Int = 10, toBase newBase: Int = 2) -> String? {
        //Check if parameters are within acceptable ranges
        if number == "" || oldBase < 1 || oldBase > 160 || newBase < 1 || newBase > 160 {
            return nil
        }
        
        //"0" does not not require the full conversion-algorithm. Conversion can be stopped here
        if number == "0" {
            //Unless any of the bases are 58 or 64, in which "0" is a different character
            if newBase != 58 && newBase != 64 && oldBase != 58 && oldBase != 64 {
                if newBase == 1 {
                    //Unless the new base is base1, where 0 cannot be displayed
                    return nil
                } else {
                    return "0"
                }
            }
        }
        
        var numberString = number
        
        //Non-base10 numbers need to be converted to base10 first in order to be calculated
        if oldBase != 10 {
            numberString = convertAnyBaseToBase10(number, fromBase: oldBase)
        }
        
        //When converting to base1 a different algorithm is used
        if newBase == 1 {
            let numberAsInt = Int(numberString)!
            return convertFromBase10ToBase1(numberAsInt)
        } else {
            var isNegative = false
            if number.first == "-" {
                isNegative = true
                numberString = String(numberString.dropFirst())
            }
            
            let newNumberAsInt = Int(numberString)!
            var remainder = newNumberAsInt
            let baseNumerals = getNumerals(forBase: newBase)
            var newBaseNumberAsString = ""
            while remainder > 0 {
                let iterationSolution = remainder / newBase
                let currentRemainder = remainder % newBase
                let currentCharacter = baseNumerals[currentRemainder]
                newBaseNumberAsString = "\(currentCharacter)\(newBaseNumberAsString)"
                remainder = iterationSolution
            }
            
            if isNegative {
                newBaseNumberAsString = "-\(newBaseNumberAsString)"
            }
            
            return newBaseNumberAsString
        }
    }
    
    /**
     Converts any number in any base from 1 to 160 to base10
     - parameters number: The number that is to be converted as string
     - parameters fromBase: The current base the number is in. Must be >= 1 and <= 160
     - returns: The number in base10 as String
     */
    static private func convertAnyBaseToBase10(_ number: String, fromBase oldBase: Int = 2) -> String {
        //Convert from base1 to base10. In base1 the number is the amount of characters used
        if oldBase == 1 {
            let convertedNumber = number.count
            return "\(convertedNumber)"
        } else if oldBase == 10 {
            //If input number is already base10 skip conversion and return
            return number
        }
        
        var numberString = number
        var isNegative = false
        
        if number.first == "-" {
            isNegative = true
            numberString = String(numberString.dropFirst())
        }
        
        var newNumber = 0
        for (index, character) in numberString.enumerated() {
            let currentCharacterAsInt = Int(String(character))!
            let exponent = numberString.count - 1 - index
            let calculationFactor = Int(pow(Double(oldBase), Double(exponent)))
            newNumber += currentCharacterAsInt * calculationFactor
        }
        
        if isNegative {
            newNumber = newNumber * -1
        }
        
        return "\(newNumber)"
    }
    
    /**
     Converts any number in base10 to base1
     - parameters number: The number that is to be displayed. Needs to be >= 1
     - parameters character: The character that is used to display the number. Default is "|"
     - returns: A string displaying the entered number in entered character
     */
    static private func convertFromBase10ToBase1(_ number: Int, character: String = "|") -> String {
        var newNumber = ""
        for _ in 0..<number {
            newNumber += character
        }
        return newNumber
    }
    
    /**
     Returns an array with the correct numerals that are used to display a number in the specified base.
     Bases 2 to 85 share the same numerals, up to the point where the base terminates. Base58 and Base64 have unique numerals.
     Bases 86-160 use a different set of numerals.
     - parameter forBase: The base that the numerals should be able to display. Must be >= 2 and <= 160
     - returns: An array of single characters as strings that are used to assembled a number in the given base
     */
    static private func getNumerals(forBase base: Int = 10) -> [String] {
        switch base {
        case 2...57, 59...63, 65...85:
            //Get the numerals from base85 up to the needed amount
            return Array(base85Numerals.prefix(base))
        case 58:
            return base58Numerals
        case 64:
            return base64Numerals
        case 86...160:
            //Get the numerals from base160 up to the needed amount
            return Array(base160Numerals.prefix(base))
        default:
            return [String]()
        }
    }
    
    /**
     Creates an array of letters as strings beginning at a specified unicode going forward
     - parameters startUnicode: The letter to start at in hexcode, i.e. "0x0061" ("a")
     - parameters numberOfLetters: The amount of letters that should be added to the array
     - returns: An array of Strings with the letters
     */
    static private func getLetters(startUnicode: Int, numberOfLetters: Int) -> [String] {
        var letterArray = [String]()
        for index in 0..<numberOfLetters {
            let currentCharacter = Character(UnicodeScalar(startUnicode + index)!)
            letterArray.append("\(currentCharacter)")
        }
        return letterArray
    }
}
