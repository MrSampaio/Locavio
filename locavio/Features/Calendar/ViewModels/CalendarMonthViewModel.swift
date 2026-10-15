//
//  CalendarMonthViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

import SwiftUI
import Foundation
import Observation
import SwiftData

/// Um vencimento de aluguel em uma data específica
struct RentDue: Identifiable {
    let property: Property
    let date: Date
    var id: Property.ID { property.id }
}

@Observable
final class CalendarViewModel {
    var mode: CalendarModel = .month
    var referenceDate = Date()
    var selectedDate: Date? = Date()

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "pt_BR")
        return calendar
    }

    private let locale = Locale(identifier: "pt_BR")


    var title: String {
        let month = referenceDate.formatted(
            .dateTime.locale(locale).month(.wide)
        ).capitalized

        let year = referenceDate.formatted(
            .dateTime.locale(locale).year()
        )

        return "\(month) \(year)"
    }

    /// DOM, SEG... respeitando o primeiro dia da semana do calendário
    var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let start = calendar.firstWeekday - 1

        return (Array(symbols[start...]) + Array(symbols[..<start]))
            .map { $0.uppercased(with: locale) }
    }

    

    var days: [Date?] {
        mode == .month ? monthDays : weekDays
    }

    private var firstDayOfMonth: Date {
        calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: referenceDate
            )
        ) ?? referenceDate
    }

    private var leadingBlanks: Int {
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    private var monthDays: [Date?] {
        guard let range = calendar.range(
            of: .day,
            in: .month,
            for: referenceDate
        ) else {
            return []
        }

        let dates = range.compactMap {
            calendar.date(
                byAdding: .day,
                value: $0 - 1,
                to: firstDayOfMonth
            )
        }

        return Array(repeating: nil, count: leadingBlanks) + dates.map { Optional($0) }
    }

    private var weekDays: [Date?] {
        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: referenceDate
        ) else {
            return []
        }

        return (0..<7).map {
            calendar.date(
                byAdding: .day,
                value: $0,
                to: interval.start
            )
        }
    }

    // Navegação

    func next() {
        move(by: 1)
    }

    func previous() {
        move(by: -1)
    }

    private func move(by value: Int) {
        let component: Calendar.Component = mode == .month ? .month : .weekOfYear

        referenceDate = calendar.date(
            byAdding: component,
            value: value,
            to: referenceDate
        ) ?? referenceDate
    }

    // Seleção

    func select(_ date: Date) {
        selectedDate = date
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    // Chamados

    /// Dias que têm pelo menos um chamado concluído
    func daysWithTickets(from tickets: [Ticket]) -> Set<Date> {
        Set(
            tickets.compactMap(\.conclusionDate)
                .map { calendar.startOfDay(for: $0) }
        )
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

    // Aluguéis

    /// Dia tem vencimento de aluguel?
    func hasRent(on day: Date, from properties: [Property]) -> Bool {
        !rents(on: day, from: properties).isEmpty
    }

    /// Vencimentos do dia selecionado
    func rents(from properties: [Property]) -> [RentDue] {
        guard let selectedDate else { return [] }
        return rents(on: selectedDate, from: properties)
    }

    /// Só entram imóveis alugados (com inquilino) e com dia de pagamento definido.
    /// A conta é feita dia a dia: na visão de semana, uma semana pode cruzar dois meses.
    private func rents(on day: Date, from properties: [Property]) -> [RentDue] {
        properties.compactMap { property in
            guard property.tenant != nil,
                  let due = dueDate(of: property, inMonthOf: day),
                  calendar.isDate(due, inSameDayAs: day)
            else { return nil }

            return RentDue(property: property, date: due)
        }
    }

    /// Data de vencimento do aluguel no mês de `reference`.
    /// Em meses mais curtos (ex.: dia 31 em fevereiro) vence no último dia do mês.
    private func dueDate(of property: Property, inMonthOf reference: Date) -> Date? {
        guard let paymentDay = property.paymentDay, paymentDay > 0,
              let days = calendar.range(of: .day, in: .month, for: reference),
              let firstDay = calendar.date(
                from: calendar.dateComponents([.year, .month], from: reference)
              )
        else { return nil }

        let day = min(paymentDay, days.count)
        return calendar.date(byAdding: .day, value: day - 1, to: firstDay)
    }

    var listTitle: String {
        guard let selectedDate else { return "Chamados" }

        return calendar.isDateInToday(selectedDate)
            ? "Para Hoje"
            : selectedDate.formatted(
                .dateTime
                    .locale(locale)
                    .day()
                    .month(.wide)
                    .year()
            ).capitalized
    }
}
