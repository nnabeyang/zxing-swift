import XCTest
@testable import ZXingCpp
@testable import ZXingSwift

final class ZXingSwiftTests: XCTestCase {
    func testCode39_1() {
        var v = ZXingResult()
        let img = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        if !readBarcode(img, &v, hints: [(.CODE_39, 4), (.QR_CODE, 4)]) {
            XCTFail()
            return
        }
        XCTAssertEqual("1234", String(cString: &v.text.0))
        XCTAssertEqual(.CODE_39, v.barcodeFormat())
    }
    
    func testWrongLength() {
        var v = ZXingResult()
        let img = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        if readBarcode(img, &v, hints: [(.CODE_39, 5), (.QR_CODE, 4)]) {
            XCTFail()
            return
        }
        XCTAssertEqual(4, v.length)
        XCTAssertEqual("1234", String(cString: &v.text.0))
        XCTAssertEqual(.CODE_39, v.barcodeFormat())
    }
    
    func testAnyLength() {
        var v = ZXingResult()
        let hints: [(BarcodeFormat, Int?)] = [(.CODE_39, nil), (.QR_CODE, 10)]
        let img0 = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        if !readBarcode(img0, &v, hints: hints) {
            XCTFail()
            return
        }
        XCTAssertEqual("1234",String(cString: &v.text.0))
        XCTAssertEqual(.CODE_39, v.barcodeFormat())
        
        let img1 = UIImage(named: "code39_1", in: Bundle.module, compatibleWith: nil)
        if !readBarcode(img1, &v, hints: hints) {
            XCTFail()
            return
        }
        XCTAssertEqual("12345678",String(cString: &v.text.0))
        XCTAssertEqual(.CODE_39, v.barcodeFormat())
    }
    
    func testBarcodeFormatOrOp() {
        let f1 = BarcodeFormat.CODE_39
        let f2 = BarcodeFormat.QR_CODE
        var f = f1
        f |= f2
        XCTAssertEqual(f, f1 | f2)
    }
    
    func testEquatable() {
        let f1 = BarcodeFormat.CODE_39
        let f2 = BarcodeFormat.QR_CODE
        XCTAssertTrue(f1 != f2)
        XCTAssertFalse(f1 == f2)
    }
    static var allTests = [
        ("testCode39_1", testCode39_1),
        ("testWrongLength", testWrongLength),
        ("testAnyLength", testAnyLength),
        ("testBarcodeFormatOrOp", testBarcodeFormatOrOp),
        ("testEquatable", testEquatable),
    ]
}
