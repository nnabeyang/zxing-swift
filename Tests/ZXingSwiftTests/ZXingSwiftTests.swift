import XCTest
@testable import ZXingSwift

final class ZXingSwiftTests: XCTestCase {
    func testCode39_1() {
        let img = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        guard let result = ZXingSwift.readBarcode(img, hints: [(.CODE_39, 4), (.QR_CODE, 4)]) else {
            XCTFail()
            return
        }
        XCTAssertEqual("1234", result.text)
        XCTAssertEqual(.CODE_39, result.format)
    }
    
    func testWrongLength() {
        let img = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        let code = readBarcode(img, hints: [(.CODE_39, 5), (.QR_CODE, 4)])
        XCTAssertNil(code)
    }
    
    func testAnyLength() {
        let hints: [(BarcodeFormat, Int?)] = [(.CODE_39, nil), (.QR_CODE, 10)]
        let img0 = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
        guard let result0 = readBarcode(img0, hints: hints) else {
            XCTFail()
            return
        }
        XCTAssertEqual("1234", result0.text)
        XCTAssertEqual(.CODE_39, result0.format)
        
        let img1 = UIImage(named: "code39_1", in: Bundle.module, compatibleWith: nil)
        guard let result1 = readBarcode(img1, hints: hints) else {
            XCTFail()
            return
        }
        XCTAssertEqual("12345678", result1.text)
        XCTAssertEqual(.CODE_39, result1.format)
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
