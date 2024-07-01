//
//  ContentView.swift
//  Oisly-Frontend
//
//  Created by Diana Ovalle on 01/07/24.
//


import Foundation
import SwiftUI
import Vision

struct ContentView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var negocios: [Negocio] = []
    @State private var selection: String? = nil
    @State private var selectedNegocio: Negocio? = nil

    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    List(negocios, id: \.id) { negocio in
                        NavigationLink(
                            destination: MenuView(negocioId: negocio.id),
                            label: {
                                VStack(alignment: .leading) {
                                    Text(negocio.nombre)
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                    Text(negocio.descripcion ?? "")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                        )
                    }
                    .padding()

                    Button("Cerrar sesión") {
                        logoutUser()
                    }
                    .padding()
                    .foregroundColor(.red)
                }
                .onAppear {
                    getNegocios()
                }
            }
        } else {
            if selection == nil {
                WelcomeView(selection: $selection)
            } else if selection == "login" {
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    Button("Iniciar sesión") {
                        loginUser()
                    }
                    .padding()
                    .background(Color.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Volver") {
                        selection = nil
                    }
                    .padding()
                    .foregroundColor(.blue)

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
                }
                .padding()
            } else if selection == "register" {
                VStack {
                    TextField("Nombre", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    Button("Registrarse") {
                        registerUser()
                    }
                    .padding()
                    .background(Color.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Volver") {
                        selection = nil
                    }
                    .padding()
                    .foregroundColor(.blue)

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
                }
                .padding()
            }
        }
    }

    private func getNegocios() {
        APIService.shared.fetchNegocios { negocios, error in
            DispatchQueue.main.async {
                if let negocios = negocios {
                    self.negocios = negocios
                } else {
                    self.errorMessage = error ?? "Error desconocido"
                }
            }
        }
    }

    private func loginUser() {
        APIService.shared.loginUser(email: email, password: password) { success, response, error in
            DispatchQueue.main.async {
                if success {
                    self.isLoggedIn = true
                    self.successMessage = "Inicio de sesión exitoso"
                    self.errorMessage = ""
                } else {
                    self.errorMessage = error ?? "Error al iniciar sesión"
                    self.successMessage = ""
                }
            }
        }
    }

    private func logoutUser() {
        isLoggedIn = false
        email = ""
        password = ""
    }

    private func registerUser() {
        APIService.shared.addUser(name: name, email: email, password: password) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.successMessage = "Registro exitoso"
                    self.errorMessage = ""
                    self.selection = "login"
                } else {
                    self.errorMessage = error ?? "Error al registrarse"
                    self.successMessage = ""
                }
            }
        }
    }
}
