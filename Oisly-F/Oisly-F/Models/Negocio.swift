//
//  Negocio.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import Foundation

struct Negocio: Identifiable, Codable, Hashable {
    let id: Int
    let nombre: String
    let descripcion: String?
    let categoria_id: Int
    let facultad_id: Int
}

