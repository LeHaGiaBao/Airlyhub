//
//  AppContainer.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 31/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

/// The composition root — the one place that names concrete `Data` types and
/// decides mock vs live. Every builder asks the container for a protocol instead
/// of calling `SomeService.shared` or `MockSomeRepository()` inline.
final class AppContainer {
    static let shared = AppContainer()

    static let useMockCatalog = true

    let authRepository: AuthRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let cardRepository: CardRepositoryProtocol
    let chatRepository: ChatRepositoryProtocol
    let chatAttachmentRepository: ChatAttachmentRepositoryProtocol
    let avatarRepository: AvatarRepositoryProtocol

    let tourRepository: TourRepositoryProtocol

    let favoritesRepository: FavoritesRepositoryProtocol

    let bookingRepository: BookingRepositoryProtocol

    init(
        authRepository: AuthRepositoryProtocol = AuthService.shared,
        userRepository: UserRepositoryProtocol = UserService.shared,
        cardRepository: CardRepositoryProtocol = CardService.shared,
        chatRepository: ChatRepositoryProtocol = ChatService.shared,
        chatAttachmentRepository: ChatAttachmentRepositoryProtocol = ChatAttachmentService.shared,
        avatarRepository: AvatarRepositoryProtocol = AvatarService.shared,
        tourRepository: TourRepositoryProtocol = AppContainer.useMockCatalog
            ? MockTourRepository()
            : TourService.shared,
        favoritesRepository: FavoritesRepositoryProtocol = MockFavoritesRepository(),
        bookingRepository: BookingRepositoryProtocol = BookingService.shared
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.cardRepository = cardRepository
        self.chatRepository = chatRepository
        self.chatAttachmentRepository = chatAttachmentRepository
        self.avatarRepository = avatarRepository
        self.tourRepository = tourRepository
        self.favoritesRepository = favoritesRepository
        self.bookingRepository = bookingRepository
    }
}
