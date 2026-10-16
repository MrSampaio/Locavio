//
//  Tickets+Status.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 15/10/26.
//


import Foundation

extension Ticket {

    /// Fecha o chamado. A data em que ele estava (o prazo) é guardada em
    /// `previousConclusionDate` para poder voltar a ela se for reaberto.
    func close(at date: Date = .now) {
        // se já existe uma data guardada, não sobrescreve (fechar duas vezes não pode perder o prazo)
        if previousConclusionDate == nil {
            previousConclusionDate = conclusionDate
        }

        isConcluded = true
        conclusionDate = date
    }

    /// Reabre o chamado e devolve a data em que ele estava antes de ser fechado.
    func reopen() {
        isConcluded = false

        // chamados fechados antes dessa mudança não têm a data guardada e ficam como estão
        if let previous = previousConclusionDate {
            conclusionDate = previous
            previousConclusionDate = nil
        }
    }
}
