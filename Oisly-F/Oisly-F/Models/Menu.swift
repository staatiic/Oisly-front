//
//  Menu.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import Foundation
struct Menu: Identifiable, Decodable {
    let id: Int
    let negocio_id: Int
    let nombre: String
    let descripcion: String?
}
