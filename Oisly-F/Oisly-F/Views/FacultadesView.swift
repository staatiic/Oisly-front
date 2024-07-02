//
//  FacultadesView.swift
//  Oisly-F
//
//  Created by Diana Ovalle on 02/07/24.
//

import SwiftUI

struct FacultadesView: View {
    var facultades: [Facultad]
    @Binding var negocios: [Negocio]
    @Binding var selectedFacultad: Facultad?
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Selecciona una facultad:")
                .font(.headline)
                .padding()

            Picker("Selecciona la facultad", selection: $selectedFacultad) {
                ForEach(facultades, id: \.id) { facultad in
                    Text(facultad.nombre).tag(facultad as Facultad?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: selectedFacultad) { newFacultad in
                if let facultad = newFacultad {
                    fetchNegocios(for: facultad)
                }
            }

            if let selectedFacultad = selectedFacultad {
                Text("Negocios en la facultad seleccionada: \(selectedFacultad.nombre)")
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
                Text("Selecciona una facultad para ver los negocios.")
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
            // Reset selectedFacultad to nil when navigating away
            selectedFacultad = nil
        }
    }

    private func fetchNegocios(for facultad: Facultad) {
        APIService.shared.fetchNegociosByFacultad(facultadId: facultad.id) { negocios, error in
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
