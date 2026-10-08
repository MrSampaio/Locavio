//
//  MaintenceDraft.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//
import Foundation
import SwiftData

struct MaintenceDraft: Identifiable {
    let id = UUID()
    var item: String
    var value: Double?
}
