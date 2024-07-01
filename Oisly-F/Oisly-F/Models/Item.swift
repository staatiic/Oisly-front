//
//  Item.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import Foundation

struct Item: Codable {
    var id: Int
    var menu_id: Int
    var nombre: String
    var descripcion: String
    var precio: Double
    var imagen_url: String

    enum CodingKeys: String, CodingKey {
        case id, menu_id, nombre, descripcion, precio, imagen_url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        menu_id = try container.decode(Int.self, forKey: .menu_id)
        nombre = try container.decode(String.self, forKey: .nombre)
        descripcion = try container.decode(String.self, forKey: .descripcion)
        imagen_url = try container.decode(String.self, forKey: .imagen_url)

        // Intenta decodificar el precio como String y luego convertirlo a Double sabra dios cuando quiera hacer cuentas
        let precioString = try container.decode(String.self, forKey: .precio)
        if let precioDouble = Double(precioString) {
            precio = precioDouble
        } else {
            throw DecodingError.dataCorruptedError(forKey: .precio, in: container, debugDescription: "El valor de 'precio' no se pudo convertir a Double")
        }
    }
}
