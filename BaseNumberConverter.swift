import Foundation

/**
 Converts an integer in any base >= 1 to any base between 1 and 160
 - parameter number: The number that is to be converted as string (so that non-numeral characters can be part of it). Number can be negative.
 - parameter fromBase: The base the number is converted from. Must be >= 1 and <= 160
 - parameter toBase: The base the number is converted to. Must be >= 1 and <= 160
 - returns: The converted number as string in the declared base. Nil if conversion fails
 */
func convert(_ number: String, fromBase oldBase: Int = 10, toBase newBase: Int = 2) -> String? {
    /**
     Converts any number in any base from 1 to 160 to base10
     - parameters number: The number that is to be converted as string
     - parameters fromBase: The current base the number is in. Must be >= 1 and <= 160
     - returns: The number in base10 as String
     */
    func convertAnyBaseToBase10(_ number: String, fromBase oldBase: Int = 2) -> String {
        //Convert from Unary (base1). In Unary number is the amount of characters used
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
    func convertFromBase10ToBase1(_ number: Int, character: String = "|") -> String {
        var newNumber = ""
        for _ in 0..<number {
            newNumber += character
        }
        return newNumber
    }
    
    /**
     Returns an array with the correct numerals that are used to display a number in the specified base.
     Base58 and Base64 have unique numerals. All other bases share the same numerals, up to the point where the base terminates
     - parameter forBase: The base that the numerals should be able to display. Must be > 1 and <= 160
     - returns: An array of single characters as strings that are used to assembled a number in the given base
     */
    func getNumerals(forBase base: Int = 10) -> [String] {
        func getLetters(startUnicode: Int, numberOfLetters: Int) -> [String] {
            var letterArray = [String]()
            for index in 0..<numberOfLetters {
                let currentCharacter = Character(UnicodeScalar(startUnicode + index)!)
                letterArray.append("\(currentCharacter)")
            }
            return letterArray
        }
        
        let lettersAtoZlowerCase = getLetters(startUnicode: 0x0061, numberOfLetters: 26)
        let lettersAtoZUpperCase = getLetters(startUnicode: 0x0041, numberOfLetters: 26)
        let lettersGreek = getLetters(startUnicode: 0x03B1, numberOfLetters: 25)
        let lettersKatakana = ["グ", "ダ", "バ", "ム", "ヰ", "ァ", "ケ", "チ", "メ", "ヱ", "ヂ", "ヒ", "モ", "ヲ", "ィ", "コ", "ッ", "ビ", "ャ", "ン", "イ", "ゴ", "ツ", "ヤ", "ヴ", "ゥ", "サ", "ヅ", "フ", "ュ", "ヵ", "ウ", "ザ", "テ", "ブ", "ユ", "ヶ", "ェ", "シ", "デ", "ョ", "エ", "ト", "ヘ", "ヨ", "ォ", "ス", "ド", "ベ", "ラ", "オ"]
        var numerals0to9: [String] {
            var numeralArray = [String]()
            for index in 0...9 {
                numeralArray.append("\(index)")
            }
            return numeralArray
        }
        
        let base58Numerals = numerals0to9 + lettersAtoZlowerCase + lettersAtoZUpperCase
        let base64Numerals = lettersAtoZUpperCase + lettersAtoZlowerCase + numerals0to9 + ["+", "/"]
        let base85Numerals = numerals0to9 + lettersAtoZUpperCase + lettersAtoZlowerCase + ["!", "#", "$", "%", "&", "(", ")", "*", "+", "-", ";", "<", "=", ">", "?", "@", "^", "_", "'", "{", "|", "}", "~"]
        let base160Numerals = numerals0to9 + lettersAtoZlowerCase + lettersAtoZUpperCase + [".", "-", ":", "+", "=", "^", "!", "/", "*", "?", "&", "<", ">", "(", ")", "[", "]", "{", "}", "@", "%", "$", "#"] + lettersGreek + lettersKatakana
        
        switch base {
        case 1...57, 59...63, 65...85:
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
    
    //When converting to unary a different algorithm is used
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

convert("0", fromBase: 2, toBase: 10)       //0
convert("1", fromBase: 2, toBase: 10)       //1
convert("10", fromBase: 2, toBase: 10)      //2
convert("11", fromBase: 2, toBase: 10)      //3
convert("100", fromBase: 2, toBase: 10)     //4

convert("0", fromBase: 10, toBase: 2)       //0
convert("1", fromBase: 10, toBase: 2)       //1
convert("2", fromBase: 10, toBase: 2)       //10
convert("11", fromBase: 10, toBase: 2)      //1011
convert("12", fromBase: 10, toBase: 2)      //1100
convert("13", fromBase: 10, toBase: 2)      //1101
convert("-13", fromBase: 10, toBase: 2)     //-1101

convert("0", fromBase: 10, toBase: 3)       //0
convert("1", fromBase: 10, toBase: 3)       //1
convert("2", fromBase: 10, toBase: 3)       //2
convert("3", fromBase: 10, toBase: 3)       //10
convert("-13", fromBase: 10, toBase: 3)     //-111

convert("0", fromBase: 10, toBase: 36)      //0
convert("1", fromBase: 10, toBase: 36)      //1
convert("2", fromBase: 10, toBase: 36)      //2
convert("3", fromBase: 10, toBase: 36)      //3
convert("17", fromBase: 10, toBase: 36)     //H
convert("22", fromBase: 10, toBase: 36)     //M
convert("35", fromBase: 10, toBase: 36)     //Z
convert("36", fromBase: 10, toBase: 36)     //10
convert("37", fromBase: 10, toBase: 36)     //11
convert("-37", fromBase: 10, toBase: 36)    //-11

convert("-37", fromBase: 8, toBase: 4)      //-133

convert("61", fromBase: 10, toBase: 62)     //z
convert("62", fromBase: 10, toBase: 62)     //10
convert("2", fromBase: 10, toBase: 2)       //10
convert("2", fromBase: 10, toBase: 1)       //||
convert("4", fromBase: 10, toBase: 1)       //||||

convert("||||", fromBase: 1, toBase: 10)    //4
convert("1263", fromBase: 10, toBase: 85)   //E<
convert("84", fromBase: 10, toBase: 85)     //~

convert("159", fromBase: 10, toBase: 160)   //ラ
convert("160", fromBase: 10, toBase: 160)   //10

convert("1263", fromBase: 10, toBase: 86)   //nil (outside base range)
convert("1263", fromBase: 0, toBase: 86)    //nil (outside base range)

