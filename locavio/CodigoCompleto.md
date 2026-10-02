### Arquivo: \⁠ ./Core/Models/DocumentTypeModel.swift\ ⁠
⁠ swift
//
//  DocumentTypeModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

enum DocumentTypeModel: String, CaseIterable, Codable {
    
    // casos possíveis
    case pf = "PF"
    case pj = "PJ"
    
    // description passa a ser o nome extenso (aparece na lista aberta)
    var description: String {
        switch self {
            case .pf: return "Pessoa Física"
            case .pj: return "Pessoa Jurídica"
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/TicketModel.swift\ ⁠
⁠ swift
//
//  TicketModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData


enum TicketStats: String, Codable, CaseIterable{
    case completed = "Concluido"
    case open = "Aberto"
}

@Model
final class Ticket: Identifiable {
    var title: String?
    var ticketNumber: Int?
    var ticketDescription: String?
    var createdAt: Date?
    var conclusionDate: Date?
    var property: Property?

    @Relationship(deleteRule: .cascade, inverse: \Maintence.ticket)
    var maintence: [Maintence]?
    
    
    init(title: String? = nil, ticketNumber: Int? = nil, ticketDescription: String? = nil, createdAt: Date? = nil, conclusionDate: Date? = nil, property: Property? = nil, maintence: [Maintence]? = nil) {
        self.title = title
        self.ticketNumber = ticketNumber
        self.ticketDescription = ticketDescription
        self.createdAt = createdAt
        self.conclusionDate = conclusionDate
        self.property = property
        self.maintence = maintence
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/ExpensesModel.swift\ ⁠
⁠ swift
//
//  ExpensesModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Expenses: Identifiable {
    var property: Property?
    var title: String?
    var value: Double?
    var date: Date?
    
    init(
        property: Property? = nil,
        title: String? = nil,
        value: Double? = nil,
        date: Date? = nil
    ) {
        self.property = property
        self.title = title
        self.value = value
        self.date = date
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/PaymentModel.swift\ ⁠
⁠ swift
//
//  PaymentModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Payment: Identifiable{
    var date: Date?
    var property: Property?
    var value: Double?
    var proof: Data?
    
    init(date: Date? = nil, property: Property? = nil, value: Double? = nil, proof: Data? = nil) {
        self.date = date
        self.property = property
        self.value = value
        self.proof = proof
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/ContractModel.swift\ ⁠
⁠ swift
//
//  ContractModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Contract: Identifiable {
    var property: Property?
    var title: String?
    var fileName: String?
    var createdAt: Date?
    
    @Attribute(.externalStorage)
    var pdfData: Data?
    
    init(title: String? = nil, fileName: String? = nil, createdAt: Date? = nil, pdfData: Data? = nil) {
        self.title = title
        self.fileName = fileName
        self.createdAt = createdAt
        self.pdfData = pdfData
    }
    
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/TenantModel.swift\ ⁠
⁠ swift
//
//  TenantModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Tenant: Identifiable {
    var name: String?
    var email: String?
    var cpf: String?
    var phone: String?
    var property: Property?
    
    init(name: String? = nil, email: String? = nil, cpf: String? = nil, phone: String? = nil, property: Property? = nil) {
        self.name = name
        self.email = email
        self.cpf = cpf
        self.phone = phone
        self.property = property
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/PropertyModel.swift\ ⁠
⁠ swift
//
//  ScreenPropertyModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import Foundation
import SwiftData

enum PropertyType: String, Codable, CaseIterable{
    case home = "Casa"
    case apartment = "Apartamento"
    case kitnet = "Kitnet"
    case store = "Loja"
    case loft = "Loft"
    case warehouse = "Galpão"
    case studio = "Studio"
    case other = "Outro"
}

@Model
final class Property: Identifiable {
    var image: Data?
    var title: String?
    var type: PropertyType?
    var area: Int?
    var paymentDay: Int?
    var isPaid: Bool?
    var cep: String?
    var street: String?
    var neighborhood: String?
    var number: Int?
    var city: String?
    var uf: String?
    var profit: Double?
    var owner: Owner?

    
    @Relationship(deleteRule: .cascade, inverse: \Expenses.property)
    var expenses: [Expenses]?
    
    @Relationship(deleteRule: .cascade, inverse: \Tenant.property)
    var tenant: Tenant?
    
    @Relationship(deleteRule: .cascade, inverse: \Contract.property)
    var contract: Contract?
    
    @Relationship(deleteRule: .cascade, inverse: \Payment.property)
    var payments: [Payment]?
    
    // se excluir o imóvel, apaga os chamados junto
    @Relationship(deleteRule: .cascade, inverse: \Ticket.property)
    var tickets: [Ticket]?
    
//    @Relationship(deleteRule: .cascade, inverse: \Owner.property)

    
    init(image: Data? = nil, title: String? = nil, type: PropertyType? = nil, area: Int? = nil, paymentDay: Int? = nil, isPaid: Bool? = nil, cep: String? = nil, street: String? = nil, neighborhood: String? = nil, number: Int? = nil, city: String? = nil, uf: String? = nil, profit: Double? = nil, owner: Owner? = nil, expenses: [Expenses]? = nil, tenant: Tenant? = nil, contract: Contract? = nil, payments: [Payment]? = nil, tickets: [Ticket]? = nil) {
        self.image = image
        self.title = title
        self.type = type
        self.area = area
        self.paymentDay = paymentDay
        self.isPaid = isPaid
        self.cep = cep
        self.street = street
        self.neighborhood = neighborhood
        self.number = number
        self.city = city
        self.uf = uf
        self.profit = profit
        self.owner = owner
        self.expenses = expenses
        self.tenant = tenant
        self.contract = contract
        self.payments = payments
        self.tickets = tickets
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/MaintenceModel.swift\ ⁠
⁠ swift
//
//  MaintenceModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Maintence: Identifiable {
    var ticket: Ticket?
    var item: String?
    var value: Double?
    
    init(ticket: Ticket? = nil, item: String? = nil, value: Double? = nil) {
        self.ticket = ticket
        self.item = item
        self.value = value
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Models/SwiftData/OwnerModel.swift\ ⁠
⁠ swift
//
//  OwnerModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData


@Model
final class Owner: Identifiable {
    
    var appleUserID: String = ""
    var fullName: String?
    var email: String?
    var documentType: DocumentTypeModel?
    var documentNumber: String?
    var phone: String?
    var notifyPayments: Bool?
    var notifyDueDate: Bool?
    var notifyTickets: Bool?
    
    @Relationship(deleteRule: .cascade, inverse: \Property.owner)
    var properties: [Property]?
    
    
    init(appleUserID: String, fullName: String? = nil, email: String? = nil, documentType: DocumentTypeModel? = nil, documentNumber: String? = nil, phone: String? = nil, notifyPayments: Bool? = nil, notifyDueDate: Bool? = nil, notifyTickets: Bool? = nil, properties: [Property]? = nil) {
        self.appleUserID = appleUserID
        self.fullName = fullName
        self.email = email
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.phone = phone
        self.notifyPayments = notifyPayments
        self.notifyDueDate = notifyDueDate
        self.notifyTickets = notifyTickets
        self.properties = properties
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Extensions/Color+Hex.swift\ ⁠
⁠ swift
//
//  Color+Hex.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: ""))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Extensions/BadgeColor.swift\ ⁠
⁠ swift
//
//  BadgeColor.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//
import SwiftUI

struct TagBadgeItem: Identifiable {
    let text: String
    let color: Color
    var id: String { text }
}


enum BadgeColor {
    static let rented = Color("Badget01")
    static let propertyType = Color("Badget02")
    static let notRented = Color("Badget03")
    static let area = Color("Badget04")
}



//property
extension PropertyType {
    
    var badgeColor: Color { BadgeColor.propertyType }
}
 
extension Property {
    
    var tenantBadge: TagBadgeItem {
        tenant != nil
            ? TagBadgeItem(text: "Alugado", color: BadgeColor.rented)
            : TagBadgeItem(text: "Não alugado", color: BadgeColor.notRented)
    }
 
    
    var typeBadge: TagBadgeItem? {
        guard let type else { return nil }
        return TagBadgeItem(text: type.rawValue, color: type.badgeColor)
    }
 
    
    var areaBadge: TagBadgeItem? {
        guard let area else { return nil }
        return TagBadgeItem(text: "\(area)m²", color: BadgeColor.area)
    }
}

//ticket
extension TicketStats {
    var badgeText: String {
        switch self {
        case .open:      return "Aberto"
        case .completed: return "Concluído"
        }
    }
 
    var badgeColor: Color {
        switch self {
        case .open:return Color(.accent)
        case .completed: return Color(BadgeColor.rented)
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Extensions/String+CPFValidation.swift\ ⁠
⁠ swift
//
//  String+Validation.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation

extension String {
    
    /// Retorna verdadeiro se a string for um CPF matematicamente válido.
    var isValidCPF: Bool {
        // remove qualquer pontuação (pontos e traços) deixando só os números
        let numbers = self.filter { $0.isNumber }
        
        // verifica se tem exatamente 11 números
        guard numbers.count == 11 else { return false }
        
        // rejeita CPFs com todos os números iguais (ex: 111.111.111-11 passa na matemática, mas é falso)
        if Set(numbers).count == 1 { return false }
        
        // converte os caracteres para um array de inteiros
        let digits = numbers.compactMap { $0.wholeNumberValue }
        
        // cálculo do primeiro dígito verificador
        var sum1 = 0
        for i in 0..<9 {
            sum1 += digits[i] * (10 - i)
        }
        let digit1 = sum1 % 11 < 2 ? 0 : 11 - (sum1 % 11)
        
        // cálculo do segundo dígito verificador
        var sum2 = 0
        for i in 0..<10 {
            sum2 += digits[i] * (11 - i)
        }
        let digit2 = sum2 % 11 < 2 ? 0 : 11 - (sum2 % 11)
        
        // compara os dígitos calculados com os dígitos digitados
        return digits[9] == digit1 && digits[10] == digit2
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Extensions/String+CNPJValidation.swift\ ⁠
⁠ swift
//
//  String+CNPJValidation.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation

extension String {
    
    /// Retorna verdadeiro se a string for um CNPJ matematicamente válido.
    var isValidCNPJ: Bool {
        
        // remove pontuações
        let numbers = self.filter { $0.isNumber }
        
        // CNPJ precisa ter exatamente 14 números
        guard numbers.count == 14 else { return false }
        
        // rejeita CNPJs com todos os números iguais (ex: 00000000000000)
        if Set(numbers).count == 1 { return false }
        
        let digits = numbers.compactMap { $0.wholeNumberValue }
        
        // cálculo do primeiro dígito verificador
        let weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        var sum1 = 0
        for i in 0..<12 {
            sum1 += digits[i] * weights1[i]
        }
        let remainder1 = sum1 % 11
        let digit1 = remainder1 < 2 ? 0 : 11 - remainder1
        
        // cálculo do segundo dígito verificador
        let weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        var sum2 = 0
        for i in 0..<13 {
            sum2 += digits[i] * weights2[i]
        }
        let remainder2 = sum2 % 11
        let digit2 = remainder2 < 2 ? 0 : 11 - remainder2
        
        // compara os dígitos calculados com os digitados
        return digits[12] == digit1 && digits[13] == digit2
    }
}

 ⁠

---

### Arquivo: \⁠ ./Core/Components/MainTabView.swift\ ⁠
⁠ swift
//
//  MainTabView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Imóveis", systemImage: "house"){
                PropertiesCoordinatorView()
            }
            
            Tab("Perfil", systemImage: "person"){
                ProfileCoordinatorView()
            }
            
            
            
//            DashboardCoordinatorView()
//                .tabItem{
//                    Label("Relatório", systemImage: "chart.bar")
//                }
//            
//            CalendarCoordinatorView()
//                .tabItem{
//                    Label("Calendário", systemImage: "calendar")
//                }
//            
//            TicketsCoordinatorView()
//                .tabItem{
//                    Label("Chamados", systemImage: "exclamationmark.bubble")
//                }
        }
        
        
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/TipsText.swift\ ⁠
⁠ swift
//
//  TipsText.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI


struct TipsText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
    }
}


#Preview {
    TipsText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation")
}

    
       
 ⁠

---

### Arquivo: \⁠ ./Core/Components/DocumentTextField.swift\ ⁠
⁠ swift
//
//  DocumentInput.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct DocumentTextField: View {
    
    // binding para atualizar o texto do text field
    @Binding var text: String
    
    // recebe o tipo de documento
    var documentType: DocumentTypeModel
    
    // variáveis computadas para mudar o conteúdo do text field de acordo com a seleção
    private var labelTitle: String {
        documentType == .pf ? "CPF" : "CNPJ"
    }
    
    private var inputPlaceholder: String {
        documentType == .pf ? "Ex: 000.000.000-00" : "Ex: 00.000.000/0001-00"
    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "person.text.rectangle")
                .font(.title3)
                .foregroundColor(.accentColor)
            
            // texto dinâmico
            Text(labelTitle)
                .font(.body)
            
            Spacer()
            
            TextField(inputPlaceholder, text: $text)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad) // abre o teclado numérico
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
//        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    VStack(spacing: 20) {
        DocumentTextField(text: .constant(""), documentType: .pf)
        
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/Badges.swift\ ⁠
⁠ swift
//
//  Badges.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 30/09/26.
//

import SwiftUI

struct TagBadgeView: View {
    let text: String
    let color: Color

    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

    init(_ item: TagBadgeItem) {
        self.init(text: item.text, color: item.color)
    }

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .lineLimit(1)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(color, in: Capsule())
    }
}

#Preview {
    HStack {
        TagBadgeView(text: "Casa", color: .brown)
        TagBadgeView(text: "Aberto", color: .orange)
        TagBadgeView(text: "Concluído", color: .green)
    }
    .padding()
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/DocumentTypePicker.swift\ ⁠
⁠ swift
//
//  DocumentTypePicker.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct DocumentTypePicker: View {
    
    // @binding que recebe o enum de tipos de documento
    @Binding var selection: DocumentTypeModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 16){
                Image(systemName: "building.columns")
                    .font(.title3)
                    .foregroundColor(.accentColor)
                
                Text("Natureza Jurídica")
                    .font(.body)
                
                Spacer()
                
                Menu {
                    Picker(selection: $selection, label: Text("")) {
                        ForEach(DocumentTypeModel.allCases, id: \.self) { type in
                            // text extenso na lista aberta
                            Text(type.description).tag(type)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        // sigla quando está fechado
                        Text(selection.rawValue)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .tint(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            
        }
    }
}

#Preview {
    DocumentTypePicker(selection: .constant(.pf))
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/ComponentButton.swift\ ⁠
⁠ swift
//
//  ComponentButton.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 23/09/26.
//

import SwiftUI

struct ComponentButton: View {
    
    var textButton: String = "Continuar"
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(textButton)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.accent)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
        }
        .glassEffect()
        .buttonStyle(.plain)
    }
}

#Preview {
    ComponentButton(
        action: {}
    )
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/ErrorMessage.swift\ ⁠
⁠ swift
//
//  ErrorMessage.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation
import SwiftUI


struct ErrorMessage: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.red)
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    ErrorMessage(text: "Lorem ipsum dolor")
}
 ⁠

---

### Arquivo: \⁠ ./Core/Components/OptionToggle.swift\ ⁠
⁠ swift
//
//  RentPaidToggle.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 28/09/26.
//

import SwiftUI

struct OptionToggle: View {
    var text: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(text)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 20)
//        .padding(.vertical, 14)
//        .background(Color.gray.opacity(0.1))
        .tint(Color.accentColor)
//        .clipShape(
//            RoundedRectangle(cornerRadius: 20)
//        )

        // a caixa inteira é clicável
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}

#Preview {
    OptionToggle(text: "Toggle Text", isOn: .constant(true))
        .padding()
}
 ⁠

---

### Arquivo: \⁠ ./Core/ContentView.swift\ ⁠
⁠ swift
//
//  ContentView.swift
//  locavio
//
//  Created by Julio Sampaio on 18/09/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        
    }

    
}
 ⁠

---

### Arquivo: \⁠ ./Core/Services/KeychainHelper.swift\ ⁠
⁠ swift
//
//  KeychainHelper.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import Security

final class KeychainHelper: Sendable{
    
    // shared pra facilitar o acesso ao Keychain
    static let shared = KeychainHelper()

    private init() {}

    // bundle identifier pra evitar conflitos
    private let service = Bundle.main.bundleIdentifier ?? "com.locavio.login"
    
    // função de salvar
    func save(_ data: Data, for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        if updateStatus == errSecItemNotFound {
            var newItem = query
            newItem[kSecValueData as String] = data

            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            if addStatus != errSecSuccess {
                print("Error when trying to add into keychain: \(addStatus)")
            }
        } else if updateStatus != errSecSuccess {
            print("Error when trying to update data into keychain: \(updateStatus)")
        }
    }
    
    // função para ler o valores do keychain
    func read(for key: String) -> Data? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    // função para deletar os valores do keychain
    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound{
            print("Keychain delete failed \(status)")
        }
    }
    
    // funções de conveniência
    func save(_ value: String, for key: String){
        guard let data = value.data(using: .utf8) else { return }
        save(data, for: key)
    }
    
    func readString(for key: String) -> String? {
        guard let data = read(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Services/Auth/AppleAuthManager.swift\ ⁠
⁠ swift
//
//  AppleAuthManager.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import AuthenticationServices
import Security
import SwiftData

enum AppAuthState{
    case needsRegistration
    case authenticated
    case loggedOut
}

@Observable
final class AppleAuthManager{
    
    
//    var firtUse: Bool = false
    
    var currentAuthState: AppAuthState = .loggedOut
    
    // variável que controla autenticação do usuário
    var isAuthenticated: Bool = false
    
    // puxa o KeychainHelper pra simplificar a escrita
    let keychainHelper = KeychainHelper.shared
    
    init() {
        checkIfIsFirstLaunchAfterInstall()
    }
    
    // funçao para verificar se é o primeiro uso e se foi desinstalado
    private func checkIfIsFirstLaunchAfterInstall() {
        // verifica se a chave "hasLaunchedBefore" existe no UserDefaults
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunched {
            // se for false é pq o app acabou de ser instalado/reinstalado.
           
            // logout pra forçar o login
            logout()
            
            // marca como true para a próxima validação
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    func handleAuthorization(_ authorization: ASAuthorization){
        
        // guard let para converter a credencial para o tipo AppleIDCredential
        // essa credential vai ser a chave de identificação do usuário no sistema
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else{
            print("User invalid credentials")
            return
        }
        
        // o userID vai ser a chave de identificação do usuário no sistema
        let userID = credential.user
        
        // salva o userID no keychain pra maior segurançå
        keychainHelper.save(userID, for: "appleUserID")
        
        // tenta pegar o nome completo do usuário
        if let fullName = credential.fullName {
            let givenName = fullName.givenName ?? ""
            let familyName = fullName.familyName ?? ""
            
            // limpa o nome recebido
            let completeName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                
            // salva o nome no Keychain para maior segurança
            if !completeName.isEmpty {
                keychainHelper.save(completeName, for: "appleUserFullName")
            }
            // depois faz a lógica aqui pra salvar o nome do usuário
        }
        
        // tenta pegar o email do usuário
        if let userEmail = credential.email {
            keychainHelper.save(userEmail, for: "appleUserEmail")
        }
        
        // guard let para receber o tokenData. será utilizado nas validações
        // esse é o JWT que pod ser usado para validar a identidade do usuário
        guard let tokenData = credential.identityToken, let token = String(data: tokenData, encoding: .utf8) else {
            print("Error when trying to access tokenData")
            return
            
        }
        
        // guard let que recebe o código de autorização. vai ser usado como código único das validações
        guard let codeData = credential.authorizationCode, let code = String(data: codeData, encoding: .utf8) else{
            print("Error when trying to access codeData")
            return
        }
        
        currentAuthState = .needsRegistration
        
        // caso tudo tenha dado certo, seta o controle de autenticação para true
//        DispatchQueue.main.async {
//            self.currentAuthState = .needsRegistration
//        }
    }
    
    func checkCredentialStatus(context: ModelContext){
        
        // pega o ID do usuário salvo no Userdefaults
        guard let userID = keychainHelper.readString(for: "appleUserID") else {
            print("There is no user logged in Keychain storage.")
            DispatchQueue.main.async { self.isAuthenticated = false }
            return
        }
        
        let provider = ASAuthorizationAppleIDProvider()
        
        provider.getCredentialState(forUserID: userID){
            status, error in
            
            DispatchQueue.main.async{
                switch status{
                case.authorized:
                    print("User is authorized!")
                    self.isAuthenticated = true
                        
                        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
                        if let user = try? context.fetch(descriptor).first, let doc = user.documentNumber, !doc.isEmpty {
                            self.currentAuthState = .authenticated
                        } else {
                            self.currentAuthState = .needsRegistration
                        }
                        
//                        #warning("")
                    
                // importante: as infos precisam ser apagadas do Keychain caso o usuário tenha revogado o acesso do app aos seus dados
                case.revoked, .notFound, .transferred:
                print("User revoked access, not found or revoked")
                self.logout()

                @unknown default:
                    break
                }
            }
        }
    }
    
    func logout(){
        keychainHelper.delete(for: "appleUserID")
        keychainHelper.delete(for: "appleUserFullName")
        keychainHelper.delete(for: "appleUserEmail")
        
        currentAuthState = .loggedOut
    }
}
 ⁠

---

### Arquivo: \⁠ ./Core/Services/KeychainStorage.swift\ ⁠
⁠ swift
//
//  KeychainStorage.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

// o KeychainStorage vai ser um atalho para atribuir valores no Kechain do dispositivo
@propertyWrapper
struct KeychainStorage: DynamicProperty{
    
    // exige uma chave e puxa o atalho do KeychainHelper
    private let key: String
    private let helper = KeychainHelper.shared
    
    // por ser uma DynamicProperty, eu posso atribuir o @State pra dizer que pode haver atualização sempre que ocorrer algum evento pela struct
    @State private var value: String
    
    // inicia com os valores existentes. caso não tenha, seta os valores como vazio
    init(wrappedValue: String = "", _ key: String){
        self.key = key
        let existing = KeychainHelper.shared.readString(for: key)
        self._value = State(initialValue: existing ?? wrappedValue)
    }
    
    var wrappedValue: String{
        get{value}
        nonmutating set{
            value = newValue
            if(newValue.isEmpty){
                helper.delete(for: key)
            } else{
                helper.save(newValue, for: key)
            }
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./App/locavioApp.swift\ ⁠
⁠ swift
//
//  locavioApp.swift
//  locavio
//
//  Created by Julio Sampaio on 18/09/26.
//

import SwiftUI
import SwiftData
import AuthenticationServices

@main
struct locavioApp: App {
    @State private var appleAuthManager = AppleAuthManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Owner.self,
            Property.self,
            Tenant.self,
            Contract.self,
            Payment.self,
            Expenses.self,
            Ticket.self,
            Maintence.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                Group {
                    switch appleAuthManager.currentAuthState {
                        case .authenticated:
                            MainTabView()
                        case .needsRegistration:
                            SignUpView()
                        case .loggedOut:
                            LoginView()
                    }
                }
            }
            
            .environment(appleAuthManager)
            .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)){ _ in
                            print("Credential revoked in real time.")
                            appleAuthManager.logout() //vai alterar o isAuthenticated para false e a tela muda
                        }
                        .task {
                            appleAuthManager.checkCredentialStatus(context: sharedModelContainer.mainContext)
                        }

        }
        
        .modelContainer(sharedModelContainer)
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Tickets/Coordinators/TicketsCoordinatorView.swift\ ⁠
⁠ swift
//
//  TicketsCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

struct TicketsCoordinatorView: View {
    @State private var ticketsCoordinator = TicketsCoordinator()
        
    var body: some View {
        NavigationStack(path: $ticketsCoordinator.path) {
            TicketsView()
                .environment(ticketsCoordinator)
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Tickets/Coordinators/TicketsCoordinator.swift\ ⁠
⁠ swift
//
//  TicketsCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

@Observable
final class TicketsCoordinator{
    var path = NavigationPath()
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Tickets/Views/TicketsView.swift\ ⁠
⁠ swift
//
//  TicketsView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct TicketsView: View {
    var body: some View {
        Text("Tela de chamados")
    }
}

#Preview {
    TicketsView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Calendar/Coordinators/CalendarRoutes.swift\ ⁠
⁠ swift
//
//  CalendarRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
 ⁠

---

### Arquivo: \⁠ ./Features/Calendar/Coordinators/CalendarCoordinator.swift\ ⁠
⁠ swift
//
//  CalendarCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

@Observable
final class CalendarCoordinator{
    var path = NavigationPath()
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Calendar/Coordinators/CalendarCoordinatorView.swift\ ⁠
⁠ swift
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
 ⁠

---

### Arquivo: \⁠ ./Features/Calendar/Views/CalendarView.swift\ ⁠
⁠ swift
//
//  CalendarView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        Text("Tela de calendário")
    }
}

#Preview {
    CalendarView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/SignUp/ViewModels/SignUpViewModel.swift\ ⁠
⁠ swift
//
//  SignUpViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class SignUpViewModel {
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
    
    // variável computada que verifica em tempo real se o documento é válido
    var isValid: Bool {
        if selectedDocumentType == .pf {
            return documentNumber.isValidCPF
        } else {
            return documentNumber.isValidCNPJ
        }
    }
    
    // variável computada que contém mensagem de erro
    var errorMessage: String? {
        let justNumbers = documentNumber.filter { $0.isNumber }
        let expectedLength = selectedDocumentType == .pf ? 11 : 14
        
        // se já digitou todos os números e a matemática falhou, joga erro
        if justNumbers.count >= expectedLength && !isValid {
            return "Documento inválido."
        }
        
        // retorna nulo se o documento for válido ou se ele ainda tiver digitando
        return nil
    }
    
    func saveDocument(document: String, documentType: DocumentTypeModel, context: ModelContext, authManager: AppleAuthManager) {
        
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else {
            print("Error: User ID not found in Keychain Storage.")
            return
        }
        
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            if let user = try context.fetch(descriptor).first {
                
                // atualiza o usuário existente no banco com o documento e tipo
                user.documentNumber = document
                user.documentType = documentType
                
                // força o salvamento no banco local
                try context.save()
                
                // muda o estado global para que o app redirecione para a MainTabView
                DispatchQueue.main.async {
                    authManager.currentAuthState = .authenticated
                }
                
            } else {
                print("Error: User not found in database to add document")
            }
        } catch {
            print("Error when trying to fetch/save user into database: \(error)")
        }
    }
    
    
    
    // função que injeta a pontuação em tempo real baseada no Enum
    func applyDocumentMask(to text: String) -> String {
        let numbers = Array(text.filter { $0.isNumber })
        var result = ""
        var index = 0
        
        let mask = selectedDocumentType == .pf ? "###.###.###-##" : "##.###.###/####-##"
        
        for char in mask {
            // se os números acabaram, interrompe o loop
            if index >= numbers.count { break }
            
            if char == "#" {
                result.append(numbers[index])
                index += 1
            } else {
                result.append(char)
            }
        }
        
        return result
    }
    
    
    
    
    
    // função que verifica os documentos - ela puxa as extensões de String que validam CPF ou CNPJ e retorna um bool
//    func validateDocument() -> Bool{
//        if selectedDocumentType == .pf {
//            return documentNumber.isValidCPF
//        } else {
//            let justNumbers = documentNumber.filter { $0.isNumber }
//            return justNumbers.count == 14
//        }
//    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/SignUp/Views/Components/SignUpTitle.swift\ ⁠
⁠ swift
//
//  SignUpTitle.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

struct SignUpTitle: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        
        VStack(spacing: 12){
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.accentColor)
            
            Text(subtitle)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SignUpTitle(title: "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation")
}
 ⁠

---

### Arquivo: \⁠ ./Features/SignUp/Views/SignUpView.swift\ ⁠
⁠ swift
//
//  SignUpView.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI
import SwiftData


struct SignUpView: View {
    
    @State private var signUpViewModel = SignUpViewModel()
    
    // contexto do swift data
    @Environment(\.modelContext) private var context
    
    @Environment(AppleAuthManager.self) private var authManager

    var body: some View {
        ZStack{
            Color(UIColor.appBg)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 24){
                titleSection
                documentSection
            }
            .background(Color(.appBg))
        }
        
    }
    
    @ViewBuilder
    private var titleSection: some View{
        HStack(){
            SignUpTitle(title: "Informações Pessoais", subtitle: "Precisamos de algumas informações para configurar seu perfil. Você poderá revisar essas informações depois nas configurações da conta.")
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var documentSection: some View{
        VStack(alignment: .center, spacing: 12){
            VStack(spacing: 16){
                
                DocumentTypePicker(selection: $signUpViewModel.selectedDocumentType)
                
                Divider()
                    .padding(.horizontal, 50)
                
                DocumentTextField(text: $signUpViewModel.documentNumber, documentType: signUpViewModel.selectedDocumentType)
            }

            .padding(16)
            .background(Color(.bgForm))
            .overlay(
                RoundedRectangle(cornerRadius: 34)
                    .stroke(signUpViewModel.errorMessage != nil ? .red : .clear, lineWidth: 1.5)
            )
            .cornerRadius(34)
            .padding(.horizontal, 24)
            .onChange(of: signUpViewModel.documentNumber) { oldValue, newValue in
                // adiciona máscara de formatação de acordo com o tipo de documento
                let maskedText = signUpViewModel.applyDocumentMask(to: newValue)
                
                if signUpViewModel.documentNumber != maskedText {
                    signUpViewModel.documentNumber = maskedText
                }
            }
            
            .onChange(of: signUpViewModel.selectedDocumentType) { oldValue, newValue in
                
                signUpViewModel.documentNumber = ""
            }
            
            if var errorText = signUpViewModel.errorMessage {
                ErrorMessage(text: errorText)
            }
            
            VStack(alignment: .center){
                TipsText(text: "Utilizamos seu documento exclusivamente para sua identificação e ele não será compartilhado com outros usuários.")
                
                ComponentButton(
                    textButton: "Começar",
                    action: {
                        // passa as informações necessárias e o authManager
                        signUpViewModel.saveDocument(
                            document: signUpViewModel.documentNumber,
                            documentType: signUpViewModel.selectedDocumentType,
                            context: context,
                            authManager: authManager
                        )
                    }
                )
                    .padding(.horizontal, 65)
                    .disabled(!signUpViewModel.isValid)

            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 24)
        
        // se descomentar, vai travar
        .background(.bgBox, in: RoundedRectangle(cornerRadius: 38))
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 38))
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignUpView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/Coordinators/DashboardRoutes.swift\ ⁠
⁠ swift
//
//  DashboardRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/Coordinators/DashboardCoordinatorView.swift\ ⁠
⁠ swift
//
//  DashboardCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

struct DashboardCoordinatorView: View {
    @State private var dashboardCoordinator = DashboardCoordinator()
        
    var body: some View {
        NavigationStack(path: $dashboardCoordinator.path) {
            DashboardView()
                .environment(dashboardCoordinator)
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/Coordinators/DashboardCoordinator.swift\ ⁠
⁠ swift
//
//  DashboardCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

@Observable
final class DashboardCoordinator{
    var path = NavigationPath()
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/ViewModels/DatedValue.swift\ ⁠
⁠ swift
//
//  DatedValue.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

protocol DatedValue {
    var date: Date? { get }
    var value: Double? { get }
}

extension Payment: DatedValue {}
extension Expenses: DatedValue {}
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/ViewModels/DashboardViewModel.swift\ ⁠
⁠ swift
//
//  DashboardViewModel.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import Foundation

@Observable
class DashboardViewModel {
    
    func sumTotal<T: DatedValue> (items: [T], dashPeriod: DashboardPeriod) -> Double {
        let startDate: Date = getStartDay(period: dashPeriod) ?? Date.now
        let endDate = Date.now
        
        let filteredItems = filterByRangeOfDate(items: items, startDate: startDate, endDate: endDate)
        
        var sum: Double = 0.0
        
        let itemsToSum: [Double] = filteredItems.map{ $0.value ?? 0 }
        
        for item in itemsToSum {
            sum += item
        }
        
        return sum
    }
    
    func countReceivedRent(properties: [Property]) -> Int {
        let propertiesRentReceived: [Property] = properties.filter { $0.isPaid == true }
        
        return propertiesRentReceived.count
    }
    
    func countNotReceivedRent(properties: [Property]) -> Int {
        let propertiesNotReceivedRent: [Property] = properties.filter { $0.isPaid == false }
        
        return propertiesNotReceivedRent.count
    }
    
    func getStartDay(period: DashboardPeriod) -> Date? {
        var startPeriodValue = 0
        let periodType: Calendar.Component
        
        switch period {
        case .oneMonth:
            startPeriodValue = 1
            periodType = .month
        case .sixMonths:
            startPeriodValue = 6
            periodType = .month
        case .oneYear:
            startPeriodValue = 1
            periodType = .year
        }
        
        return Calendar.current.date(byAdding: periodType, value: -startPeriodValue, to: .now)
    }
    
    func filterByRangeOfDate<T: DatedValue>(items: [T], startDate: Date, endDate: Date) -> [T] {
        
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        guard let endNextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) else { return [] }
        
        let interval = DateInterval(start: start, end: endNextDay)
        
        return items.filter {
            guard let itemDate = $0.date else { return false }
            return interval.contains(itemDate)
        }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Dashboard/Views/DashboardView.swift\ ⁠
⁠ swift
//
//  DashboardView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

enum DashboardPeriod: String, CaseIterable, Identifiable {
    case oneMonth = "1 mês"
    case sixMonths = "6 meses"
    case oneYear = "1 ano"
    
    var id: Self { self }
}

enum SegmentedDashboard: String, CaseIterable, Identifiable {
    case profits = "Lucro"
    case expenses = "Despesa"
    
    var id: Self { self }
}

struct DashboardView: View {
    
    @State private var currentFilter: SegmentedDashboard = .profits
    
    var body: some View {
        ZStack {
            Color.appBg
                .ignoresSafeArea()
            
            VStack {
                Picker("Filtro", selection: $currentFilter) {
                    ForEach(SegmentedDashboard.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            
            
        }
    }
}

#Preview {
    DashboardView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Coordinators/ProfileCoordinatorView.swift\ ⁠
⁠ swift
//
//  ProfileCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileCoordinatorView: View {
    @State private var profileCoordinator = ProfileCoordinator()
    
    var body: some View {
        NavigationStack(path: $profileCoordinator.path) {
            ProfileView()
                .environment(profileCoordinator)
            
            // roteador de pilha
            .navigationDestination(for: ProfileRoutes.self) { route in
                switch route {
                    case .terms:
                        TermsOfUseView()
                    case .privacy:
                        PrivacyPolicyView()
                }
            }
        }
    }
}

//struct PropertiesCoordinatorView: View {
//
//    @State private var propertiesCoordinator = PropertiesCoordinator()
//    @State private var propertiesViewModel = PropertiesViewModel()
//    
//    
//    var body: some View {
//        NavigationStack(path: $propertiesCoordinator.path) {
//            
//            // puxa a tela inicial
//            PropertiesView()
//                .environment(propertiesCoordinator)
//                .environment(propertiesViewModel)
//            
//            // roteador de pilha
//                .navigationDestination(for: PropertiesRoute.self) { route in
//                    switch route {
//                        case .details(let id):
//                            // PropertyDetailsView(propertyId: id)
//                            Text("Detalhes do imóvel \(id)")
//                            
//                        case .newProperty:
//                            NewPropertyView()
//                    }
//                    }
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Coordinators/ProfileCoordinator.swift\ ⁠
⁠ swift
//
//  ProfileCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

@Observable
final class ProfileCoordinator {
    
    var path = NavigationPath()
    
    // controle das sheets
    var activeSheet: ProfileSheet?
    
    // navegação em pilha
    func pushToTerms() {
        path.append(ProfileRoutes.terms)
    }
    
    func pushToPrivacy() {
        path.append(ProfileRoutes.privacy)
    }
    
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
    func presentEditProfile() {
        activeSheet = .editProfileSheet
    }
    
    func dismissSheet() {
        activeSheet = nil
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Coordinators/ProfileRoutes.swift\ ⁠
⁠ swift
//
//  ProfileRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation


enum ProfileRoutes{
    case terms
    case privacy
}

enum ProfileSheet{
    case editProfileSheet
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/ViewModels/ProfileViewModel.swift\ ⁠
⁠ swift
//
//  ProfileViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

@Observable
final class ProfileViewModel{
    
    var notifyPayments: Bool = true
    var notifyPendentPayments: Bool = true
    var notifyTickets: Bool = true
    
    // função que mascara o documento para não ser completamente exibido na tela de perfil
    func maskDocument(_ document: String) -> String {
        let numbers = document.filter { $0.isNumber }
        
        // máscara de CPF
        if numbers.count == 11 {
            
            let start = numbers.prefix(3)
            let end = numbers.suffix(2)
            return "•••.\(start).•••-\(end)"
            
        // máscara de CNPJ
        } else if numbers.count == 14 {
            
            let start = numbers.prefix(2)
            let end = numbers.suffix(2)
            return "••.•••.•••/••••-\(end)"
            
        }
        return "Documento Inválido"
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/ProfileView.swift\ ⁠
⁠ swift
//
//  ProfileView.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI
import SwiftData

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @Environment(ProfileCoordinator.self) private var coordinator
    
    @Query private var users: [Owner]
    
    private var user: Owner? {
        users.first
    }
    
    
    // futuras queries
    //    @Query private var userProfiles: [UserProfile]
    //    @Query private var properties: [Property]
    //    @Query private var tenants: [Tenant]
    
    var body: some View {
        ZStack{
            Color(UIColor.appBg)
                .ignoresSafeArea()

            
                ScrollView(){
                    VStack(spacing: 24){
                        profileHeader
                        notificationSettings
                        legalSection
                }
            }
            
                .padding(.bottom, 14)
            
        }
        
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ProfileToolbar(onClick: {})
        }

        
    }
    
    @ViewBuilder
    var profileHeader: some View {
        
        // extrai o documento
        let rawDoc = user?.documentNumber ?? ""
        
        let maskedString = rawDoc.isEmpty ? "***.***.***-**" : viewModel.maskDocument(rawDoc)
        
        #warning("Adicionar lógica de numeros de inquilinos")
        
        VStack(alignment: .center){
            ProfileHeader(
                userImage: nil,
                userName: "\(user?.fullName ?? "Proprietário")",
                maskedDocument: "CPF: \(maskedString)",
                numberOfProperties: user?.properties?.count ?? 0,
                numberOfTenants: 5
            )
        }
    }
    
    @ViewBuilder
    var notificationSettings: some View {
        VStack(spacing: 0) {
            OptionToggle(text: "Notificar Pagamentos", isOn: $viewModel.notifyPayments)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 16)
            
            OptionToggle(text: "Notificar Vencimentos", isOn: $viewModel.notifyPendentPayments)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
            Divider()
                .padding(.leading, 16)
            
            OptionToggle(text: "Notificar Chamados", isOn: $viewModel.notifyTickets)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
        .background(Color(.bgBox))
        .cornerRadius(24)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var legalSection: some View {
        VStack(spacing: 0) {
            LegalOption(
                text: "Termos de uso",
                icon: "text.page.fill",
                action: coordinator.pushToTerms
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            LegalOption(
                text: "Política de privacidade",
                icon: "lock.fill",
                action: coordinator.pushToPrivacy
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color(.bgBox))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileView()
        .environment(ProfileCoordinator())
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/Components/ListCardComponent.swift\ ⁠
⁠ swift
//
//  ListCardComponent.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 29/09/26.
//

import SwiftUI

struct ListCardComponent: View {
    
    let textList: String
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(textList))
                .font(.caption2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.listCard, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.listStrokeCard, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    
    let textList = """
        • Nome e sobrenome
        • E-mail
        • Endereço, Estado, Província, CEP, Cidade
        • Dados dos imóveis cadastrados (endereço, características, fotos)
        • Dados de contratos de locação e valores de aluguel
        • Solicitações de manutenção e histórico de comunicação sobre os imóveis
        • Dados de calendário/agenda relacionados aos imóveis
        • Documentos e fotos que você anexar ao Aplicativo (ex.: contratos, comprovantes)
        """
    
    ListCardComponent(textList: textList)
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/Components/ProfileHeader.swift\ ⁠
⁠ swift
//
//  ProfileHeader.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

struct ProfileHeader: View {
    
    let userImage: Data?
    let userName: String
    let maskedDocument: String
    let numberOfProperties: Int
    let numberOfTenants: Int
    
    var body: some View {
        VStack(spacing: 16){
            
            if let imageData = userImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else{
                Image("DefaultUser")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
           
            
            VStack(spacing: 4){
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // outra bola: ●
                Text(maskedDocument)
            }
            
            HStack(spacing: 12){
                Text("\(String(numberOfProperties)) imóveis")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .padding(10)
                    .background(Color(.badget01))
                    .cornerRadius(40)
                
                Text("\(String(numberOfTenants)) inquilinos")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .padding(10)
                    .background(Color(.badget02))
                    .cornerRadius(40)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileHeader(
        userImage: nil,
        userName: "Julis Sampaio",
        maskedDocument: "•••.123.•••-••",
        numberOfProperties: 5,
        numberOfTenants: 3
    )
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/Components/LegalOption.swift\ ⁠
⁠ swift
//
//  LegalOption.swift
//  locavio
//
//  Created by Julio Sampaio on 01/10/26.
//

import Foundation
import SwiftUI

struct LegalOption: View {
    
    var text: String
    var icon: String
    let action: () -> Void
    
    var body: some View {
        
        
        Button(action: action) {
            HStack{
                Image(systemName: icon)
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: 28))
                
                Text(text)
                    .font(.body)
                    .fontWeight(.regular)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(Color.secondary)
                    .fontWeight(.semibold)
            }
            
        }
        .foregroundColor(Color.primary)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    LegalOption(
        text: "Lorem ipsum",
        icon: "document.fill",
        action: {}
    )
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/Components/ProfileToolbar.swift\ ⁠
⁠ swift
//
//  ProfileToolbar.swift
//  locavio
//
//  Created by Julio Sampaio on 29/09/26.
//

import Foundation
import SwiftUI

struct ProfileToolbar: ToolbarContent {
    var onClick: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onClick) {
                Image(systemName: "square.and.pencil")
            }
        }
        
        
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/TermsOfUse.swift\ ⁠
⁠ swift
//
//  TermsOfUse.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 30/09/26.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ZStack {
            
            Color.appBg
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Estes termos e condições aplicam-se ao aplicativo Locavio para dispositivos móveis, juntamente com quaisquer serviços relacionados operados pelo Locavio (coletivamente, o \"Aplicativo\"). O Locavio é aqui referido como o \"Provedor de Serviços\".")
                    
                    Text("Ao baixar ou usar o Aplicativo, você concorda com estes Termos e Condições. Você deve lê-los cuidadosamente antes de usar o Aplicativo.")
                    
                    sectionTitle("1. Licença de uso do Aplicativo")
                    
                    Text("Sujeito ao seu cumprimento destes Termos, o Provedor de Serviços concede a você uma licença limitada, não exclusiva, intransferível e revogável para instalar e usar o Aplicativo em um dispositivo móvel para fins pessoais ou comerciais internos. Você não pode reproduzir, distribuir, modificar, criar trabalhos derivados, fazer engenharia reversa, descompilar ou desmontar o Aplicativo, exceto e apenas na medida em que tal atividade seja expressamente permitida pela lei aplicável.")
                    
                    Text("Esta licença restringe-se ao uso do Aplicativo exclusivamente em dispositivos com sistemas operacionais iOS (produtos da marca Apple) que o Utilizador possua ou controle legitimamente, e em estrita observância com as Regras de Uso delineadas nos Termos de Serviço da Apple Media Services.")
                    
                    sectionTitle("2. Propriedade Intelectual")
                    
                    Text("O Provedor de Serviços retém todos os direitos de propriedade intelectual sobre o Aplicativo, incluindo seu código, design, marcas registradas, marcas de serviço, nomes comerciais, logotipos e identidade visual (a \"PI\"). Nada nestes Termos concede a você qualquer licença ou direito de usar as marcas registradas, logotipos ou identidade visual do Provedor de Serviços para qualquer finalidade. Você concorda em não remover, alterar ou ocultar quaisquer avisos de direitos autorais, marcas registradas ou outros avisos de propriedade exibidos no ou dentro do Aplicativo.")
                    
                    sectionTitle("3. Rescisão")
                    
                    Text("O Provedor de Serviços pode suspender seu acesso ao Aplicativo ou aos serviços se você violar materialmente estes Termos. O Provedor de Serviços fornecerá um aviso por escrito sobre a violação.")
                    
                    Text("O Provedor de Serviços pode suspender ou rescindir seu acesso imediatamente sem aviso prévio se você violar a lei aplicável, infringir direitos de propriedade intelectual ou se envolver em atividades que possam causar danos a outros usuários ou ao Provedor de Serviços.")
                    
                    Text("Após a rescisão, seu direito de usar o Aplicativo terminará e você deverá excluir todas as cópias de seus dispositivos.")
                    
                    Text("Ao acessar e usar este Aplicativo, você declara que tem permissão legal para usá-lo em sua jurisdição. Você deve ter pelo menos 18 anos de idade (a idade de consentimento digital em sua jurisdição) para usar \no Aplicativo.")
                    
                    Text("A cópia não autorizada, modificação do Aplicativo, qualquer parte do Aplicativo ou das marcas registradas do Provedor de Serviços é estritamente proibida. Quaisquer tentativas de extrair o código-fonte do Aplicativo, traduzir o Aplicativo para outros idiomas ou criar versões derivadas não são permitidas. Todas as marcas registradas, direitos autorais, direitos de banco de dados e outros direitos de propriedade intelectual relacionados ao Aplicativo permanecem como propriedade do Provedor de Serviços.")
                    
                    Text("O Utilizador detém a autonomia plena para solicitar a exclusão definitiva da sua conta a qualquer momento, funcionalidade que se encontra disponível nativamente nas configurações do Aplicativo. A confirmação da exclusão de conta engatilhará, por intermédio da API da Apple, a revogação automática dos tokens de acesso e de atualização associados à autenticação do Utilizador. Simultaneamente, será iniciado o expurgo definitivo de todos os dados do banco de dados relacional e arquivos em nuvem (como perfis de propriedades, cadastros de inquilinos, relatórios de despesas, contratos anexados e fotografias de vistorias), excetuando-se apenas os registros de acesso que devem ser mantidos, sob sigilo, pelo prazo obrigatório de seis meses para cumprimento do Marco Civil da Internet (Lei nº 12.965/2014).")
                    
                    sectionTitle("4. Conteúdo Gerado pelo Usuário e Uso Aceitável")
                    
                    Text("Se este Aplicativo permitir que os usuários publiquem, compartilhem ou façam upload de conteúdo, você concorda em não publicar conteúdo que:")
                    
                    ListCardComponent(textList: prohibitedContent)
                    
                    Text("O Provedor de Serviços reserva-se o direito de:")
                    
                    ListCardComponent(textList: providerRights)
                    
                    Text("Se você acredita que um conteúdo viola estes Termos, infringe seus direitos ou é ilegal, você pode denunciá-lo ao Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com). A denúncia deve incluir informações suficientes para que o Provedor de Serviços identifique o conteúdo, avalie a reclamação e entre em contato com você caso seja necessário acompanhamento.")
                    
                    Text("O Provedor de Serviços pode revisar o conteúdo denunciado, solicitar informações adicionais quando necessário, remover ou restringir o acesso ao conteúdo e tomar medidas contra a conta responsável quando apropriado. Os usuários afetados por decisões de moderação podem entrar em contato com o Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com) para solicitar uma revisão adicional. O Provedor de Serviços responderá às apelações dentro de um período razoável e fornecerá os motivos para qualquer decisão de moderação mantida, sujeito à lei aplicável.")
                    
                    Text("Ao enviar Conteúdo Gerado pelo Usuário, você concede ao Provedor de Serviços uma licença mundial, isenta de royalties e não exclusiva para usar, reproduzir, distribuir, preparar trabalhos derivados, exibir e executar o conteúdo em conexão com o Aplicativo e os negócios do Provedor de Serviços. Esta licença não concede ao Provedor de Serviços o direito de vender ou sublicenciar seu conteúdo a terceiros de forma independente do Aplicativo. Você declara e garante que possui ou controla todos os direitos sobre o conteúdo que publica e que o uso do conteúdo não viola estes Termos ou a lei aplicável.")
                    
                    Text("Seu conteúdo pode incluir dados pessoais. O processamento de dados pessoais relacionados ao Conteúdo Gerado pelo Usuário é regido pela Política de Privacidade. Não publique dados pessoais de terceiros sem o consentimento deles.")
                    
                    Text("O Aplicativo armazena e processa dados pessoais que você forneceu ao Provedor de Serviços para prestar o Serviço. É sua responsabilidade manter a segurança de seu dispositivo móvel e o acesso ao Aplicativo.")
                    
                    Text("O Provedor de Serviços aconselha expressamente que você não faça jailbreak ou root em seu dispositivo móvel, o que envolve a remoção de restrições e limitações de software impostas pelo sistema operacional oficial de seu dispositivo móvel. Tais ações podem expor seu dispositivo móvel a malwares, vírus e programas maliciosos, comprometer os recursos de segurança de seu dispositivo e podem resultar no funcionamento incorreto ou na inoperabilidade total do Aplicativo.")
                    
                    Text("Fazer o jailbreak ou manipular o sistema operacional base compromete a criptografia local do dispositivo, podendo resultar na corrupção irremediável de chaves de autenticação e na exposição indevida dos dados contratuais armazenados a agentes maliciosos, o que isenta o Locavio de qualquer responsabilidade por incidentes de segurança cibernética.")
                    
                    Text("Esteja ciente de que o Provedor de Serviços não assume responsabilidade por certos aspectos. Algumas funções do Aplicativo exigem uma conexão ativa com a internet, que pode ser via Wi-Fi ou fornecida por sua operadora de rede móvel. O Provedor de Serviços não pode ser responsabilizado se o Aplicativo não funcionar em sua capacidade total devido à falta de acesso a uma rede Wi-Fi ou se o seu pacote de dados houver esgotado.")
                    
                    Text("Se você estiver usando o aplicativo fora de uma área com Wi-Fi, lembre-se de que os termos do contrato de sua operadora de rede móvel ainda se aplicam. Consequentemente, você pode ser cobrado por sua operadora móvel pelo uso de dados durante a conexão com o aplicativo, ou por outras cobranças de terceiros. Ao usar o aplicativo, você aceita a responsabilidade por tais cobranças, incluindo tarifas de roaming de dados, caso use o aplicativo fora de seu território de origem (ou seja, região ou país) sem desativar o roaming de dados. Se você não for o pagador da fatura do dispositivo no qual está usando o aplicativo, eles presumem que você obteve permissão \ndo pagador.")
                    
                    Text("Da mesma forma, o Provedor de Serviços não pode assumir responsabilidade pelo seu uso do aplicativo em todas as situações. Por exemplo, é sua responsabilidade garantir que seu dispositivo permaneça carregado. Se a bateria do seu dispositivo acabar e você não puder acessar o Serviço, o Provedor de Serviços não poderá \nser responsabilizado.")
                    
                    Text("Nada nestes Termos limitará quaisquer direitos que você tenha sob as leis de proteção ao consumidor aplicáveis que não possam ser legalmente excluídos.")
                    
                    Text("O preenchimento automático de endereços de propriedades imobiliárias é potencializado pela integração técnica com a API pública ViaCEP. O Aplicativo transmite exclusivamente o código numérico do CEP a esta API externa para resguardar a privacidade, fundindo a informação genérica com os dados sensíveis do imóvel apenas posteriormente e de forma encriptada. O Utilizador isenta o Locavio de responsabilidade por preenchimentos incorretos ou interrupções no cadastro de imóveis decorrentes de instabilidades no serviço ViaCEP ou na conectividade mantida por terceiros.")
                    
                    sectionTitle("5. Limitação de Responsabilidade")
                    
                    Text("Na extensão máxima permitida por lei, o Provedor de Serviços não será responsável por quaisquer danos indiretos, incidentais, especiais, consequenciais ou punitivos, incluindo, mas não se limitando a, lucros cessantes, perda de dados ou interrupção de negócios, mesmo que avisado da possibilidade de tais danos.")
                    
                    Text("Além disso, o Provedor de Serviços não contém nenhuma responsabilidade por:")
                    
                    ListCardComponent(textList: liabilityExclusions)
                    
                    Text("O Provedor de Serviços não aceita qualquer responsabilidade por qualquer perda, direta ou indireta, que você venha a sofrer como resultado de confiar inteiramente em informações de terceiros fornecidas por meio deste Aplicativo, ou por imprecisões no conteúdo fornecido por terceiros.")
                    
                    Text("O Locavio assume a responsabilidade total pelo fornecimento de serviços de manutenção e suporte técnico referentes ao Aplicativo. O Utilizador e o Locavio reconhecem que a Apple não tem, sob nenhuma circunstância, qualquer obrigação de fornecer serviços de manutenção e suporte técnico relacionados ao Aplicativo, nem qualquer outra obrigação de garantia. Na extensão máxima permitida pela lei aplicável, recai inteiramente sobre o Locavio a responsabilidade por reivindicações, falhas de sistema e proteção ao consumidor. Em caso de alegações de terceiros de que o aplicativo infringe direitos de propriedade intelectual, a investigação, defesa e liquidação de tais reivindicações são de exclusiva responsabilidade do Locavio, e não da Apple.")
                    
                    sectionTitle("6. Indenização")
                    
                    Text("Na extensão máxima permitida por lei, você concorda em indenizar e isentar o Provedor de Serviços, suas afiliadas, diretores, conselheiros, funcionários e agentes de e contra quaisquer reclamações, responsabilidades, danos, perdas e despesas, incluindo honorários advocatícios razoáveis, decorrentes de ou diretamente relacionados à sua violação destes Termos ou ao seu uso indevido intencional do Aplicativo, incluindo Conteúdo Gerado pelo Usuário que você enviar em violação a estes Termos.")
                    
                    Text("Esta indenização não se aplica a reclamações decorrentes da própria negligência do Provedor de Serviços, violação destes Termos ou violação da lei aplicável. Em jurisdições onde a indenização por parte do consumidor é restrita por lei, esta cláusula será limitada à extensão \nmáxima permitida.")
                    
                    sectionTitle("7. Atualizações do Aplicativo")
                    
                    Text("O Provedor de Serviços pode desejar atualizar o aplicativo em algum momento. O aplicativo está atualmente disponível de acordo com os requisitos do sistema operacional (e de quaisquer sistemas adicionais para os quais eles decidam estender a disponibilidade do aplicativo), que podem mudar, e você precisará baixar as atualizações se quiser continuar usando o aplicativo. O Provedor de Serviços não garante que sempre atualizará o aplicativo para que ele continue relevante para você e/ou compatível com a versão específica do sistema operacional instalada em seu dispositivo. Você deve aceitar as atualizações quando forem oferecidas; caso decida não as aceitar, o Provedor de Serviços poderá deixar de oferecer suporte a versões anteriores e o Aplicativo poderá não funcionar adequadamente. O Provedor de Serviços também pode desejar parar de fornecer o aplicativo e pode encerrar o seu uso a qualquer momento sem fornecer aviso de rescisão a você. A menos que informem o contrário, mediante qualquer rescisão, (a) os direitos e licenças concedidos a você nestes termos terminarão; (b) você deve parar de usar o aplicativo e (se necessário) excluí-lo de seu dispositivo.")
                    
                    sectionTitle("8. Lei Aplicável e Jurisdição")
                    
                    Text("Estes Termos e Condições são submetidos exclusivamente à legislação da República Federativa do Brasil, em especial à Lei Geral de Proteção de Dados Pessoais (LGPD - Lei nº 13.709/2018) e ao Marco Civil da Internet \n(Lei nº 12.965/2014).")
                    
                    Text("Qualquer litígio decorrente de ou relacionado a estes Termos será submetido aos tribunais que tenham jurisdição sob a lei aplicável, ficando desde logo eleito o foro do domicílio do Utilizador, sob a égide dos princípios protetivos do Código de Defesa do Consumidor, na medida do aplicável.")
                    
                    sectionTitle("9. Conformidade com a App Store e Posição da Apple")
                    
                    Text("O Utilizador e o Locavio reconhecem e acordam expressamente que este contrato é firmado única e exclusivamente entre as referidas partes, não configurando qualquer vínculo contratual com a Apple Inc. ou as suas subsidiárias (\"Apple\"). O Locavio, e não a Apple, é o único responsável pelo Aplicativo e pelo conteúdo nele inserido. O Utilizador e o Locavio reconhecem que a Apple e as suas subsidiárias são terceiros beneficiários destes Termos e que, mediante a aceitação do Utilizador, a Apple terá o direito legal de executar as disposições deste contrato diretamente contra o Utilizador, na qualidade de \nterceiro beneficiário.")
                    
                    sectionTitle("10. Regimes de Tratamento de Dados e Privacidade (LGPD)")
                    
                    Text("O processamento de dados dentro do Aplicativo cria papéis distintos de responsabilidade legal. O Locavio atua como Controlador de Dados exclusivamente no que se refere aos dados de cadastro do próprio proprietário do imóvel para a criação e manutenção da conta (como endereço de e-mail, nome e dados de assinatura in-app).")
                    
                    Text("No que tange aos dados dos inquilinos, contratos de locação digitalizados, recibos financeiros e fotos de vistorias inseridas no aplicativo, o Locavio atua estritamente como Operador tecnológico da infraestrutura. O Utilizador (proprietário do imóvel) assume integralmente a figura de Controlador destes dados perante os seus inquilinos, sendo o único responsável por possuir base legal válida (como a execução de contrato de locação) para cadastrar e processar essas informações sensíveis \nde terceiros.")
                    
                    Text("O Utilizador compromete-se a indenizar o Locavio contra quaisquer sanções, multas, ações judiciais ou autuações por parte da Autoridade Nacional de Proteção de Dados (ANPD) que sejam decorrentes do tratamento ilícito, abusivo ou desprovido de base legal dos dados de inquilinos e terceiros inseridos no Aplicativo pelo Utilizador.")
                    
                    sectionTitle("11. Independência das Disposições (Separabilidade)")
                    
                    Text("Se qualquer disposição destes Termos e Condições for considerada inválida, ilegal ou inexequível por um tribunal de jurisdição competente, tal disposição será modificada na medida mínima necessária para torná-la válida e exequível, e as demais disposições destes Termos permanecerão em pleno vigor e efeito.")
                    
                    sectionTitle("12. Acordo Integral")
                    
                    Text("Estes Termos e Condições, juntamente com a Política de Privacidade, constituem o acordo integral entre você e o Provedor de Serviços em relação ao seu uso do Aplicativo, substituindo quaisquer acordos ou \nentendimentos anteriores.")
                    
                    sectionTitle("13. Alterações nestes Termos e Condições")
                    
                    Text("O Provedor de Serviços pode atualizar seus Termos e Condições periodicamente. Portanto, é aconselhável que você analise esta página regularmente para verificar quaisquer alterações. O Provedor de Serviços o notificará sobre quaisquer alterações publicando os novos Termos e Condições nesta página.")
                    
                    Text("Versões anteriores destes Termos e Condições serão mantidas e disponibilizadas mediante solicitação, entrando em contato com o Provedor de Serviços \nem [jusampa2@gmail.com](mailto:jusampa2@gmail.com).")
                    
                    Text("Estes termos e condições entram em vigor a partir \nde 25-09-2026.")
                    
                    sectionTitle("14. Fale Conosco")
                    
                    Text("Se você tiver alguma dúvida ou sugestão sobre os Termos e Condições, não hesite em entrar em contato com o Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com).")
                }
                .font(.footnote)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Termos de Uso")
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.top, 8)
    }
    
    let prohibitedContent = """
    • Seja ilegal ou viole direitos de propriedade intelectual de terceiros (direitos autorais, marcas registradas, patentes)
    • Seja abusivo, ameaçador, assediador, difamatório ou discurso de ódio
    • Contenha discriminação ou incitação à violência ou a atividades ilegais
    • Seja spam, phishing ou contenha malware
    • Viole a privacidade ou os direitos de dados pessoais de terceiros
    • Seja enganoso, falso ou fraudulento
    • Contenha violência explícita ou conteúdo sexual
    """
    
    let providerRights = """
    • Remover ou desativar o acesso a conteúdo que viole estas diretrizes
    • Suspender ou encerrar as contas de usuários que violarem repetidamente estas diretrizes
    • Cooperar com as autoridades policiais caso conteúdo ilegal seja denunciado
    • Moderar, filtrar ou ocultar conteúdo que viole estes Termos, a lei aplicável ou as diretrizes estabelecidas acima
    """
    
    let liabilityExclusions = """
    • Morte ou lesão corporal causada por negligência
    • Fraude ou declaração falsa fraudulenta
    • Qualquer outra responsabilidade que não possa ser excluída ou limitada de acordo com a lei aplicável
    """
}

#Preview {
    TermsOfUseView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Profile/Views/PrivacyPolicyView.swift\ ⁠
⁠ swift
//
//  PrivacyPolicyView.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 29/09/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            
            Color.appBg
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Última atualização: 25 de setembro de 2026")
                        .foregroundStyle(.secondary)
                    
                    Text("Esta Política de Privacidade descreve como o Locavio coleta, usa, armazena e protege os dados pessoais dos usuários (proprietários de imóveis) e de terceiros cujos dados sejam inseridos no aplicativo (inquilinos), em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 — LGPD).")
                    
                    sectionTitle("1. Interpretação e Definições")
                    
                    subsectionTitle("1.1 Definições")
                    
                    Text("Para os fins desta Política de Privacidade:")
                    
                    ListCardComponent(textList: definitions)
                    
                    sectionTitle("2. Coleta e Uso de Suas Informações Pessoais")
                    
                    subsectionTitle("2.1 Dados Pessoais")
                    
                    Text("Ao utilizar o nosso Serviço, poderemos solicitar que você nos forneça determinadas informações de identificação pessoal que possam ser usadas para entrar em contato ou identificá-lo. As informações de identificação pessoal podem incluir, entre outras:")
                    
                    ListCardComponent(textList: personalData)
                    
                    subsectionTitle("2.2 Uso dos Seus Dados Pessoais")
                    
                    Text("A Empresa poderá utilizar os Dados Pessoais para as seguintes finalidades:")
                    
                    ListCardComponent(textList: dataUsage)
                    
                    Text("Podemos compartilhar seus Dados Pessoais nas seguintes situações:")
                    
                    ListCardComponent(textList: dataSharing)
                    
                    sectionTitle("3 Dados de Terceiros (Inquilinos)")
                    
                    Text("Ao cadastrar um imóvel ou contrato, Você poderá inserir Dados Pessoais de terceiros (inquilinos), como nome, contato, CPF e histórico de pagamento. Nesse caso:")
                    
                    ListCardComponent(textList: thirdPartyData)
                    
                    sectionTitle("4 Armazenamento dos Dados — iCloud e CloudKit")
                    
                    Text("Os dados inseridos no Aplicativo são armazenados por meio dos serviços **iCloud** e **CloudKit**, da Apple Inc., que atua como Operadora dos dados em nosso nome. Isso significa que:")
                    
                    ListCardComponent(textList: storage)
                    
                    sectionTitle("5 Retenção dos Seus Dados Pessoais")
                    
                    Text("Mantemos seus dados pessoais apenas pelo tempo necessário para as finalidades descritas nesta Política. Ao encerrar sua Conta, seus dados pessoais são excluídos imediatamente da nossa base de dados ativa.")
                    
                    Text("Essa exclusão está sujeita a limitações técnicas de infraestrutura: cópias de segurança mantidas pela Apple (iCloud/CloudKit) seguem as políticas próprias de retenção da Apple e podem não ser removidas de forma instantânea de todos os sistemas de backup e replicação.")
                    
                    Text("A exclusão da Conta é definitiva e não pode ser desfeita. Recomendamos que você mantenha suas próprias cópias de documentos, contratos e comprovantes armazenados no aplicativo antes de solicitar o encerramento.")
                    
                    sectionTitle("6 Seus Direitos como Titular de Dados")
                    
                    Text("Nos termos do art. 18 da LGPD, você tem direito a:")
                    
                    ListCardComponent(textList: dataSubjectRights)
                    
                    Text("Para exercer qualquer um desses direitos, entre em contato conosco pelos canais indicados abaixo.")
                    
                    sectionTitle("7 Transferência dos Seus Dados Pessoais")
                    
                    Text("Como os dados são armazenados via iCloud/CloudKit, é possível que sejam transferidos para e mantidos em servidores localizados fora do Brasil. Quando isso ocorrer, adotaremos as salvaguardas exigidas pela LGPD (art. 33), como cláusulas contratuais e garantias de proteção equivalentes às exigidas na legislação brasileira.")
                    
                    sectionTitle("8 Exclusão dos Seus Dados Pessoais")
                    
                    Text("Você tem o direito de excluir ou solicitar que nós o ajudemos a excluir os Dados Pessoais que coletamos \nsobre Você.")
                    
                    Text("O nosso Serviço pode lhe dar a possibilidade de excluir determinadas informações sobre você diretamente \npelo Serviço.")
                    
                    Text("Você pode atualizar, corrigir ou excluir suas informações a qualquer momento, acessando sua conta, caso possua uma, e acessando a seção de configurações de conta que permite gerenciar suas informações pessoais. Você também pode entrar em contato conosco para solicitar acesso, correção ou exclusão de quaisquer Dados Pessoais que Você tenha nos fornecido.")
                    
                    Text("Observe, no entanto, que podemos precisar reter determinadas informações quando tivermos uma obrigação legal ou base legal para tanto.")
                    
                    sectionTitle("9 Divulgação dos Seus Dados Pessoais")
                    
                    subsubsectionTitle("9.1 Autoridades Policiais")
                    
                    Text("Em certas circunstâncias, a Empresa poderá divulgar seus Dados Pessoais se exigido por lei ou em resposta a solicitações válidas de autoridades públicas (por exemplo, um tribunal ou órgão governamental).")
                    
                    subsubsectionTitle("9.2 Outras Exigências Legais")
                    
                    Text("A Empresa poderá divulgar seus Dados Pessoais na crença de boa-fé de que tal ação é necessária para:")
                    
                    ListCardComponent(textList: legalRequirements)
                    
                    sectionTitle("10 Segurança dos Seus Dados Pessoais")
                    
                    Text("Adotamos medidas técnicas e administrativas razoáveis para proteger seus Dados Pessoais, incluindo a criptografia oferecida pela infraestrutura do iCloud/CloudKit. Ainda assim, nenhum método de transmissão pela internet ou armazenamento eletrônico é 100% seguro, e não podemos garantir segurança absoluta.")
                    
                    sectionTitle("11 Notificação de Incidentes de Segurança")
                    
                    Text("Em caso de incidente de segurança que possa acarretar risco ou dano relevante aos titulares, comunicaremos a Autoridade Nacional de Proteção de Dados (ANPD) e os titulares afetados, conforme exigido pelo art. 48 da LGPD, informando a natureza dos dados afetados, as medidas técnicas adotadas e as providências tomadas para reverter ou mitigar os efeitos do incidente.")
                    
                    sectionTitle("12. Privacidade de Crianças e Menores")
                    
                    Text("O Aplicativo é destinado a proprietários de imóveis maiores de 18 anos, idade mínima para celebrar contratos de locação no Brasil. Não coletamos intencionalmente dados de menores de idade. Caso identifiquemos Dados Pessoais de um menor cadastrados indevidamente, tomaremos as medidas necessárias para excluí-los.")
                    
                    sectionTitle("13. Alterações a esta Política de Privacidade")
                    
                    Text("Podemos atualizar nossa Política de Privacidade periodicamente. Notificaremos você sobre quaisquer alterações da nova Política de Privacidade.")
                    
                    Text("Informaremos Você por e-mail e/ou por aviso destacado em nosso serviço, antes que a alteração entre em vigor, e atualizaremos a data de \"Última atualização\" no topo desta Política de Privacidade.")
                    
                    Text("Recomendamos que Você revise esta Política de Privacidade periodicamente para verificar quaisquer alterações. As alterações a esta Política de Privacidade entram em vigor quando publicadas nesta página.")
                    
                    sectionTitle("14. Fale Conosco")
                    
                    Text("Se Você tiver alguma dúvida sobre esta Política de Privacidade, Você pode entrar em contato conosco:")
                    
                    ListCardComponent(textList: "**Por e-mail:** joao.cssouza1@senacsp.edu.br")
                }
                .font(.footnote)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Política de Pricavidade")
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.top, 8)
    }
    
    private func subsectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.bold())
    }
    
    private func subsubsectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.footnote.bold())
    }
    
    let definitions = """
    • **Conta** significa uma conta exclusiva criada para você acessar o Aplicativo.
    • **Aplicativo** refere-se ao Locavio, o programa de software fornecido pela Empresa.
    • **Empresa/Controladora** refere-se ao Locavio, responsável pelas decisões sobre o tratamento dos dados pessoais.
    • **Operador** significa a pessoa (física ou jurídica) que realiza o tratamento de dados pessoais em nome da Controladora — no caso do Locavio, a Apple Inc., por meio dos serviços iCloud e CloudKit.
    • **Titular** significa a pessoa natural a quem se referem os dados pessoais tratados — seja você (usuário/proprietário) ou um inquilino cujos dados sejam inseridos por um proprietário no Aplicativo.
    • **Dados Pessoais** são quaisquer informações relacionadas a uma pessoa natural identificada \nou identificável.
    • **Tratamento** é toda operação realizada com dados pessoais (coleta, uso, armazenamento, compartilhamento, eliminação, etc.).
    • **País**: Brasil.
    • **Dispositivo** significa qualquer iPhone que possa baixar o Aplicativo na AppStore.
    • **Serviço** refere-se ao Aplicativo.
    • **Dados de Uso** referem-se a dados coletados automaticamente, gerados pelo uso do Serviço ou por sua infraestrutura.
    • **Usuário** significa qualquer indivíduo que acesse ou utilize o Serviço.
    • **Você** significa o indivíduo (proprietário) que acessa ou utiliza o Serviço.
    """
    
    let personalData = """
    • Nome e sobrenome
    • E-mail
    • Endereço, Estado, Província, CEP, Cidade
    • Dados dos imóveis cadastrados (endereço, características, fotos)
    • Dados de contratos de locação e valores de aluguel
    • Solicitações de manutenção e histórico de comunicação sobre os imóveis
    • Dados de calendário/agenda relacionados aos imóveis
    • Documentos e fotos que você anexar ao Aplicativo (ex.: contratos, comprovantes)
    """
    
    let dataUsage = """
    • **Para fornecer e manter o nosso Serviço**, incluindo o monitoramento do uso do nosso Serviço.
    • **Para gerenciar sua Conta:** para gerenciar seu registro como usuário do Serviço. Os Dados Pessoais que você fornece podem lhe dar acesso a diferentes funcionalidades do Serviço disponíveis para você como Usuário registrado.
    • **Para entrar em contato com Você:** para contatá-lo por e-mail ou outras formas equivalentes de comunicação eletrônica, como notificações push de aplicativos móveis, referentes a atualizações ou comunicações informativas relacionadas às funcionalidades, produtos ou serviços contratados, incluindo atualizações de segurança, quando necessário ou razoável para sua implementação.
    • **Para gerenciar suas solicitações:** para atender e gerenciar suas solicitações para nós.
    • **Para outras finalidades:** podemos utilizar suas informações para outras finalidades, como análise de dados, identificação de tendências de uso, determinação da eficácia de nossas campanhas promocionais, e avaliação e aprimoramento do nosso Serviço, produtos, serviços, marketing e da \nsua experiência.
    """
    
    let dataSharing = """
    • **Com o Seu consentimento:** podemos divulgar seus Dados Pessoais para qualquer outra finalidade com o seu consentimento.
    • **Com Operadores/Prestadores de Serviços:** com a Apple (iCloud/CloudKit), para armazenamento e funcionamento do Aplicativo;
    • **Com autoridades:** quando exigido por lei ou por ordem de autoridade pública competente;
    """
    
    let thirdPartyData = """
    • Você é responsável por garantir que possui base legal e legitimidade para inserir esses dados no Aplicativo (em regra, a execução do contrato de locação);
    • Você é responsável por informar o inquilino sobre esse tratamento, conforme exigido pela LGPD;
    • A Empresa trata esses dados exclusivamente para viabilizar as funcionalidades do Aplicativo (gestão do contrato, comunicação, histórico de pagamentos), na qualidade de controladora dos sistemas, mas sem relação direta de conta com o inquilino.
    """
    
    #warning("Lembrar de testar o link quando a navegação estiver funcionando!")
    
    let storage = """
    • A Apple processa e armazena os dados exclusivamente conforme nossas instruções e para viabilizar o funcionamento do Aplicativo;
    • Os servidores utilizados podem estar localizados fora do Brasil, o que pode envolver transferência internacional de dados;
    • A Apple aplica suas próprias medidas de segurança e criptografia sobre os dados armazenados via CloudKit; mais informações estão disponíveis na [Política de Privacidade da Apple](https://www.apple.com/legal/privacy/);
    • Não temos acesso direto aos servidores da Apple além do que a API do CloudKit disponibiliza para o funcionamento do Aplicativo.
    """
    
    let dataSubjectRights = """
    • Confirmação da existência de tratamento de seus dados;
    • Acesso aos seus dados;
    • Correção de dados incompletos, inexatos \nou desatualizados;
    • Anonimização, bloqueio ou eliminação de dados desnecessários ou excessivos;
    • Eliminação dos dados tratados com base no seu consentimento;
    """
    
    let legalRequirements = """
    • Cumprir uma obrigação legal
    • Proteger e defender os direitos ou a propriedade da Empresa
    • Prevenir ou investigar possível conduta indevida relacionada ao serviço
    • Proteger a segurança pessoal dos usuários do serviço ou do público
    • Proteger contra responsabilidade legal
    """
}

#Preview {
    PrivacyPolicyView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Coordinators/PropertiesCoordinator.swift\ ⁠
⁠ swift
//
//  PropertiesCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

@Observable
final class PropertiesCoordinator {
    
    // pilha de navegação principal
    var path = NavigationPath()
    
    // controle das sheets
    var activeSheet: PropertiesSheet?
    
    // navegação em pilha
    func pushToDetails(property: Property) {
        path.append(PropertiesRoute.details(property: property))
    }
    
    
    func pushToNewProperty(){
        path.append(PropertiesRoute.newProperty)
    }
    
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // navegação das sheets
//    func presentAddProperty() {
//        activeSheet = .addProperty
//    }
    
    func dismissSheet() {
        activeSheet = nil
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Coordinators/PropertiesCoordinatorView.swift\ ⁠
⁠ swift
import SwiftUI

struct PropertiesCoordinatorView: View {
    
    @State private var propertiesCoordinator = PropertiesCoordinator()
    @State private var propertiesViewModel = PropertiesViewModel()
    
    
    var body: some View {
        NavigationStack(path: $propertiesCoordinator.path) {
            
            // puxa a tela inicial
            PropertiesView()
                .environment(propertiesCoordinator)
                .environment(propertiesViewModel)
            
            // roteador de pilha
            .navigationDestination(for: PropertiesRoute.self) { route in
                switch route {
                case .details(let id):
                    // PropertyDetailsView(propertyId: id)
                    Text("Detalhes do imóvel \(id)")
                    
                case .newProperty:
                    NewPropertyView()
                }
            }
            
            // roteador de sheets
//            .sheet(item: $propertiesCoordinator.activeSheet) { sheet in
//                switch sheet {
//                case .addProperty:
//                    // AddPropertyView()
//                    Text("Tela de adicionar imóvel")
//                }
//            }
        }
        
//        .navigationBarTitleDisplayMode(.inline) // sem .navigationTitle
//        .toolbar {
//            AppToolbar(
//                onMore: { viewModel.showOptions() },
//                onAdd: { viewModel.addProperty() }
//            )
//        }

    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Coordinators/PropertiesRoutes.swift\ ⁠
⁠ swift
//
//  PropertiesRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

// rotas de empilhamento (NavigationStack)
enum PropertiesRoute: Hashable {
    case details(property: Property)
    case newProperty
}

// rotas de sheets
enum PropertiesSheet: String, Identifiable {
    case addProperty
    var id: String { self.rawValue }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/ViewModels/ExpensesViewModel.swift\ ⁠
⁠ swift
//
//  ExpensesViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import Foundation
import SwiftData
import Observation

struct ExpenseRow: Identifiable {
    let id: PersistentIdentifier
    let title: String
    let valueText: String
}

@Observable
final class ExpensesViewModel {
    private let property: Property

    var isExpanded = true
    var newTitle = ""
    var newValueText = ""

    init(property: Property) {
        self.property = property
    }

    var totalLabel: String { "Valor total" }
    var emptyText: String { "Nenhuma despesa adicionada" }

    var rows: [ExpenseRow] {
        (property.expenses ?? []).map { expense in
            ExpenseRow(
                id: expense.persistentModelID,
                title: expense.title?.trimmedOrNil ?? "Sem título",
                valueText: Self.format(expense.value ?? 0)
            )
        }
    }

    ///Soma de todas as despesas do imóvel
    var totalText: String {
        let total = (property.expenses ?? []).reduce(0) { $0 + ($1.value ?? 0) }
        return Self.format(total)
    }

    //Adicionar / remover

    var canAdd: Bool {
        newTitle.trimmedOrNil != nil && parsedNewValue != nil
    }

    func toggle() { isExpanded.toggle() }

    func addExpense(in context: ModelContext) {
        guard let title = newTitle.trimmedOrNil, let value = parsedNewValue else { return }

        let expense = Expenses(property: property, title: title, value: value, date: Date())
        
        context.insert(expense)

        newTitle = ""
        newValueText = ""
    }

    func delete(_ id: PersistentIdentifier, in context: ModelContext) {
        guard let expense = property.expenses?.first(where: { $0.persistentModelID == id }) else { return }
        context.delete(expense)
    }

    

    /// Aceita "200", "200,50", "200.50" e "1.200,50".
    private var parsedNewValue: Double? {
        var text = newValueText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return nil }

        if text.contains(",") {
            text = text.replacingOccurrences(of: ".", with: "")
                       .replacingOccurrences(of: ",", with: ".")
        }

        guard let value = Double(text), value >= 0 else { return nil }
        return value
    }

    private static func format(_ value: Double) -> String {
        value.formatted(.currency(code: "BRL").locale(Locale(identifier: "pt_BR")))
    }
}

private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/ViewModels/PropertyListOptionsViewModel.swift\ ⁠
⁠ swift
//
//  PropertyListOptionsViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//

import Foundation
import Observation
import SwiftData

enum PropertySortOption: String, CaseIterable, Identifiable {
    case price = "Por preço"
    case alphabetical = "Ordem alfabética"
    case oldest = "Mais antigos"
    case newest = "Mais recentes"

    var id: Self { self }
}

enum RentFilter: String, CaseIterable, Identifiable {
    case all = "Todos"
    case paid = "Pago"
    case pending = "Pendente"

    var id: Self { self }
}

@Observable
final class PropertyListOptionsViewModel {
    var sort: PropertySortOption = .price
    var typeFilter: PropertyType? = nil
    var rentFilter: RentFilter = .all

    var hasActiveFilters: Bool {
        typeFilter != nil || rentFilter != .all
    }

   
    func apply(to properties: [Property], search: String = "") -> [Property] {
        properties
            .enumerated()
            .map { (position: $0.offset, property: $0.element) }
            .filter { matchesFilters($0.property) && matchesSearch($0.property, search) }
            .sorted { areInOrder($0, $1) }
            .map(\.property)
    }



    private func matchesFilters(_ property: Property) -> Bool {
        if let typeFilter, property.type != typeFilter { return false }

        switch rentFilter {
        case .all:     return true
        case .paid:    return property.isPaid == true
        case .pending: return property.isPaid != true
        }
    }

    private func matchesSearch(_ property: Property, _ text: String) -> Bool {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        return [property.title, property.street, property.neighborhood, property.city]
            .compactMap { $0 }
            .contains { $0.localizedStandardContains(query) }
    }

 
    private typealias Item = (position: Int, property: Property)

    private func areInOrder(_ a: Item, _ b: Item) -> Bool {
        switch sort {
        case .price:
           
            return (a.property.profit ?? -.infinity) > (b.property.profit ?? -.infinity)
        case .alphabetical:
            return (a.property.title ?? "")
                .localizedStandardCompare(b.property.title ?? "") == .orderedAscending
        case .oldest:
            return a.position < b.position
        case .newest:
            return a.position > b.position
        }
    }
    
    
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/ViewModels/PropertyCardViewModel.swift\ ⁠
⁠ swift
//
//  PropertyCardViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//

import Foundation
import SwiftUI
import UIKit

@Observable
final class PropertyCardViewModel {
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


    var image: UIImage? {
        guard let data = property.image else { return nil }
        return UIImage(data: data)
    }

    var hasImage: Bool { image != nil }

    

    var title: String {
        property.title?.trimmedOrNil ?? "Sem título"
    }

   
    var address: String {
        let streetPart = [property.street?.trimmedOrNil,
                          property.number.map(String.init)]
            .compactMap { $0 }
            .joined(separator: ", ")

        let parts = [streetPart.trimmedOrNil, property.city?.trimmedOrNil]
            .compactMap { $0 }

        return parts.isEmpty ? "Endereço não informado" : parts.joined(separator: " - ")
    }
    

    var badges: [TagBadgeItem] {
        [property.tenantBadge, property.typeBadge, property.areaBadge]
            .compactMap { $0 }
    }
   
    var tenantName: String? {
        let rawName: String? = property.tenant?.name
        return rawName?.trimmedOrNil
    }

    var noTenantText: String { "Nenhum locatário" }



    var rentLabel: String { "Aluguel" }

    var rentText: String {
        guard let profit = property.profit else { return "—" }
        return profit.formatted(
            .currency(code: "BRL").locale(Locale(identifier: "pt_BR"))
        )
    }

  

    var nextPaymentLabel: String { "Próx. Pagamento:" }

    var nextPaymentText: String {
        guard let date = nextPaymentDate else { return "—" }
        return Self.dateFormatter.string(from: date)
    }

   
    private var nextPaymentDate: Date? {
        guard let day = property.paymentDay, (1...31).contains(day) else { return nil }

        let now = today()
        let startOfToday = calendar.startOfDay(for: now)

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

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()
}

private extension String {

    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/ViewModels/PropertiesViewModel.swift\ ⁠
⁠ swift
//
//  PropertiesViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import Observation
import SwiftData
import PhotosUI

enum PropertyFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case alugados = "Alugados"
    case naoAlugados = "Não Alugados"

    var id: Self { self }
}

@Observable
final class PropertiesViewModel {
    
    var searchText = ""
    var filter: PropertyFilter = .todos

    let options = PropertyListOptionsViewModel()

  
    func visibleProperties(from properties: [Property]) -> [Property] {
        let bySegment = properties.filter(matchesSegment)
        return options.apply(to: bySegment, search: searchText)
    }


    private func matchesSegment(_ property: Property) -> Bool {
        switch filter {
        case .todos:       return true
        case .alugados:    return property.tenant != nil
        case .naoAlugados: return property.tenant == nil
        }
    }
    
    

//    var image: Data?
//    var title: String?
//    var type: PropertyType?
//    var area: Int?
//    var paymentDay: Int?
//    var isPaid: Bool?
//    var cep: String?
//    var street: String?
//    var neighborhood: String?
//    var number: Int?
//    var city: String?
//    var uf: String?
//    var profit: Double?
//    var owner: Owner?
    
    func addProperty(context: ModelContext, image: Data?, title: String, type: PropertyType, area: Int, paymentDay: Int, isPaid: Bool, cep: String, street: String, neighborhood: String, number: Int, city: String, uf: String, profit: Double) -> Bool {
        
        let defaultImageData = UIImage(named: "DefaultUser")?.jpegData(compressionQuality: 1) ?? Data()
        let coverData = image ?? defaultImageData
        
        let newProperty = Property(
            image: coverData,
            title: title,
            type: type,
            area: area,
            paymentDay: paymentDay,
            isPaid: isPaid,
            cep: cep,
            street: street,
            neighborhood: neighborhood,
            number: number,
            city: city,
            uf: uf,
            profit: profit
        )
        
        context.insert(newProperty)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error when trying to save a new property: \(error)")
            return false
        }
    }
    
//    func updateProperty(context: ModelContext, property: Property, image: Data?, title: String, type: PropertyType, area: Int, paymentDay: Int, isPaid: Bool, cep: String, street: String, neighborhood: String, number: Int, city: String, uf: String, profit: Double) {
//        
//        property.image = image
//        property.title = title
//        property.type = type
//        property.area = area
//        
//        
//    }
    

    
    
    
}


 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/Components/SearchBarView.swift\ ⁠
⁠ swift
//
//  SearchBar.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 28/09/26.
//
import SwiftUI
struct SearchBarView: View {
    @Binding var text: String
    var prompt: String = "Pesquise seus imóveis aqui"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(prompt, text: $text)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .glassEffect(.regular, in: .capsule)
    }
}



 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/Components/ToolbarComponentView.swift\ ⁠
⁠ swift
//
//  ToolbarComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 27/09/26.
//
import SwiftUI

struct AppToolbar: ToolbarContent {
    @Bindable var options: PropertyListOptionsViewModel
    var onAdd: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("Ordenar por") {
                    Picker("Ordenar por", selection: $options.sort) {
                        ForEach(PropertySortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section("Filtrar por") {
                    Menu("Tipo de imóvel") {
                        Picker("Tipo de imóvel", selection: $options.typeFilter) {
                            Text("Todos").tag(PropertyType?.none)
                            ForEach(PropertyType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(PropertyType?.some(type))
                            }
                        }
                        .pickerStyle(.inline)
                    }

                    Menu("Aluguel") {
                        Picker("Aluguel", selection: $options.rentFilter) {
                            ForEach(RentFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }

        ToolbarSpacer(.fixed, placement: .topBarTrailing)

        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
            .buttonStyle(.glassProminent)
            .tint(.accentColor)
        }
    }
}

#Preview {
    let options = PropertyListOptionsViewModel()

    NavigationStack {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppToolbar(
                    options: options,
                    onAdd: { print("Adicionar") }
                )
            }
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/Components/CardPropertyView.swift\ ⁠
⁠ swift
//
//  PropertyCardView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI

struct PropertyCardView: View {
    let viewModel: PropertyCardViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(property: Property) {
        self.viewModel = PropertyCardViewModel(property: property)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            background
            infoPanel
        }
        .frame(maxWidth: .infinity)
        .frame(height: 330)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

    // Fundo

    @ViewBuilder
    private var background: some View {
        if let uiImage = viewModel.image {
            Color.clear
                .overlay {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
        } else {
            Color(.systemGray4)
                .overlay(alignment: .top) {
                    Image(systemName: "photo")
                        .font(.system(size: 56))
                        .foregroundStyle(Color(.systemGray))
                        .padding(.top, 50)
                }
        }
    }

    // Painel

    private var infoPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.title)
                        .font(.title.bold())
                        .lineLimit(1)

                    Text(viewModel.address)
                        .font(.subheadline)
                        .foregroundStyle(secondaryTextColor)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    tenantLine
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 6) {
                    Text(viewModel.rentLabel)
                        .font(.subheadline)
                        .foregroundStyle(secondaryTextColor)

                    Text(viewModel.rentText)
                        .font(.title2.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    VStack(alignment: .trailing, spacing: 0) {
                        Text(viewModel.nextPaymentLabel)
                        Text(viewModel.nextPaymentText).fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundStyle(secondaryTextColor)
                }
                .fixedSize(horizontal: true, vertical: false)
            }

            badgesRow
        }
        .foregroundStyle(primaryTextColor)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { panelBackground }
    }

    

    private var badgesRow: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.badges) { badge in
                TagBadgeView(badge)
            }
        }
    }

    

    @ViewBuilder
    private var tenantLine: some View {
        Group {
            if let name = viewModel.tenantName {
                Text("\(Text("Locatário:").bold()) \(name)")
            } else {
                Text(viewModel.noTenantText)
            }
        }
        .font(.subheadline)
        .foregroundStyle(primaryTextColor.opacity(0.75))
        .lineLimit(1)
    }

    // Estilo do painel

    private var panelShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
    }

    @ViewBuilder
    private var panelBackground: some View {
        if viewModel.hasImage {
            panelShape.fill(.ultraThinMaterial)
        } else if colorScheme == .dark {
            panelShape.fill(Color.white)
        } else {
            panelShape
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .overlay {
                    LinearGradient(colors: [.black.opacity(0.25), .black.opacity(0.6)],
                                   startPoint: .top, endPoint: .bottom)
                        .clipShape(panelShape)
                }
        }
    }

    private var primaryTextColor: Color {
        if viewModel.hasImage { return .primary }
        return colorScheme == .dark ? .black : .white
    }

    private var secondaryTextColor: Color {
        if viewModel.hasImage { return .secondary }
        return colorScheme == .dark ? .black.opacity(0.6) : .white.opacity(0.6)
    }
}


#Preview("Sem imagem") {
    PropertyCardView(property: Property(
        title: "Casa 1", type: .home, area: 32, paymentDay: 10,
        street: "Rua Ipê Amarelo", number: 55, city: "São Paulo", profit: 1200
    ))
    .padding()
}

private func previewPropertyWithImage() -> Property {
    Property(
        image: UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9),
        title: "Casa 1", type: .home, area: 32, paymentDay: 10,
        street: "Rua Ipê Amarelo", number: 55, city: "São Paulo", profit: 1200
    )
}

#Preview("Com imagem") {
    PropertyCardView(property: previewPropertyWithImage())
        .padding()
}


 



 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/Components/ExpensesCardView.swift\ ⁠
⁠ swift
//
//  ExpensesCardView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI
import SwiftData

struct ExpensesCardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ExpensesViewModel
    
    init(property: Property) {
        _viewModel = State(initialValue: ExpensesViewModel(property: property))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.isExpanded {
                content
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
    // MARK: - Cabeçalho (Valor total)
    
    private var header: some View {
        Button {
            withAnimation(.snappy) { viewModel.toggle() }
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.totalLabel)
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(viewModel.totalText)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Image(systemName: "chevron.down")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .rotationEffect(.degrees(viewModel.isExpanded ? 0 : -90))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Lista
    
    private var content: some View {
        VStack(spacing: 0) {
            if viewModel.rows.isEmpty {
                Text(viewModel.emptyText)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
            } else {
                ForEach(viewModel.rows) { row in
                    expenseRow(row)
                }
            }
            
            
        }
        .background(.quaternary)
    }
    
    private func expenseRow(_ row: ExpenseRow) -> some View {
        HStack {
            Text(row.title)
                .font(.title3)
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Spacer(minLength: 12)
            
            Text(row.valueText)
                .font(.title3)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
        .contextMenu {
            Button(role: .destructive) {
                viewModel.delete(row.id, in: modelContext)
            } label: {
                Label("Remover", systemImage: "trash")
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let property = Property(title: "Casa 1")
    container.mainContext.insert(property)

    for (title, value) in [("IPTU", 200.0), ("Condomínio", 400), ("Seguro", 200), ("Lucro", 400)] {
        container.mainContext.insert(Expenses(property: property, title: title, value: value))
    }

    return ExpensesCardView(property: property)
        .padding()
        .modelContainer(container)
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/NewPropertySheet.swift\ ⁠
⁠ swift
//
//  NewPropertyView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct NewPropertyView: View {
    var body: some View {
        Text("Tela de nova propriedade")
    }
}

#Preview {
    NewPropertyView()
}
 ⁠

---

### Arquivo: \⁠ ./Features/Properties/Views/PropertiesView.swift\ ⁠
⁠ swift
//
//  ScreenPropertyView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI
import SwiftData

struct PropertiesView: View {
    @State private var viewModel = PropertiesViewModel()
    
    @Environment(AppleAuthManager.self) private var authManager
    
    @Query private var properties: [Property]
    
    @Query private var users: [Owner]
    
    private var visibleProperties: [Property] {
        viewModel.visibleProperties(from: properties)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Imóveis")
                    .font(.largeTitle.bold())
                
                Button("Logout", action:{
                    authManager.logout()
                })
                
                Text("\(users.first?.documentNumber ?? "Sem documento")")
                
                SearchBarView(text: $viewModel.searchText)
                
                Picker("Filtro", selection: $viewModel.filter) {
                    ForEach(PropertyFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                
                LazyVStack(spacing: 16) {
                    ForEach(visibleProperties) { property in
                        PropertyCardView(property: property)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            AppToolbar(
//                options: viewModel.options,
//                onAdd: { viewModel.addProperty() }
//            )
//        }
    }
}

#Preview {
    
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
        Payment.self, Expenses.self, Ticket.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    container.mainContext.insert(Property(
        title: "Casa 1", type: .home, area: 32, paymentDay: 10, isPaid: true,
        street: "Rua Ipê Amarelo", number: 55, city: "São Paulo", profit: 1200
    ))
    container.mainContext.insert(Property(
        title: "Apto 202", type: .apartment, area: 58, paymentDay: 5, isPaid: false,
        street: "Av. Paulista", number: 1000, city: "São Paulo", profit: 2800
    ))
    
    return PropertiesView()
        .modelContainer(container)
        .environment(AppleAuthManager())
}

// exemplos chamada coordinator:

//Button(action: {
//    coordinator.path.append(.newProperty)
//}) {
//    Text("Adicionar Novo Imóvel")
//}
//
//// Exemplo passando um parâmetro para a rota de detalhes
//Button(action: {
//    let idDoImovel = 1 // Isso viria do seu SwiftData
//    coordinator.path.append(.details(id: idDoImovel))
//}) {
//    Text("Ver Detalhes do Imóvel 1")
//}
 ⁠

---

### Arquivo: \⁠ ./Features/DetailProperty/ViewModels/PropertyDetailViewModel.swift\ ⁠
⁠ swift
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

    // MARK: - Imagem

    var image: UIImage? {
        guard let data = property.image else { return nil }
        return UIImage(data: data)
    }

    var hasImage: Bool { image != nil }

    // MARK: - Cabeçalho

    /// Tag do tipo do imóvel (ex.: "Casa"). `nil` esconde a tag.
    var typeTag: String? {
        property.type?.rawValue
    }

    var title: String {
        property.title?.trimmedOrNil ?? "Sem título"
    }

    /// Ex.: "32 m²". `nil` quando a área não foi informada.
    var areaText: String? {
        guard let area = property.area else { return nil }
        return "\(area) m²"
    }

    /// Ex.: "Rua Ipê Amarelo, 55 - Santo Amaro - SP"
    var address: String {
        let streetPart = [property.street?.trimmedOrNil,
                          property.number.map(String.init)]
            .compactMap { $0 }
            .joined(separator: ", ")

        let parts = [streetPart.trimmedOrNil,
                     property.neighborhood?.trimmedOrNil,
                     property.uf?.trimmedOrNil?.uppercased()]
            .compactMap { $0 }

        return parts.isEmpty ? "Endereço não informado" : parts.joined(separator: " - ")
    }

    /// Ex.: "CEP: 12345-678"
    var cepText: String {
        guard let raw = property.cep?.trimmedOrNil else { return "CEP não informado" }

        let digits = raw.filter(\.isNumber)
        guard digits.count == 8 else { return "CEP: \(raw)" }

        return "CEP: \(digits.prefix(5))-\(digits.suffix(3))"
    }

    // MARK: - Próximo pagamento

    var nextPaymentLabel: String { "Próx. Pagamento:" }

    var nextPaymentText: String {
        guard let date = nextPaymentDate else { return "—" }
        return Self.dateFormatter.string(from: date)
    }

    // MARK: - Inquilino

    var tenantSectionTitle: String { "Inquilino" }

    var hasTenant: Bool { property.tenant != nil }

    var noTenantText: String { "Nenhum locatário" }

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

    // MARK: - Helpers

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
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()
}

private extension String {
    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/DetailProperty/Component/TenantInfoComponentView.swift\ ⁠
⁠ swift
//
//  TenantInfoComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 30/09/26.
//

import SwiftUI


struct TenantSectionView: View {
    let viewModel: PropertyDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(viewModel.tenantSectionTitle)
                .font(.title3.bold())
            tenantCard
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    
    private var tenantCard: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            if viewModel.hasTenant {
                if let name = viewModel.tenantName {
                    Text(name)
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                if let email = viewModel.tenantEmail {
                    Text(email)
                        .foregroundStyle(.secondary)
                }
                
                if let cpf = viewModel.tenantCPF {
                    Text(cpf)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(viewModel.noTenantText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .lineLimit(1)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
}

#Preview("Com inquilino") {
    let tenant = Tenant(name: "Alberto Caseiro",
                        email: "bertinhocaeiro@fpessoa.com",
                        cpf: "12345678901")
    let property = Property(title: "Casa 1", tenant: tenant)
    
    TenantSectionView(viewModel: PropertyDetailViewModel(property: property))
        .padding()
}

#Preview("Sem inquilino") {
    let property = Property(title: "Casa 1")
    
    TenantSectionView(viewModel: PropertyDetailViewModel(property: property))
        .padding()
        .preferredColorScheme(.dark)
}
 ⁠

---

### Arquivo: \⁠ ./Features/DetailProperty/Component/ToolbarDetailsComponentView.swift\ ⁠
⁠ swift
//
//  ToolbarDetailsComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//



import SwiftUI
 
struct ToolbarDetailsComponentView: ToolbarContent {
    var onEdit: () -> Void
 
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onEdit) {
                Image(systemName: "square.and.pencil")
            }
            .accessibilityLabel("Editar")
        }
    }
}
 
#Preview {
    NavigationStack {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarDetailsComponentView(
                    onEdit: { print("Editar") }
                )
            }
    }
}
     ⁠

---

### Arquivo: \⁠ ./Features/DetailProperty/Views/DetailsProperty.swift\ ⁠
⁠ swift
//
//  DetailsProperty.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//

 ⁠

---

### Arquivo: \⁠ ./Features/Authentication/Coordinators/LoginCoordinator.swift\ ⁠
⁠ swift
//
//  LoginCoordinator.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
 ⁠

---

### Arquivo: \⁠ ./Features/Authentication/Coordinators/LoginRoutes.swift\ ⁠
⁠ swift
//
//  LoginRoutes.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
 ⁠

---

### Arquivo: \⁠ ./Features/Authentication/ViewModels/LoginViewModel.swift\ ⁠
⁠ swift
//
//  LoginViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import SwiftData

@Observable
final class LoginViewModel{
    
    func syncUserToSwiftData(context: ModelContext, authManager: AppleAuthManager) {
        
        // puxa o ID salvo no Keychain Storage
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else { return }
        
        // verifica se o usuário já existe no banco local
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            let existingUsers = try context.fetch(descriptor)
            
            
            if let user = existingUsers.first {
                
                if let doc = user.documentNumber, !doc.isEmpty {
                    authManager.currentAuthState = .authenticated
                } else {
                    authManager.currentAuthState = .needsRegistration
                }
                
            } else {
                
                // caso seja um usuário novo no dispositivo, cria suas infos puxando do Keychain
                let name = KeychainHelper.shared.readString(for: "appleUserFullName")
                let email = KeychainHelper.shared.readString(for: "appleUserEmail")
                
                // atribui as infos do novo perfil
                
                let newUserProfile = Owner(appleUserID: userID, fullName: name, email: email)
                
                // insere no SwiftData (o iCloud vai sincronizar automaticamente hehe)
                context.insert(newUserProfile)
                
                authManager.currentAuthState = .needsRegistration
                
                // var newUser = verifyNewUser(context: context)
                
            }
           
        } catch {
            print("Error when trying to fetch user from SwiftData: \(error)")
        }
    }
}

        
       
 ⁠

---

### Arquivo: \⁠ ./Features/Authentication/Views/LoginView.swift\ ⁠
⁠ swift
//
//  LoginView.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import SwiftUI
import SwiftData
import AuthenticationServices

struct LoginView: View {
    @Environment(AppleAuthManager.self) var appleAuthManager
    
    // contexto do swift data
    @Environment(\.modelContext) private var context
    
    // instância da viewmodel de login
    @State private var loginViewModel = LoginViewModel()
    
    let gradientStops: [Gradient.Stop] = [
        Gradient.Stop(color: .loginGradient3, location: 0.0),
        Gradient.Stop(color: .loginGradient2, location: 0.3),
        Gradient.Stop(color: .loginGradient1, location: 1.0)
    ]
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: gradientStops),
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                
                Image("LocavioLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                
                Spacer()
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Boas-Vindas!")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 14)
                    
                    Image("termsIcon")
                    
                    
                    Text("O Locavio é um app para fazer a gestão de seus imóveis. Para uma melhor experiência, coletamos a numeração do seu documento, seu nome e email, os quais serão utilizados exclusivamente para a validação da sua identidade e não serão compartilhados com outros usuários.")
                        .font(.caption)
                        .foregroundStyle(.primary)
                    
                    Text("Veja como seus dados são gerenciados...")
                        .font(.caption.bold())
                        .foregroundStyle(.darkerPalette)
                    
                    SignInWithAppleButton(.continue) {
                        request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            
                            // atualiza a variável isAuthenticated do App
                            appleAuthManager.handleAuthorization(authorization)
                            
                            // sincroniza com o SwiftData para subir pro iCloud
                            // passa o contexto como parâmetro pq o swift data só pode ser usado em structs
                            loginViewModel.syncUserToSwiftData(context: context, authManager: appleAuthManager)
                            
                        case .failure(let error):
                            print("Error when trying to sign in: \(error.localizedDescription)")
                        }
                    }
                    //            .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .padding(30)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 38))
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 38))
            }
            .padding()
        }
        //        .task{
        //            appleAuthManager.checkCredentialStatus()
        //        }
        
    }
}


#Preview {
    LoginView()
        .environment(AppleAuthManager())
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Coordinators/OnboardingCoordinatorView.swift\ ⁠
⁠ swift
//
//  OnboardingCoordinatorView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

import SwiftUI


import SwiftData

struct OnboardingCoordinatorView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("onboardingConcluido") private var onboardingConcluido: Bool = false

    var body: some View {
        Group {
            if onboardingConcluido {
                LoginView()
            } else {
                OnboardingView()
            }
        }
    }
}

//#Preview {
//    OnboardingCoordinatorView()
//}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/ViewModels/TextsOnboardingViewModel.swift\ ⁠
⁠ swift
//
//  TextsOnboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class TextsOnboardingViewModel {
    var currentScreen: Int = 0
    var finish: Bool = false
    
    let allScreen = 3
    
    let screenOnboardings: [OnboardingModel] = [
        OnboardingModel(titleOnboarding: "Gerencie\nseus imóveis", subtitleOnboarding: "Cadastre seus imóveis e tenha tudo\norganizado em um só lugar.", image: "OnboardingScreen1"),
        
        OnboardingModel(titleOnboarding: "Acompanhe\ncada Solicitação", subtitleOnboarding: "Registre manutenções e acompanhe o\nandamento de tudo.", image: "OnboardingScreen2"),
        
        OnboardingModel(titleOnboarding: "Tenha uma\n visão do seu negócio", subtitleOnboarding: "Acompanhe aluguéis, lucros e despesas\nem um único dashboard.", image: "OnboardingScreen3")
    ]
    

    
    func continueOnboarding() {
        if currentScreen < allScreen - 1 {
            currentScreen += 1
            print(currentScreen)
        } else {
            finish = true
        }
    }
    
    func back() {
        guard currentScreen > 0 else { return }
        
        currentScreen -= 1
    }
    
    // não é push ou pop, ele troca a raiz do app inteiro
    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingConcluido")
    }
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Models/OnboardingModel.swift\ ⁠
⁠ swift
//
//  TextsOnboardingModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//

import Foundation

struct OnboardingModel {
    let titleOnboarding: String
    let subtitleOnboarding: String
    let image: String
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Views/Components/OnboardingComponent.swift\ ⁠
⁠ swift
//
//  Onboarding1View.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//


import SwiftUI

struct OnboardingComponent: View {
    @Bindable var viewModel: TextsOnboardingViewModel
    @Environment(\.colorScheme) private var colorScheme
    let screen: Int

    private var image: OnboardingModel {
        viewModel.screenOnboardings[screen]
    }

    private var blurColor: Color {
        colorScheme == .dark ? Color(hex: "152D39") : Color(hex: "EFE1CE")
    }

    var body: some View {
        ZStack {
         
            Image(image.image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

         
            VStack {
                Spacer()
                LinearGradient(
                    stops: [
                        .init(color: blurColor.opacity(0), location: 0),
                        .init(color: blurColor.opacity(0.55), location: 0.25),
                        .init(color: blurColor.opacity(0.85), location: 0.45),
                        .init(color: blurColor, location: 0.55),
                        .init(color: blurColor, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 620)
                
            }

            VStack{
                Spacer()
                ComponentTextOnboarding(viewModel: viewModel, screen: 0)
                    .padding()
                VStack(spacing: 10){
                    ComponentButton(textButton: "Continuar") {
                        viewModel.continueOnboarding()
                    }
                    .frame(width: 200, height: 50)
                    
                    StageBall(
                        currentPage: viewModel.currentScreen,
                        allPages: viewModel.allScreen
                    )
                }
                .padding(.trailing, 50)
                
            }
            .padding(.bottom, 50)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingComponent(
        viewModel: TextsOnboardingViewModel(), screen: 0)
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Views/Components/ComponentTextOnboarding.swift\ ⁠
⁠ swift
//
//  ComponentTextOnboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//


import SwiftUI

struct ComponentTextOnboarding: View {
    @Bindable var viewModel: TextsOnboardingViewModel
    let screen: Int
    private var texts: OnboardingModel {
        viewModel.screenOnboardings[screen]
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text(texts.titleOnboarding)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.colorOnboarding)
                
                
            Text(texts.subtitleOnboarding)
                .font(.callout)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal,16)
    }
}

#Preview {
    ComponentTextOnboarding(viewModel: TextsOnboardingViewModel(), screen: 0)
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Views/Components/StageBall.swift\ ⁠
⁠ swift
//
//  StageBall.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 23/09/26.
//

import SwiftUI

struct StageBall: View {

    let currentPage: Int
    let allPages: Int
    
    var body: some View {
        HStack(spacing: 7) {
            
            ForEach(0..<allPages, id: \.self) { index in
                
                Circle()
                    .fill(
                        index == currentPage 
                        ? (Color.primary)
                        : Color.gray.opacity(0.5)
                    )
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    StageBall(currentPage: 1, allPages: 3)
}
 ⁠

---

### Arquivo: \⁠ ./Features/Onboarding/Views/Onboarding.swift\ ⁠
⁠ swift
//
//  Onboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

import SwiftUI



struct OnboardingView: View {
    @Bindable var viewModel = TextsOnboardingViewModel()

    var body: some View {
        OnboardingComponent(viewModel: viewModel, screen: viewModel.currentScreen)
            .onChange(of: viewModel.finish) { _, finish in
                if finish {
                    viewModel.finishOnboarding()
                }
            }
    }
}

#Preview {
    OnboardingView()
}
 ⁠

---

