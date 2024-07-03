//
//  CreateNegocioView.swift
//  Oisly-F
//
//  Created by Diana Ovalle on 03/07/24.
//

import Foundation
import SwiftUI

struct CreateNegocioView: View {
    @Binding var negocios: [Negocio]
    @Binding var userId: Int?
    var facultadId: Int?
    var categorias: [Categoria]
    
    @State private var nombre = ""
    @State private var descripcion = ""
    @State private var imagenUrl = ""
    @State private var selectedCategoriaId: Int?
    @State private var errorMessage = ""
    @State private var successMessage = ""
    
    

    var body: some View {
        VStack {
            Text("Crear Nuevo Negocio")
                .font(.title)
                .foregroundColor(Color(red: 188/255, green: 184/255, blue: 206/255))
                .padding()

            TextField("Nombre del Negocio", text: $nombre)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            TextField("Descripción", text: $descripcion)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            TextField("URL de la Imagen", text: $imagenUrl)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Picker("Categoría", selection: $selectedCategoriaId) {
                ForEach(categorias, id: \.id) { categoria in
                    Text(categoria.nombre)
                        .tag(categoria.id as Int?)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Button(action: {
                createNegocio()
            }) {
                Text("Crear Negocio")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }

    private func createNegocio() {
        guard let userId = userId, let facultadId = facultadId, let categoriaId = selectedCategoriaId else {
            errorMessage = "Todos los campos son obligatorios"
            return
        }
        
        let newNegocio = [
            "nombre": nombre,
            "descripcion": descripcion,
            "imagen_url": imagenUrl,
            "propietario_id": userId,
            "categoria_id": categoriaId,
            "facultad_id": facultadId
        ] as [String : Any]
        
        APIService.shared.createNegocio(negocio: newNegocio) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.successMessage = "Negocio creado exitosamente"
                    self.errorMessage = ""
                    // Actualizar la lista de negocios
                    fetchUpdatedNegocios()
                } else {
                    self.errorMessage = error ?? "Error al crear negocio"
                    self.successMessage = ""
                }
            }
        }
    }
    
    private func fetchUpdatedNegocios() {
        APIService.shared.fetchNegocios { negocios, error in
            DispatchQueue.main.async {
                if let negocios = negocios {
                    self.negocios = negocios
                } else if let error = error {
                    self.errorMessage = error
                }
            }
        }
    }
}
