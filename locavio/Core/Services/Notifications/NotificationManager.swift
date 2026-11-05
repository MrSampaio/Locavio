//
//  NotificationManager.swift
//  locavio
//
//  Created by Julio Sampaio on 11/10/26.
//

import Foundation
import UserNotifications
import SwiftData

final class NotificationManager: Sendable {
    
    static let shared = NotificationManager()
    private init() {}
    
    // solicita permissão do usuário para enviar notificações
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error when requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    // funcao que sincroniza todas as notificações baseadas nos dados atuais do SwiftData e preferências do dono
    func syncNotifications(properties: [Property], tickets: [Ticket], owner: Owner?) {
        let center = UNUserNotificationCenter.current()
        
        // limpa todas as notificações pendentes para recriá-las com os dados mais recentes
        center.removeAllPendingNotificationRequests()
        
        // verifica as preferências do usuário (se for nulo, assume true como padrão)
        let shouldNotifyRent = owner?.notifyDueDate ?? true
        let shouldNotifyTickets = owner?.notifyTickets ?? true
        
        if shouldNotifyRent {
            scheduleRentNotifications(properties: properties)
        }
        
        if shouldNotifyTickets {
            scheduleTicketNotifications(tickets: tickets)
        }
    }
    
    // notificações dos imóveis
    private func scheduleRentNotifications(properties: [Property]) {
        let calendar = Calendar.current
        let now = Date()
        
        for property in properties {
            // só notifica se estiver alugado e tiver dia de pagamento configurado
            guard property.tenant != nil,
                  let paymentDay = property.paymentDay,
                  let propertyName = property.title else { continue }
            
            // calcula a próxima data de vencimento
            guard let nextDueDate = calculateNextDueDate(paymentDay: paymentDay, from: now) else { continue }
            
            // verifica se o aluguel deste mês já foi pago. Se sim, não notifica.
            if property.isPaidInMonth(of: nextDueDate, calendar: calendar) {
                continue
            }
            
            // notificação de 1 dia antes
            if let oneDayBefore = calendar.date(byAdding: .day, value: -1, to: nextDueDate), oneDayBefore > now {
                scheduleNotification(
                    id: "rent_before_\(property.persistentModelID)",
                    title: String(localized: "Aluguel próximo ao vencimento"),
                    body: String(localized: "O aluguel do imóvel '\(propertyName)' vence amanhã."),
                    date: setHour(9, for: oneDayBefore) // 09:00 da manhã
                )
            }
            
            // notificação no dia do vencimento
            if nextDueDate > now {
                scheduleNotification(
                    id: "rent_day_\(property.persistentModelID)",
                    title: String(localized: "Vencimento do Aluguel"),
                    body: String(localized: "O aluguel do imóvel '\(propertyName)' vence hoje."),
                    date: setHour(9, for: nextDueDate)
                )
            }
        }
    }
    
    // notificações de chamados
    private func scheduleTicketNotifications(tickets: [Ticket]) {
        let calendar = Calendar.current
        let now = Date()
        
        for ticket in tickets {
            // só notifica se não estiver concluído e tiver data de conclusão
            guard ticket.isConcluded == false,
                  let conclusionDate = ticket.conclusionDate,
                  let ticketTitle = ticket.title else { continue }
            
            // notificação de 3 dias antes
            if let threeDaysBefore = calendar.date(byAdding: .day, value: -3, to: conclusionDate), threeDaysBefore > now {
                scheduleNotification(
                    id: "ticket_before_\(ticket.persistentModelID)",
                    title: String(localized: "Chamado prestes a vencer"),
                    body: String(localized: "O chamado '\(ticketTitle)' deve ser resolvido em 3 dias."),
                    date: setHour(10, for: threeDaysBefore) // 10:00 da manhã
                )
            }
            
            // notificação no dia do vencimento
            if conclusionDate > now {
                scheduleNotification(
                    id: "ticket_day_\(ticket.persistentModelID)",
                    title: String(localized: "Prazo final do Chamado"),
                    body: String(localized: "O prazo para concluir o chamado '\(ticketTitle)' é hoje."),
                    date: setHour(10, for: conclusionDate)
                )
            }
        }
    }
    
    // função que junta as informações e configura o gatilho
    private func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("ding-dong.caf"))
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error when trying to schedule notification (\(id)): \(error.localizedDescription)")
            }
        }
    }
    
    // calcula a próxima data
    private func calculateNextDueDate(paymentDay: Int, from date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // tenta criar a data para o mês atual
        var candidateComponents = components
        candidateComponents.day = paymentDay
        
        guard let candidateDate = calendar.date(from: candidateComponents) else { return nil }
        
        // se a data já passou, o próximo é no mês que vem
        if calendar.startOfDay(for: candidateDate) < calendar.startOfDay(for: date) {
            candidateComponents.month! += 1
            return calendar.date(from: candidateComponents)
        }
        
        return candidateDate
    }
    
    private func setHour(_ hour: Int, for date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    #warning("apaga essa função quando for mandar o target")
//    func testNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Testando notificação ☠️💀"
//        content.body = "Sente a pressão que agora vai com som"
//        content.sound = UNNotificationSound(named: UNNotificationSoundName("ding-dong.caf"))
//        
//        // Configura o gatilho para daqui a 5 segundos
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: "test_notification", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Erro no teste: \(error.localizedDescription)")
//            } else {
//                print("Notificação de teste agendada para 5 segundos!")
//            }
//        }
//    }
    
//    Button {
//        NotificationManager.shared.testNotification()
//    } label: {
//        Text("Testar Notificação (5s)")
//            .foregroundColor(.white)
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .cornerRadius(12)
//    }
//    .padding(.horizontal, 16)
}
