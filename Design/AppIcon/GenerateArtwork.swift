import AppKit
import CoreText
import Foundation

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: swift GenerateArtwork.swift OUTPUT_DIRECTORY")
}
let root = CommandLine.arguments[1]
let columns = (0..<3).map { index in
    "<rect x=\"\(205 + index * 224)\" y=\"200\" width=\"166\" height=\"436\" rx=\"12\" fill=\"#202321\"/>"
}.joined()
let prefix = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1024\" height=\"1024\" viewBox=\"0 0 1024 1024\">"
try (prefix + columns + "</svg>\n").write(toFile: root + "/Pillars.svg", atomically: true, encoding: .utf8)
let font = CTFontCreateWithName("HiraginoSans-W6" as CFString, 128, nil)
var artwork = ""
for (index, character) in Array("改造社").enumerated() {
    var code = Array(String(character).utf16)[0]
    var glyph: CGGlyph = 0
    guard CTFontGetGlyphsForCharacters(font, &code, &glyph, 1), let path = CTFontCreatePathForGlyph(font, glyph, nil) else { fatalError("Missing brand glyph") }
    let bounds = path.boundingBox
    let dx = CGFloat(288 + index * 224) - bounds.midX
    let dy: CGFloat = 804
    var commands = ""
    path.applyWithBlock { pointer in
        let element = pointer.pointee
        func point(_ i: Int) -> String { "\(element.points[i].x + dx),\(dy - element.points[i].y)" }
        switch element.type {
        case .moveToPoint: commands += "M\(point(0))"
        case .addLineToPoint: commands += "L\(point(0))"
        case .addQuadCurveToPoint: commands += "Q\(point(0)) \(point(1))"
        case .addCurveToPoint: commands += "C\(point(0)) \(point(1)) \(point(2))"
        case .closeSubpath: commands += "Z"
        @unknown default: break
        }
    }
    artwork += "<path fill=\"#202321\" d=\"\(commands)\"/>"
}
try (prefix + artwork + "</svg>\n").write(toFile: root + "/Wordmark.svg", atomically: true, encoding: .utf8)
