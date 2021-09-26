# ZXingSwift

ZXingSwift is a barcode scanning library for iOS.

# Instration

Add a Swift Package reference to https://github.com/nnabeyang/zxing-swift.git.

# Usage

```swift
//import ZXingSwift
var v = ZXingResult()
let img = UIImage(named: "code39_0", in: Bundle.module, compatibleWith: nil)
if !readBarcode(img, &v, hints: [(.CODE_39, 4), (.QR_CODE, 4)]) {
  XCTFail()
   return
}
XCTAssertEqual("1234", String(cString: &v.text.0))
XCTAssertEqual(.CODE_39, v.barcodeFormat())
```

# License

ZXingSwift is published under the MIT License, see LICENSE.

# Author
[Noriaki Watanabe@nnabeyang](https://twitter.com/nnabeyang)
