# BaseNumberConverter

[![Made with Swift](https://img.shields.io/badge/Made_with-Swift-fa7343.svg?logo=swift&style=popout)](https://www.apple.com/swift/)

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-brightgreen.svg)](https://github.com/matthiaszarzecki/MadeWithUnityBadges/graphs/commit-activity) [![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](http://www.matthiaszarzecki.com) [![License](https://img.shields.io/badge/License-CC-blue.svg)](https://en.wikipedia.org/wiki/Creative_Commons_license) [![Twitter Follow](https://img.shields.io/twitter/follow/icarustyler.svg?style=social&label=Follow)](https://twitter.com/IcarusTyler)

Algorithm that converts a number from any base to any other base. Works with bases 1 to 160

# Examples

BaseConverter.convert("0", fromBase: 2, toBase: 10)       //0
BaseConverter.convert("1", fromBase: 2, toBase: 10)       //1
BaseConverter.convert("10", fromBase: 2, toBase: 10)      //2
BaseConverter.convert("11", fromBase: 2, toBase: 10)      //3
BaseConverter.convert("100", fromBase: 2, toBase: 10)     //4

BaseConverter.convert("0", fromBase: 10, toBase: 2)       //0
BaseConverter.convert("1", fromBase: 10, toBase: 2)       //1
BaseConverter.convert("2", fromBase: 10, toBase: 2)       //10
BaseConverter.convert("11", fromBase: 10, toBase: 2)      //1011
BaseConverter.convert("12", fromBase: 10, toBase: 2)      //1100
BaseConverter.convert("13", fromBase: 10, toBase: 2)      //1101
BaseConverter.convert("-13", fromBase: 10, toBase: 2)     //-1101

BaseConverter.convert("0", fromBase: 10, toBase: 3)       //0
BaseConverter.convert("1", fromBase: 10, toBase: 3)       //1
BaseConverter.convert("2", fromBase: 10, toBase: 3)       //2
BaseConverter.convert("3", fromBase: 10, toBase: 3)       //10
BaseConverter.convert("-13", fromBase: 10, toBase: 3)     //-111

BaseConverter.convert("0", fromBase: 10, toBase: 36)      //0
BaseConverter.convert("1", fromBase: 10, toBase: 36)      //1
BaseConverter.convert("2", fromBase: 10, toBase: 36)      //2
BaseConverter.convert("3", fromBase: 10, toBase: 36)      //3
BaseConverter.convert("17", fromBase: 10, toBase: 36)     //H
BaseConverter.convert("22", fromBase: 10, toBase: 36)     //M
BaseConverter.convert("35", fromBase: 10, toBase: 36)     //Z
BaseConverter.convert("36", fromBase: 10, toBase: 36)     //10
BaseConverter.convert("37", fromBase: 10, toBase: 36)     //11
BaseConverter.convert("-37", fromBase: 10, toBase: 36)    //-11

BaseConverter.convert("-37", fromBase: 8, toBase: 4)      //-133
BaseConverter.convert("84", fromBase: 10, toBase: 85)     //~

BaseConverter.convert("61", fromBase: 10, toBase: 62)     //z
BaseConverter.convert("62", fromBase: 10, toBase: 62)     //10
BaseConverter.convert("2", fromBase: 10, toBase: 2)       //10
BaseConverter.convert("2", fromBase: 10, toBase: 1)       //||
BaseConverter.convert("4", fromBase: 10, toBase: 1)       //||||

BaseConverter.convert("||||", fromBase: 1, toBase: 10)    //4
BaseConverter.convert("1263", fromBase: 10, toBase: 85)   //E<
BaseConverter.convert("84", fromBase: 10, toBase: 85)     //~

BaseConverter.convert("159", fromBase: 10, toBase: 160)   //ラ
BaseConverter.convert("160", fromBase: 10, toBase: 160)   //10

BaseConverter.convert("1263", fromBase: 10, toBase: 161)  //nil (outside base range)
BaseConverter.convert("1263", fromBase: 0, toBase: 86)    //nil (outside base range)
BaseConverter.convert("", fromBase: 3, toBase: 86)        //nil (faulty input number)
