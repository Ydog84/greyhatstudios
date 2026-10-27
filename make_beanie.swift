import CoreGraphics
import ImageIO
import Foundation
import UniformTypeIdentifiers

// Plain grey knit beanie on a transparent background.
let S: CGFloat = 512
let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8, bytesPerRow: 0,
                    space: space, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
func c(_ v: CGFloat, _ a: CGFloat = 1) -> CGColor { CGColor(srgbRed: v, green: v, blue: v * 1.04, alpha: a) }

let left: CGFloat = 76, right: CGFloat = 436, cuffBottom: CGFloat = 112, cuffTop: CGFloat = 196, top: CGFloat = 430

// Dome.
let dome = CGMutablePath()
dome.move(to: CGPoint(x: left + 8, y: cuffTop - 10))
dome.addCurve(to: CGPoint(x: S / 2, y: top), control1: CGPoint(x: left + 8, y: 360), control2: CGPoint(x: 150, y: top))
dome.addCurve(to: CGPoint(x: right - 8, y: cuffTop - 10), control1: CGPoint(x: 362, y: top), control2: CGPoint(x: right - 8, y: 360))
dome.closeSubpath()
ctx.addPath(dome); ctx.setFillColor(c(0.58)); ctx.fillPath()

// Cuff (folded brim) with ribs.
let cuff = CGPath(roundedRect: CGRect(x: left, y: cuffBottom, width: right - left, height: cuffTop - cuffBottom),
                  cornerWidth: 30, cornerHeight: 30, transform: nil)
ctx.addPath(cuff); ctx.setFillColor(c(0.47)); ctx.fillPath()
ctx.saveGState()
ctx.addPath(cuff); ctx.clip()
ctx.setStrokeColor(c(0.38)); ctx.setLineWidth(9); ctx.setLineCap(.round)
for x in stride(from: left + 30, to: right - 10, by: 32) {
    ctx.move(to: CGPoint(x: x, y: cuffBottom + 18)); ctx.addLine(to: CGPoint(x: x, y: cuffTop - 18)); ctx.strokePath()
}
ctx.restoreGState()

let out = URL(fileURLWithPath: CommandLine.arguments[1])
let dest = CGImageDestinationCreateWithURL(out as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
