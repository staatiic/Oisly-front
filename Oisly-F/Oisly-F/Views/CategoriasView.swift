//
//  CategoriasView.swift
//  Oisly-F
//
//  Created by Diana Ovalle on 02/07/24.
//

import SwiftUI

struct CategoriasView: View {
    var categorias: [Categoria]
    @Binding var negocios: [Negocio]
    @Binding var selectedCategoria: Categoria?
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Selecciona una categoría:")
                .font(.headline)
                .padding()

            Picker("Selecciona la categoría", selection: $selectedCategoria) {
                ForEach(categorias, id: \.id) { categoria in
                    Text(categoria.nombre).tag(categoria as Categoria?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: selectedCategoria) { newCategoria in
                if let categoria = newCategoria {
                    fetchNegociosByCategoria(categoriaId: categoria.id)
                }
            }

            if let selectedCategoria = selectedCategoria {
                Text("Negocios en la categoría seleccionada: \(selectedCategoria.nombre)")
                    .font(.headline)
                    .padding()

                List(negocios, id: \.id) { negocio in
                    NavigationLink(
                        destination: MenuView(negocioId: negocio.id),
                        label: {
                            VStack(alignment: .leading) {
                                Text(negocio.nombre)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 188/255, green: 184/255, blue: 206/255))
                                Text(negocio.descripcion ?? "")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                    )
                }
            } else {
                Text("Selecciona una categoría para ver los negocios.")
                    .foregroundColor(.gray)
                    .padding()
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onDisappear {
            // Reset selectedCategoria to nil when navigating away
            selectedCategoria = nil
        }
    }

    private func fetchNegociosByCategoria(categoriaId: Int) {
        APIService.shared.fetchNegociosByCategoria(categoriaId: categoriaId) { negocios, error in
            DispatchQueue.main.async {
                if let negocios = negocios {
                    self.negocios = negocios
                    self.errorMessage = ""
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Error desconocido"
                }
            }
        }
    }
}
