//
//  MyTicketsInteractor.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 14/03/2026.
//

import Foundation

final class MyTicketsInteractor: MyTicketsInteractorProtocol {
    private let bookingRepository: BookingRepositoryProtocol

    init(bookingRepository: BookingRepositoryProtocol) {
        self.bookingRepository = bookingRepository
    }

    func fetchMyTickets(completion: @escaping (Result<[MyTicketsSection], Error>) -> Void) {
        bookingRepository.fetchBookings { result in
            switch result {
            case .success(let bookings):
                completion(.success(Self.group(bookings)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private static func group(_ bookings: [BookingModel]) -> [MyTicketsSection] {
        let calendar = Calendar.current
        var sections: [MutableSection] = []

        for booking in bookings {
            let dayStart = calendar.startOfDay(for: booking.date)
            let ticket = TicketModel(booking: booking)

            if let last = sections.last, calendar.isDate(dayStart, inSameDayAs: last.dayStart) {
                sections[sections.count - 1].tickets.append(ticket)
            } else {
                sections.append(MutableSection(title: title(for: dayStart, calendar: calendar),
                                               dayStart: dayStart,
                                               tickets: [ticket]))
            }
        }

        return sections.map { MyTicketsSection(title: $0.title, tickets: $0.tickets) }
    }

    private static func title(for day: Date, calendar: Calendar) -> String {
        calendar.isDateInToday(day)
            ? NSLocalizedString("today", comment: "")
            : TicketFormatter.date(day)
    }

    private struct MutableSection {
        let title: String
        let dayStart: Date
        var tickets: [TicketModel]
    }
}
