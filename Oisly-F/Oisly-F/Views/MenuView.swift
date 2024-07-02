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
                                .foregroundColor(Color(red: 188/255, green: 184/255, blue: 206/255))
                            Text(menu.descripcion ?? "")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
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
