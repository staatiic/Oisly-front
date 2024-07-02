
//  NegociosView.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import SwiftUI

struct NegociosView: View {
    @State private var negocios: [Negocio] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(negocios, id: \.id) { negocio in
                    VStack(alignment: .leading) {
                        Text(negocio.nombre)
                            .font(.headline)
                            .foregroundColor(.purple)
                        if let descripcion = negocio.descripcion {
                            Text(descripcion)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchNegocios()
        }
    }

    private func fetchNegocios() {
        APIService.shared.fetchNegocios { negocios, error in
            DispatchQueue.main.async {
                if let negocios = negocios {
                    self.negocios = negocios
                    self.errorMessage = nil // Limpiar el mensaje de error
                } else {
                    self.negocios = []
                    self.errorMessage = error ?? "Error desconocido"
                }
            }
        }
    }
}
