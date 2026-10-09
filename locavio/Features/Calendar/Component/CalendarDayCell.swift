//
//  CalendarDayCell.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

import SwiftUI

struct CalendarDayCell: View {
   
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasTicket: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                ZStack {
                    if isSelected {
                        Circle().fill(Color(.accent))
                    } else if hasTicket {
                        Circle().fill(Color(.ticketDayBg).opacity(0.15))
                    }
                    if isToday {
                        Circle().fill(Color(.accent).opacity(0.15))
                    }
                }
                .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
            .accessibilityLabel(date.formatted(.dateTime.day().month(.wide).year()))
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
