//
//  TicketCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit
import SnapKit

/// The boarding pass on the ticket detail screen: photo, flight title, the four
/// facts, then a torn edge and the barcode.
final class TicketCardView: UIView {
    private enum Layout {
        static let cornerRadius: CGFloat = 20
        static let padding: CGFloat = 24
        static let imageHeight: CGFloat = 130
        static let titleTop: CGFloat = 20
        static let separatorTop: CGFloat = 20
        static let gridTop: CGFloat = 20
        static let rowSpacing: CGFloat = 20
        static let captionSpacing: CGFloat = 4
        static let perforationHeight: CGFloat = 40
        static let notchRadius: CGFloat = 10
        static let dashPattern: [NSNumber] = [5, 5]
        static let dashInset: CGFloat = 18
        static let barcodeInset: CGFloat = 44
        static let barcodeHeight: CGFloat = 64
        static let numberTop: CGFloat = 10
    }

    private static let shadow = ShadowProvider().shadow(for: .md)

    private lazy var stubLayers: [CAShapeLayer] = Self.shadow.shadows.map { token in
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        layer.shadowColor = token.color.cgColor
        layer.shadowOpacity = token.opacity
        layer.shadowOffset = token.offset
        layer.shadowRadius = token.radius
        return layer
    }

    private let dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = AppColor.PrimaryColors.Gray.color300?.cgColor
        layer.lineWidth = 1
        layer.lineDashPattern = Layout.dashPattern
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColor.PrimaryColors.Gray.color400
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 0
        return label
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.PrimaryColors.Gray.color200
        return view
    }()

    private let dateField = TicketFieldView()
    private let airfieldField = TicketFieldView()
    private let departureField = TicketFieldView()
    private let durationField = TicketFieldView()

    private lazy var gridStack: UIStackView = {
        let topRow = makeRow(left: dateField, right: airfieldField)
        let bottomRow = makeRow(left: departureField, right: durationField)

        let stack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = Layout.rowSpacing
        return stack
    }()

    private let perforationSpacer = UIView()

    private let barcodeView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.magnificationFilter = .nearest
        return imageView
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let tearY = perforationSpacer.frame.midY
        let stubPath = stubPath(tearY: tearY).cgPath

        stubLayers.forEach {
            $0.frame = bounds
            $0.path = stubPath
            $0.shadowPath = stubPath
        }

        dashLayer.frame = bounds
        dashLayer.path = dashPath(tearY: tearY).cgPath
    }

    func configure(with ticket: TicketModel) {
        imageView.setCachedImage(from: ticket.imageURL, placeholder: AssetsIcon.plane)

        setText(ticket.title, on: titleLabel, style: .textMd(weight: .semibold))
        setText(ticket.id, on: numberLabel, style: .textSm(weight: .regular))

        dateField.configure(caption: NSLocalizedString("ticket_date_of_flight", comment: ""),
                            value: ticket.dateText)
        airfieldField.configure(caption: NSLocalizedString("ticket_airfield", comment: ""),
                                value: ticket.airfield)
        departureField.configure(caption: NSLocalizedString("ticket_departure_time", comment: ""),
                                 value: ticket.departureTimeText)
        durationField.configure(caption: NSLocalizedString("ticket_flight_duration", comment: ""),
                                value: ticket.durationText)

        barcodeView.image = UIImage.barcode(from: ticket.id, height: Layout.barcodeHeight)
    }

    private func setupUI() {
        backgroundColor = .clear

        stubLayers.forEach { layer.addSublayer($0) }
        layer.addSublayer(dashLayer)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(separator)
        addSubview(gridStack)
        addSubview(perforationSpacer)
        addSubview(barcodeView)
        addSubview(numberLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.padding)
            make.left.right.equalToSuperview().inset(Layout.padding)
            make.height.equalTo(Layout.imageHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.titleTop)
            make.left.right.equalToSuperview().inset(Layout.padding)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.separatorTop)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        gridStack.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(Layout.gridTop)
            make.left.right.equalToSuperview().inset(Layout.padding)
        }

        perforationSpacer.snp.makeConstraints { make in
            make.top.equalTo(gridStack.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Layout.perforationHeight)
        }

        barcodeView.snp.makeConstraints { make in
            make.top.equalTo(perforationSpacer.snp.bottom)
            make.left.right.equalToSuperview().inset(Layout.barcodeInset)
            make.height.equalTo(Layout.barcodeHeight)
        }

        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(barcodeView.snp.bottom).offset(Layout.numberTop)
            make.left.right.equalToSuperview().inset(Layout.padding)
            make.bottom.equalToSuperview().inset(Layout.padding)
        }
    }

    private func makeRow(left: UIView, right: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }

    private func stubPath(tearY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: Layout.cornerRadius)
        path.append(notchPath(center: CGPoint(x: bounds.minX, y: tearY), facingRight: true))
        path.append(notchPath(center: CGPoint(x: bounds.maxX, y: tearY), facingRight: false))
        return path
    }

    private func notchPath(center: CGPoint, facingRight: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: Layout.notchRadius,
                    startAngle: facingRight ? -.pi / 2 : .pi / 2,
                    endAngle: facingRight ? .pi / 2 : .pi * 1.5,
                    clockwise: true)
        path.close()
        return path.reversing()
    }

    private func dashPath(tearY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX + Layout.dashInset, y: tearY))
        path.addLine(to: CGPoint(x: bounds.maxX - Layout.dashInset, y: tearY))
        return path
    }

    private func setText(_ text: String?, on label: UILabel, style: TypographyStyle) {
        label.text = text
        label.applyTypography(style)
    }
}

private final class TicketFieldView: UIView {
    private enum Layout {
        static let spacing: CGFloat = 4
    }

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color500
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.PrimaryColors.Gray.color800
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)

        let stack = UIStackView(arrangedSubviews: [captionLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.spacing

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(caption: String, value: String) {
        captionLabel.text = caption
        captionLabel.applyTypography(.textXs(weight: .regular))
        valueLabel.text = value
        valueLabel.applyTypography(.textSm(weight: .semibold))
    }
}
