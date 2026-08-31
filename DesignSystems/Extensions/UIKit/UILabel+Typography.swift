//
//  UILabelExtension.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 17/01/2026.
//

import UIKit
import ObjectiveC

/// Which line height `applyTypography` should give a label.
enum TypographyLineHeight {
    /// The style's own `lineHeight` token. Right for body copy, where the token is
    /// the leading between stacked lines.
    case token
    /// The font's own metrics, with no forced leading at all.
    ///
    /// Right for a single-line label centered inside a fixed-height container — a
    /// pill badge, a chip, a compact row. A token line height is taller than the
    /// font, and TextKit adds that surplus asymmetrically about the baseline, so
    /// the glyphs sit high inside the label's box however carefully the box itself
    /// is centered. With no surplus there is nothing to sit off-centre in.
    case natural
    /// An explicit line height.
    case fixed(CGFloat)
}

extension UILabel {
    private static var typographyKey: UInt8 = 0
    private static var lineHeightKey: UInt8 = 0

    /// The style last given to `applyTypography`, remembered so `setText` can
    /// re-embed it. Stashed via the runtime rather than a stored property, since an
    /// extension can't add one.
    private var appliedTypography: TypographyStyle? {
        get { objc_getAssociatedObject(self, &Self.typographyKey) as? TypographyStyle }
        set { objc_setAssociatedObject(self, &Self.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// The line height mode last given to `applyTypography` — stashed the same way
    /// and for the same reason as `appliedTypography`.
    private var appliedLineHeight: TypographyLineHeight {
        get { objc_getAssociatedObject(self, &Self.lineHeightKey) as? TypographyLineHeight ?? .token }
        set { objc_setAssociatedObject(self, &Self.lineHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func applyTypography(_ style: TypographyStyle, lineHeight: TypographyLineHeight = .token) {
        appliedTypography = style
        appliedLineHeight = lineHeight

        let resolvedLineHeight: CGFloat?
        switch lineHeight {
        case .token: resolvedLineHeight = style.lineHeight
        case .natural: resolvedLineHeight = nil
        case .fixed(let value): resolvedLineHeight = value
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.fontSize * style.letterSpacing
        ]

        // Left at zero for `.natural`, which `NSParagraphStyle` reads as "no limit"
        // — TextKit then lays the line out on the font's own metrics.
        if let resolvedLineHeight {
            paragraphStyle.minimumLineHeight = resolvedLineHeight
            paragraphStyle.maximumLineHeight = resolvedLineHeight
            // A forced line height taller than the font leaves surplus space that
            // TextKit stacks below the baseline, pushing the glyphs up. This puts
            // roughly half of it back above them.
            attributes[.baselineOffset] = (resolvedLineHeight - style.font.lineHeight) / 4
        }

        attributes[.paragraphStyle] = paragraphStyle
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }

    /// Updates the label's text without losing whatever `applyTypography` style it
    /// carries.
    ///
    /// Plain `label.text = ...` alone silently drops that style: UIKit discards the
    /// existing `attributedText` and rebuilds a plain one from the label's base
    /// `font`/`textColor`, which `applyTypography` never touches — it only ever
    /// wrote the custom font, kerning and line height into the attributed string
    /// itself. A label styled once via `applyTypography` at setup and given its
    /// real text later — which is how nearly every dynamic label in this app is
    /// built — falls back to the plain system font the moment that later
    /// assignment runs, with no warning that anything changed.
    ///
    /// Use this instead of `.text = ` for any label `applyTypography` has touched.
    func setText(_ newText: String?) {
        text = newText
        if let style = appliedTypography {
            applyTypography(style, lineHeight: appliedLineHeight)
        }
    }
}
