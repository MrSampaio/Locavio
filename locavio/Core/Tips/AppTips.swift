//
//  AppTips.swift
//  locavio
//
//  Created by Julio Sampaio on 11/10/26.
//

import Foundation
import TipKit

// tips imóveis
struct AddPropertyTip: Tip {
    var title: Text {
        Text("Adicionar imóvel")
    }
    
    var message: Text? {
        Text("Neste botão, você pode adicionar um imóvel novo.")
    }
    
    var image: Image? {
        Image(systemName: "house.fill")
    }
    
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

struct PropertyStatusTip: Tip {
    var title: Text {
        Text("Status do imóvel")
    }
    var message: Text? {
        Text("Você pode escolher quais imóveis quer ver de acordo com o status.")
    }
    
    var image: Image? {
        Image(systemName: "house.badge.exclamationmark.fill")
    }
    
    
    
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

// tips adicionar imóvel
struct RentPaidTip: Tip {
    var title: Text {
        Text("Confirmar pagamento")
    }
    var message: Text? {
        Text("Nesse toggle, você confirma se o aluguel do mês foi pago ou não.")
    }
    var image: Image? {
        Image(systemName: "dollarsign")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

struct TicketsSectionTip: Tip {
    var title: Text {
        Text("Solicitações")
    }
    var message: Text? {
        Text("Ao clicar, você será redirecionado para a solicitação em aberto.")
    }
    var image: Image? {
        Image(systemName: "hammer.fill")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

struct PropertyPhotoTip: Tip {
    var title: Text {
        Text("Foto do imóvel")
    }
    var message: Text? {
        Text("Aqui, você pode adicionar uma foto do seu imóvel.")
    }
    var image: Image? {
        Image(systemName: "photo")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

// tips últimos pagamentos
struct ReceiptTip: Tip {
    var title: Text {
        Text("Visualizar o comprovante")
    }
    var message: Text? {
        Text("Ao clicar, você pode visualizar o comprovante de pagamento daquele mês.")
    }
    var image: Image? {
        Image(systemName: "document.fill")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

// tips relatório
struct DashboardSegmentedTip: Tip {
    var title: Text {
        Text("Lucro e Despesa")
    }
    var message: Text? {
        Text("Aqui, você pode mudar o conteúdo do relatório para ”Despesa” ou ”Lucro”.")
    }
    var image: Image? {
        Image(systemName: "dollarsign.ring")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}

// tips perfil
struct NotificationsProfileTip: Tip {
    var title: Text {
        Text("Notificações")
    }
    var message: Text? {
        Text("Você pode escolher quais notificações quer receber.")
    }
    var image: Image? {
        Image(systemName: "bell.fill")
    }
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}
