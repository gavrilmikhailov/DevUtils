import AppKit

public protocol ModuleProtocol {
    var name: String { get }
    var icon: NSImage { get }
    var viewController: NSViewController { get }
}

// the following code makes ALL OF Lists background color transparent:
public extension NSTableView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear
        if let esv = enclosingScrollView {
            esv.drawsBackground = false
        }
    }
}

// the following code makes ALL OF TextEditors background color transparent:
public extension NSTextView {
    override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
