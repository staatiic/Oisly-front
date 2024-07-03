//
//  ProfileView.swift
//  Oisly-F
//
//  Created by Diana Ovalle on 02/07/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var selectedFacultad: Facultad?
    @Binding var bio: String
    @Binding var userId: Int?
    
    let password: String
    let rolId: Int
    let facultadId: Int
    
    @State private var isEditingName = false
    @State private var isEditingBio = false
    @State private var showSaveButton = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Perfil del Usuario")
                .font(.title)
                .foregroundColor(Color(red: 188/255, green: 184/255, blue: 206/255))
            
            VStack(alignment: .leading, spacing: 10) {
                if isEditingName {
                    TextField("Nombre", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    HStack {
                        Text("Nombre:")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text(name)
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        isEditingName.toggle()
                        showSaveButton = true
                    }) {
                        Text(isEditingName ? "Guardar" : "Editar")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isEditingName ? Color.green : Color(red: 188/255, green: 184/255, blue: 206/255))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1)) 
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 10) {
                if isEditingBio {
                    TextField("Bio", text: $bio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    HStack {
                        Text("Bio:")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text(bio)
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        isEditingBio.toggle()
                        showSaveButton = true
                    }) {
                        Text(isEditingBio ? "Guardar" : "Editar")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isEditingBio ? Color.green : Color(red: 188/255, green: 184/255, blue: 206/255))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Email:")
                    .foregroundColor(.black)
                    .font(.headline)
                Text(email)
                    .foregroundColor(.black)
                    .font(.body)
                
                if let facultad = selectedFacultad {
                    HStack {
                        Text("Facultad:")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text(facultad.nombre)
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("Facultad:")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text("No definida")
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            if showSaveButton {
                Button(action: saveChanges) {
                    Text("Guardar Cambios")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func saveChanges() {
        guard let userId = userId else {
            print("Error: No se encontró el ID del usuario")
            return
        }
        
        guard !name.isEmpty else {
            errorMessage = "El nombre no puede estar vacío"
            return
        }
        
        APIService.shared.updateUserProfile(userId: userId, name: name, bio: bio, email: email, password: password, rolId: rolId, facultadId: facultadId) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isEditingName = false
                    self.isEditingBio = false
                    self.showSaveButton = false
                    self.errorMessage = ""
                    print("Cambios guardados exitosamente")
                } else {
                    self.errorMessage = error ?? "Error al guardar los cambios"
                    print("Error al guardar los cambios: \(error ?? "Error desconocido")")
                }
            }
        }
    }
}
