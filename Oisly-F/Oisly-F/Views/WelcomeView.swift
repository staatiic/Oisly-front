//
//  WelcomeView.swift
//  Oisly
//
//  Created by Diana Ovalle on 01/07/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var selection: String?

    var body: some View {
        VStack {
            Text("Bienvenido")
                .font(.largeTitle)
                .padding()

            Button("Iniciar sesión") {
                selection = "login"
            }
            .padding()
            .background(Color(red: 188/255, green: 184/255, blue: 206/255))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom)

            Button("Registrarse") {
                selection = "register"
            }
            .padding()
            .background(Color.gray.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
