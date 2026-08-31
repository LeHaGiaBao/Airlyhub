//
//  NotificationCardView.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/03/2026.
//

import SwiftUI

struct NotificationCardView: View {
    let item: NotificationItem

    var body: some View {
        HStack(spacing: 16) {
            if let image = item.iconName {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 46, height: 46)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .applyTypography(.textMd(weight: .medium))
                    .foregroundColor(Color(.gray800))
                Text(item.descscription)
                    .applyTypography(.textXs(weight: .regular))
                    .foregroundColor(Color(.gray500))
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.gray100))
        .cornerRadius(8)
    }
}
