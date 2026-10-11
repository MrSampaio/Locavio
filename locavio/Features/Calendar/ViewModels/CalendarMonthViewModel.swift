//
//  CalendarMonthViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

import SwiftUI
import Foundation
import Observation

@Observable
final class CalendarViewModel {
    var mode: CalendarModel = .month
    var referenceDate = Date()
    var selectedDate: Date? = Date()

    private let calendar = Calendar.current

    // MARK: - Cabeçalho

    var title: String {
        referenceDate.formatted(.dateTime.month(.wide).year()).capitalized
    }

    /// DOM, SEG... na ordem do primeiro dia da semana do aparelho
    var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return (Array(symbols[start...]) + Array(symbols[..<start])).map { $0.uppercased() }
    }

    // MARK: - Grade

    var days: [Date?] {
        mode == .month ? monthDays : weekDays
    }

    private var firstDayOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: referenceDate)) ?? referenceDate
    }

    private var leadingBlanks: Int {
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    private var monthDays: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: referenceDate) else { return [] }
        let dates = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: firstDayOfMonth)
        }
        return Array(repeating: nil, count: leadingBlanks) + dates.map { Optional($0) }
    }

    private var weekDays: [Date?] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else { return [] }
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: interval.start) }
    }

    // MARK: - Navegação

    func next() { move(by: 1) }
    func previous() { move(by: -1) }

    private func move(by value: Int) {
        let component: Calendar.Component = (mode == .month) ? .month : .weekOfYear
        referenceDate = calendar.date(byAdding: component, value: value, to: referenceDate) ?? referenceDate
    }

    // MARK: - Seleção

    func select(_ date: Date) { selectedDate = date }

    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }

    func isToday(_ date: Date) -> Bool { calendar.isDateInToday(date) }

    // MARK: - Chamados

    /// Dias (início do dia) que têm pelo menos um chamado concluído
    func daysWithTickets(from tickets: [Ticket]) -> Set<Date> {
        Set(tickets.compactMap(\.conclusionDate).map { calendar.startOfDay(for: $0) })
    }

    func hasTicket(on day: Date, in markedDays: Set<Date>) -> Bool {
        markedDays.contains(calendar.startOfDay(for: day))
    }

    func tickets(from tickets: [Ticket]) -> [Ticket] {
        guard let selectedDate else { return [] }
        return tickets.filter {
            guard let date = $0.conclusionDate else { return false }
            return calendar.isDate(date, inSameDayAs: selectedDate)
        }
    }

    var listTitle: String {
        guard let selectedDate else { return "Chamados" }
        return calendar.isDateInToday(selectedDate)
            ? "Para Hoje"
            : selectedDate.formatted(date: .long, time: .omitted)
    }
}
