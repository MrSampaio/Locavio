//
//  CalendarDayCell.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

import SwiftUI

struct CalendarDayCell: View {
    @Environment(\.locale) private var locale
   
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasTicket: Bool
    let hasPayment: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                ZStack {
                    if isSelected {
                        Circle().fill(Color(.accent))
                    } else {
                        
                        if hasTicket {
                            Circle().fill(Color(.ticketDayBg).opacity(0.15))
                        }
                        if hasPayment {
                            Circle().fill(Color(.calendarBg).opacity(0.50))
                        }
                    }
                    if isToday {
                        Circle().fill(Color(.accent).opacity(0.15))
                    }
                }
                .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
            .accessibilityLabel(date.formatted(.dateTime.day().month(.wide).year().locale(locale)))
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
