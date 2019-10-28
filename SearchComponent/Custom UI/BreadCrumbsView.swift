//
//  BreadCrumbsView.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 28.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

@objc public protocol CrumbListViewDelegate {
    @objc optional func crumbPressed(_ title: String, crumbView: CrumbView, sender: BreadCrumbsView) -> Void
    @objc optional func crumbSeparatorPressed(_ title: String, crumbView: CrumbView, sender: BreadCrumbsView) -> Void
}

@IBDesignable
open class BreadCrumbsView: UIView {
    
    @IBInspectable open dynamic var textColor: UIColor = .white {
        didSet {
            crumbViews.forEach {
                $0.textColor = textColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedTextColor: UIColor = .white {
        didSet {
            crumbViews.forEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }

    @IBInspectable open dynamic var crumbBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            crumbViews.forEach {
                $0.titleLineBreakMode = crumbBreakMode
            }
        }
    }
    
    @IBInspectable open dynamic var crumbBackgroundColor: UIColor = UIColor.gray {
        didSet {
            crumbViews.forEach {
                $0.tagBackgroundColor = crumbBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var crumbHighlightedBackgroundColor: UIColor? {
        didSet {
            crumbViews.forEach {
                $0.highlightedBackgroundColor = crumbHighlightedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var crumbSelectedBackgroundColor: UIColor? {
        didSet {
            crumbViews.forEach {
                $0.selectedBackgroundColor = crumbSelectedBackgroundColor
            }
        }
    }
    
    @IBInspectable open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            crumbViews.forEach {
                $0.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            crumbViews.forEach {
                $0.borderWidth = borderWidth
            }
        }
    }
    
    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            crumbViews.forEach {
                $0.borderColor = borderColor
            }
        }
    }
    
    @IBInspectable open dynamic var selectedBorderColor: UIColor? {
        didSet {
            crumbViews.forEach {
                $0.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.paddingY = paddingY
            }
        }
    }
    @IBInspectable open dynamic var paddingX: CGFloat = 5 {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.paddingX = paddingX
            }
        }
    }
    @IBInspectable open dynamic var marginY: CGFloat = 2 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc public enum Alignment: Int {
        case left
        case center
        case right
    }
    @IBInspectable open var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowColor: UIColor = .white {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOffset: CGSize = .zero {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @IBInspectable open dynamic var enableSeparator: Bool = false {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.enableSeparator = enableSeparator
            }
        }
    }
    
    @IBInspectable open dynamic var separatorIconSize: CGFloat = 12 {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.separatorIconSize = separatorIconSize
            }
        }
    }
    @IBInspectable open dynamic var separatorIconLineWidth: CGFloat = 1 {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.separatorIconLineWidth = separatorIconLineWidth
            }
        }
    }
    
    @IBInspectable open dynamic var separatorIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.separatorIconLineColor = separatorIconLineColor
            }
        }
    }
    
    @objc open dynamic var textFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            defer { rearrangeViews() }
            crumbViews.forEach {
                $0.textFont = textFont
            }
        }
    }
    
    @IBOutlet open weak var delegate: CrumbListViewDelegate?
    
    open private(set) var crumbViews: [CrumbView] = []
    private(set) var crumbBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var crumbViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        addCrumb("Приготовление")
        addCrumb("Посуда для чая и кофе")
        addCrumb("Чайники").isSelected = true
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }
    
    private func rearrangeViews() {
        let views = crumbViews as [UIView] + crumbBackgroundViews + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        for (index, CrumbView) in crumbViews.enumerated() {
            CrumbView.frame.size = CrumbView.intrinsicContentSize
            crumbViewHeight = CrumbView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + CrumbView.frame.width > frame.width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (crumbViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)

                CrumbView.frame.size.width = min(CrumbView.frame.size.width, frame.width)
            }
            
            let tagBackgroundView = crumbBackgroundViews[index]
            tagBackgroundView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            tagBackgroundView.frame.size = CrumbView.bounds.size
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(CrumbView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += CrumbView.frame.width + marginX
            
            switch alignment {
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frame.width - (currentRowWidth - marginX)) / 2
            case .right:
                currentRowView.frame.origin.x = frame.width - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(crumbViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Manage tags
    
    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (crumbViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewCrumbView(_ title: String) -> CrumbView {
        let crumbView = CrumbView(title: title)
        
        if crumbViews.count > 0 {
            crumbViews.last!.enableSeparator = true
        }
        
        crumbView.textColor = textColor
        crumbView.selectedTextColor = selectedTextColor
        crumbView.tagBackgroundColor = crumbBackgroundColor
        crumbView.highlightedBackgroundColor = crumbHighlightedBackgroundColor
        crumbView.selectedBackgroundColor = crumbSelectedBackgroundColor
        crumbView.titleLineBreakMode = crumbBreakMode
        crumbView.cornerRadius = cornerRadius
        crumbView.borderWidth = borderWidth
        crumbView.borderColor = borderColor
        crumbView.selectedBorderColor = selectedBorderColor
        crumbView.paddingX = paddingX
        crumbView.paddingY = paddingY
        crumbView.textFont = textFont
        crumbView.separatorIconLineWidth = separatorIconLineWidth
        crumbView.separatorIconSize = separatorIconSize
        crumbView.enableSeparator = false
        crumbView.separatorIconLineColor = separatorIconLineColor
        crumbView.addTarget(self, action: #selector(crumbPressed(_:)), for: .touchUpInside)
        
        // On long press, deselect all tags except this one
        crumbView.onLongPress = { [unowned self] this in
            self.crumbViews.forEach {
                $0.isSelected = $0 == this
            }
        }
        
        return crumbView
    }

    @discardableResult
    open func addCrumb(_ title: String) -> CrumbView {
        defer { rearrangeViews() }
        return addCrumbView(createNewCrumbView(title))
    }
    
    @discardableResult
    open func addCrumbs(_ titles: [String]) -> [CrumbView] {
        return addCrumbViews(titles.map(createNewCrumbView))
    }
    
    @discardableResult
    open func addCrumbView(_ CrumbView: CrumbView) -> CrumbView {
        defer { rearrangeViews() }
        crumbViews.append(CrumbView)
        crumbBackgroundViews.append(UIView(frame: CrumbView.bounds))
        
        return CrumbView
    }
    
    @discardableResult
    open func addCrumbViews(_ CrumbViews: [CrumbView]) -> [CrumbView] {
        CrumbViews.forEach {
            addCrumbView($0)
        }
        return CrumbViews
    }

    @discardableResult
    open func insertTag(_ title: String, at index: Int) -> CrumbView {
        return insertCrumbView(createNewCrumbView(title), at: index)
    }
    

    @discardableResult
    open func insertCrumbView(_ CrumbView: CrumbView, at index: Int) -> CrumbView {
        defer { rearrangeViews() }
        crumbViews.insert(CrumbView, at: index)
        crumbBackgroundViews.insert(UIView(frame: CrumbView.bounds), at: index)
        
        return CrumbView
    }
    
    open func setTitle(_ title: String, at index: Int) {
        crumbViews[index].titleLabel?.text = title
    }
    
    open func removeCrumb(_ title: String) {
        crumbViews.reversed().filter({ $0.currentTitle == title }).forEach(removeCrumbView)
        crumbViews.last?.enableSeparator = false
    }
    
    open func removeCrumbView(_ CrumbView: CrumbView) {
        defer { rearrangeViews() }
        
        CrumbView.removeFromSuperview()
        if let index = crumbViews.firstIndex(of: CrumbView) {
            crumbViews.remove(at: index)
            crumbBackgroundViews.remove(at: index)
        }
    }
    
    open func cutCrumbs() {
        defer {
            crumbViews = []
            crumbBackgroundViews = []
            rearrangeViews()
        }
        
        let views: [UIView] = crumbViews + crumbBackgroundViews
        views.forEach { $0.removeFromSuperview() }
    }

    open func selectedTags() -> [CrumbView] {
        return crumbViews.filter { $0.isSelected }
    }
    
    // MARK: - Events
    
    @objc func crumbPressed(_ sender: CrumbView!) {
        sender.onTap?(sender)
        delegate?.crumbPressed?(sender.currentTitle ?? "", crumbView: sender, sender: self)
    }
}
