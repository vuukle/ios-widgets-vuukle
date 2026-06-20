//
//  VuukleWidgetTests.swift
//
//  Minimal package sanity test. Real regression coverage for the
//  crash fixes lives in VuukleCrashFixTests.swift.
//

import XCTest
@testable import VuukleWidget

final class VuukleWidgetTests: XCTestCase {
    func testSDKVersionIsSemver() {
        // The original test asserted on a "Hello, World!" placeholder that
        // we removed in the v2.2.6 cleanup. Replaced with a semver check
        // on the proper SDK version constant.
        XCTAssertFalse(VuukleSDK.version.isEmpty)
        XCTAssertNotNil(
            VuukleSDK.version.range(of: #"^\d+\.\d+\.\d+$"#, options: .regularExpression),
            "Version '\(VuukleSDK.version)' is not semver-shaped"
        )
    }
}
