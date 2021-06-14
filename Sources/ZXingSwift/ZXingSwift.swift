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

public func readBarcode(_ img:UIImage?,_ v: inout ZXingCpp.ZXingResult, hints: [(BarcodeFormat, Int?)]) -> Bool {
    guard let img = img else { return false}
    guard let cgImg = img.cgImage else { return false}
    guard let data = img.bytes() else { return false}
    var fmt = BarcodeFormat.NONE
    for hint in hints {
        fmt |= hint.0
    }
    
    read_barcode(data, Int32(cgImg.width), Int32(cgImg.height), Int32(4), ZXingCpp.Format(fmt.rawValue), &v)
    if v.format.rawValue == 0 {
        return false
    }
    
    guard let hint = (hints.filter { $0.0.rawValue == v.format.rawValue}).first else {
        return false
    }
    
    guard let length = hint.1 else {
        return true
    }  
    return length == v.length;
}

extension ZXingResult {
    public func barcodeFormat() -> BarcodeFormat {
        return BarcodeFormat(rawValue: format.rawValue)
    }
}
