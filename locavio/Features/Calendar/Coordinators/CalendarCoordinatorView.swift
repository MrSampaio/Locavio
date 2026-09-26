//
//  CalendarCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct CalendarCoordinatorView: View {
    @State private var calendarCoordinator = CalendarCoordinator()
        
    var body: some View {
        NavigationStack(path: $calendarCoordinator.path) {
            CalendarView()
                .environment(calendarCoordinator)
        }
    }
}
