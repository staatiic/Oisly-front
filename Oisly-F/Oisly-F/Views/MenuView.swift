//
//  MenuView.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import SwiftUI

struct MenuView: View {
    var negocioId: Int
    @State private var menus: [Menu] = []
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            List(menus, id: \.id) { menu in
                NavigationLink(
                    destination: MenuItemsView(menuId: menu.id),
                    label: {
                        VStack(alignment: .leading) {
                            Text(menu.nombre)
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text(menu.descripcion ?? "")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                )
            }
            .padding()
        }
        .onAppear {
            fetchMenus()
        }
    }

    private func fetchMenus() {
        APIService.shared.fetchMenusByNegocio(negocioId: negocioId) { menus, error in
            DispatchQueue.main.async {
                if let menus = menus {
                    self.menus = menus
                } else {
                    self.errorMessage = error ?? "Error desconocido"
                }
            }
        }
    }
}
