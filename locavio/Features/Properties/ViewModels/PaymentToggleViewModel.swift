//
//  PaymentToggleViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 04/10/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class PaymentToggleViewModel {
    private let property: Property
    private let calendar: Calendar
    private let today: () -> Date
    
    /// Referência de "agora". Ao mudar, a view recalcula o toggle.
    private var now: Date
    
    init(
        property: Property,
        calendar: Calendar = .current,
        today: @escaping () -> Date = { Date() }
    ) {
        self.property = property
        self.calendar = calendar
        self.today = today
        self.now = today()
    }
    
    var title: String {
        "Aluguel pago?"
    }
    
    /// Pagamento do mês atual.
    var currentPayment: Payment? {
        property
            .payments(inMonthOf: now, calendar: calendar)
            .first
    }
    
    /// Estado do toggle: ligado somente se houver pagamento no mês atual.
    var isPaid: Bool {
        currentPayment != nil
    }
    
    /// Indica se o pagamento atual possui comprovante.
    var hasProof: Bool {
        currentPayment?.proof != nil
    }
    
    /// Nome automático do comprovante.
    var proofName: String {
        let propertyName = property.title ?? "Imovel"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let date = currentPayment?.date ?? now
        let formattedDate = formatter.string(from: date)
        
        return "\(propertyName)_\(formattedDate).pdf"
    }
    
    /// Data formatada para exibição.
    var proofDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let date = currentPayment?.date ?? now
        
        return formatter.string(from: date)
    }
    
    /// Chame quando o app voltar ao primeiro plano ou o dia mudar.
    func refresh() {
        now = today()
    }
    
    /// Liga: cria o pagamento do mês.
    /// Desliga: remove o pagamento do mês.
    func setPaid(_ paid: Bool, in context: ModelContext) {
        let current = property.payments(
            inMonthOf: now,
            calendar: calendar
        )
        
        if paid {
            guard current.isEmpty else { return }
            
            let payment = Payment(
                date: now,
                property: property,
                value: property.profit
            )
            
            context.insert(payment)
            
        } else {
            current.forEach {
                context.delete($0)
            }
        }
        
        try? context.save()
    }
    
    /// Salva o PDF no pagamento atual.
    /// Se já existir um comprovante, ele é substituído pelo novo.
    func saveProof(
        _ data: Data,
        in context: ModelContext
    ) {
        guard let payment = currentPayment else {
            return
        }
        
        payment.proof = data
        
        try? context.save()
    }
    
    /// Grava o PDF do comprovante num arquivo temporário para o QuickLook conseguir abrir.
    func makeProofPreviewURL() -> URL? {
        guard let data = currentPayment?.proof else {
            return nil
        }
        
        // tira caracteres que não podem estar num nome de arquivo (ex.: "/" no título do imóvel)
        let invalidCharacters = CharacterSet(charactersIn: "/\\:?%*|\"<>")
        let safeName = proofName
            .components(separatedBy: invalidCharacters)
            .joined(separator: "-")
        
        let url = URL.temporaryDirectory.appending(path: safeName)
        
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("Error when trying to generate proof preview: \(error)")
            return nil
        }
    }
}
