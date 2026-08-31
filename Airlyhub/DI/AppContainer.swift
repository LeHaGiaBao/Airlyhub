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
///
/// `AppContainer.shared` is the app's single sanctioned singleton; it replaces the
/// per-service `.shared` accessors and the `makeRepository()` copies that used to
/// sit in each builder. Tests and previews build their own `AppContainer(...)`
/// with fakes and hand it to the builder under test.
final class AppContainer {
    static let shared = AppContainer()

    // MARK: - Feature switches

    /// Flip to `false` once the `tours` collection is populated and its indexes
    /// are deployed. `TourService` already implements `TourRepositoryProtocol` and
    /// sorts results identically, so no feature code changes — only this line.
    static let useMockCatalog = true

    // MARK: - Repositories

    let authRepository: AuthRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    let cardRepository: CardRepositoryProtocol
    let chatRepository: ChatRepositoryProtocol
    let chatAttachmentRepository: ChatAttachmentRepositoryProtocol
    let avatarRepository: AvatarRepositoryProtocol

    /// `MockTourRepository` today, `TourService` once `useMockCatalog` is off.
    let tourRepository: TourRepositoryProtocol

    /// One instance for the whole app: two screens showing hearts must agree on
    /// the saved set. Was `MockFavoritesRepository.shared`.
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
