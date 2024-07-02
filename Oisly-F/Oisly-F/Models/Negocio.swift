//
//  Negocio.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import Foundation



struct Negocio: Codable, Identifiable{
    var id: Int
    var nombre: String
    var descripcion: String?
    var imagenUrl: String?
    var propietario_id: Int
    var categoria_id: Int
    var facultad_id: Int
}

