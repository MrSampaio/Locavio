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
