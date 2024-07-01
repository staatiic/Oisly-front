//
//  MenuItemsView.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import SwiftUI

struct MenuItemsView: View {
    var menuId: Int
    @State private var items: [Item] = []
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List(items, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text(item.nombre)
                        .font(.headline)
                        .foregroundColor(.purple)
                    Text(item.descripcion)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text(String(format: "$%.2f", item.precio))
                        .foregroundColor(.blue)
                        .font(.body)
                }
            }
            .padding()
        }
        .onAppear {
            fetchItems()
        }
    }
    
    private func fetchItems() {
        APIService.shared.fetchItemsByMenu(menuId: menuId) { items, error in
            DispatchQueue.main.async {
                if let items = items {
                    self.items = items
                } else {
                    self.errorMessage = error ?? "Error desconocido"
                }
            }
        }
    }
}
