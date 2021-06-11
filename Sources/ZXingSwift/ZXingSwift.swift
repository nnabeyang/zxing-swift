import ZXingCpp
import UIKit
import Foundation

public struct BarcodeFormat: Equatable {
    public let rawValue: UInt32
    public static func ==(left: BarcodeFormat, right: BarcodeFormat) -> Bool {
        return left.rawValue == right.rawValue
    }
    public static func |(left: BarcodeFormat, right: BarcodeFormat) -> BarcodeFormat {
        return BarcodeFormat(rawValue: left.rawValue | right.rawValue)
    }
    public static func |= (left: inout BarcodeFormat, right: BarcodeFormat) {
        left = left | right
    }
    public static let NONE              = BarcodeFormat(rawValue: 0)       //< Used as a return value if no valid barcode has been detected
    public static let AZTEC             = BarcodeFormat(rawValue: 1 << 0)  //< Aztec (2D)
    public static let CODABAR           = BarcodeFormat(rawValue: 1 << 1)  //< CODABAR (1D)
    public static let CODE_39           = BarcodeFormat(rawValue: 1 << 2)  //< Code 39 (1D)
    public static let CODE_93           = BarcodeFormat(rawValue: 1 << 3)  //< Code 93 (1D)
    public static let CODE_128          = BarcodeFormat(rawValue: 1 << 4)  //< Code 128 (1D)
    public static let DATA_MATRIX       = BarcodeFormat(rawValue: 1 << 5)  //< Data Matrix (2D)
    public static let EAN_8             = BarcodeFormat(rawValue: 1 << 6)  //< EAN-8 (1D)
    public static let EAN_13            = BarcodeFormat(rawValue: 1 << 7)  //< EAN-13 (1D)
    public static let ITF               = BarcodeFormat(rawValue: 1 << 8)  //< ITF (Interleaved Two of Five) (1D)
    public static let MAXICODE          = BarcodeFormat(rawValue: 1 << 9)  //< MaxiCode (2D)
    public static let PDF_417           = BarcodeFormat(rawValue: 1 << 10) //< PDF417 (1D) or (2D)
    public static let QR_CODE           = BarcodeFormat(rawValue: 1 << 11) //< QR Code (2D)
    public static let RSS_14            = BarcodeFormat(rawValue: 1 << 12) //< RSS 14
    public static let RSS_EXPANDED      = BarcodeFormat(rawValue: 1 << 13) //< RSS EXPANDED
    public static let UPC_A             = BarcodeFormat(rawValue: 1 << 14) //< UPC-A (1D)
    public static let UPC_E             = BarcodeFormat(rawValue: 1 << 15) //< UPC-E (1D)
    public static let UPC_EAN_EXTENSION = BarcodeFormat(rawValue: 1 << 16) //< UPC/EAN extension (1D). Not a stand-alone format.
}

public struct BarcodeResult {
    public let format:BarcodeFormat
    public let text: String
}

public func readBarcode(_ img:UIImage?, hints: [(BarcodeFormat, Int?)]) -> BarcodeResult? {
    guard let img = img else { return nil }
    guard let cgImg = img.cgImage else { return nil }
    guard let data = img.bytes() else { return nil }
    var fmt = BarcodeFormat.NONE
    for hint in hints {
        fmt |= hint.0
    }
    var v = ZXingCpp.ZXingResult()
    let result = readBarCode(data, &v, width: cgImg.width, height: cgImg.height, format: fmt)
    
    if result.format.rawValue == 0 {
        return nil
    }
    
    guard let hint = (hints.filter { $0.0 == result.format}).first else {
        return nil
    }
    
    guard let length = hint.1 else {
        return result
    }
    
    if length == result.text.count {
        return result
    }
    
    return nil
}

public func readBarcode2(_ img:UIImage?, v: inout ZXingCpp.ZXingResult, hints: [(BarcodeFormat, Int?)]) {
    guard let img = img else { return }
    guard let cgImg = img.cgImage else { return }
    guard let data = img.bytes() else { return }
    var fmt = BarcodeFormat.NONE
    for hint in hints {
        fmt |= hint.0
    }
    
    let result = readBarCode(data, &v, width: cgImg.width, height: cgImg.height, format: fmt)
    
    if result.format == .NONE {
        return
    }
    
    guard let hint = (hints.filter { $0.0 == result.format}).first else {
        return
    }
    
    guard let length = hint.1 else {
        return
    }
    
    if length == result.text.count {
        return
    }
    
    return
}


private  func readBarCode(_ data:UnsafePointer<UInt8>,_ v: inout ZXingCpp.ZXingResult, width: Int, height: Int, format: BarcodeFormat) -> BarcodeResult {
    ZXingCpp.read_barcode(data, Int32(width), Int32(height), Int32(4), ZXingCpp.Format(format.rawValue), &v)
    let code = String(cString: &v.text.0)
    let format = BarcodeFormat(rawValue: v.format.rawValue)
    return BarcodeResult(format: format, text: code)
}
