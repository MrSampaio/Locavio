//
//  DetailsInfoViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 30/09/26.
//

import Foundation
import SwiftUI
import UIKit

@Observable
final class PropertyDetailViewModel {
    private let property: Property
    private let calendar: Calendar
    private let today: () -> Date

    init(property: Property,
         calendar: Calendar = .current,
         today: @escaping () -> Date = { Date() }) {
        self.property = property
        self.calendar = calendar
        self.today = today
    }

    // Imagem

    var image: UIImage? {
        guard let data = property.image else { return nil }
        return UIImage(data: data)
    }

    var hasImage: Bool { image != nil }

    // Cabeçalho

    var typeBadge: TagBadgeItem? { property.typeBadge }

    var title: String {
        property.title?.trimmedOrNil ?? String(localized: "Sem título")
    }

    /// Ex.: "32 m²". `nil` quando a área não foi informada.
    var areaText: String? {
        guard let area = property.area else { return nil }
        return "\(area) m²"
    }

    /// Ex.: "Rua Ipê Amarelo, 55 - Santo Amaro - SP"
    var address: String {
        let streetPart = [property.street?.trimmedOrNil,
                          property.number.map { String($0) }] // Use a closure aqui
            .compactMap { $0 }
            .joined(separator: ", ")
        return streetPart
    }

    /// Ex.: "CEP: 12345-678"
    var cepText: String {
        guard let raw = property.cep?.trimmedOrNil else { return String(localized: "CEP não informado") }

        let digits = raw.filter(\.isNumber)
        guard digits.count == 8 else { return String(localized: "CEP: \(raw)") }

        let formattedCode = "\(digits.prefix(5))-\(digits.suffix(3))"
        return String(localized: "CEP: \(formattedCode)")
    }

    // Próximo pagamento

    var nextPaymentLabel: String { String(localized: "Próx. Pagamento:") }

    var nextPaymentText: String {
        guard let date = nextPaymentDate else { return "—" }
        return Self.dateFormatter.string(from: date)
    }

    // Inquilino

    var tenantSectionTitle: String { String(localized: "Inquilino") }

    var hasTenant: Bool { property.tenant != nil }

    var noTenantText: String { String(localized: "Nenhum locatário") }

    var tenantName: String? {
        let raw: String? = property.tenant?.name
        return raw?.trimmedOrNil
    }

    var tenantEmail: String? {
        let raw: String? = property.tenant?.email
        return raw?.trimmedOrNil
    }

    /// CPF formatado. Ex.: "123.456.789-01"
    var tenantCPF: String? {
        let raw: String? = property.tenant?.cpf
        guard let value = raw?.trimmedOrNil else { return nil }
        return Self.formatCPF(value)
    }

    var tenantPhone: String? {
        let raw: String? = property.tenant?.phone
        return raw?.trimmedOrNil
    }

    //  Helpers

    private var nextPaymentDate: Date? {
        guard let day = property.paymentDay, (1...31).contains(day) else { return nil }

        let startOfToday = calendar.startOfDay(for: today())

        for monthOffset in 0...1 {
            guard let month = calendar.date(byAdding: .month, value: monthOffset, to: startOfToday),
                  let range = calendar.range(of: .day, in: .month, for: month) else { continue }

            var comps = calendar.dateComponents([.year, .month], from: month)
            comps.day = min(day, range.count)

            if let candidate = calendar.date(from: comps), candidate >= startOfToday {
                return candidate
            }
        }
        return nil
    }

    private static func formatCPF(_ value: String) -> String {
        let digits = Array(value.filter(\.isNumber))
        guard digits.count == 11 else { return value }

        return "\(String(digits[0..<3])).\(String(digits[3..<6])).\(String(digits[6..<9]))-\(String(digits[9..<11]))"
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.setLocalizedDateFormatFromTemplate("yMd")
        return f
    }()
    

    //  Contrato

    /// Nome para o componente, que não aceita opcional.
    var contractDisplayName: String { contractName ?? String(localized: "Nenhum contrato anexado") }
    
    var contractSectionTitle: String { String(localized: "Contrato") }

    // Nome do arquivo do contrato. `nil` quando não há contrato.
    var contractName: String? {
        let raw: String? = property.contract?.fileName        
        return raw?.trimmedOrNil
    }

    var contractAttachmentDate: String {
        let date: Date? = property.contract?.createdAt
        guard let date else { return "—" }
        return Self.dateFormatter.string(from: date)
    }
    
        func makeContractPreviewURL() -> URL? {
        guard let data = property.contract?.pdfData else { return nil }

        let name = property.contract?.fileName ?? String(localized: "Contrato.pdf")
        let fileName = name.lowercased().hasSuffix(".pdf") ? name : name + ".pdf"
        let url = URL.temporaryDirectory.appending(path: fileName)

        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("Erro ao gerar preview do contrato: \(error)")
            return nil
        }
    }

    //Solicitações

    var requestsSectionTitle: String { String(localized: "Solicitações") }
    
    //ações
    var lastPaymentsButtonTitle: String { String(localized: "Últimos Pagamentos") }
    var deleteButtonTitle: String { String(localized: "Apagar imóvel") }
    var deleteAlertTitle: String { String(localized: "Apagar imóvel?") }
    var deleteAlertMessage: String {
        String(localized: "Essa ação não pode ser desfeita. Pagamentos, despesas e chamados deste imóvel também serão apagados.")
    }
}


private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
    
   
