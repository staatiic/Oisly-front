import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var negocios: [Negocio] = []
    @State private var facultades: [Facultad] = []
    @State private var categorias: [Categoria] = []
    @State private var selectedFacultad: Facultad?
    @State private var selectedCategoria: Categoria?
    @State private var selection: String? = nil

    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    HStack {
                        Text("Todos los negocios:")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()

                    HStack {
                              NavigationLink(destination: FacultadesView(facultades: facultades, negocios: $negocios, selectedFacultad: $selectedFacultad)) {
                                  Text("Selecciona la facultad")
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                                      .cornerRadius(10)
                              }
                              .padding()

                              NavigationLink(destination: CategoriasView(categorias: categorias, negocios: $negocios, selectedCategoria: $selectedCategoria)) {
                                  Text("Selecciona la categoría")
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                                      .cornerRadius(10)
                              }
                          }

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

                    Button("Cerrar sesión") {
                        logoutUser()
                    }
                    .padding()
                    .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .background(Color.gray.opacity(0.1))
                .onAppear {
                    getFacultades()
                    getCategorias()
                    getNegocios()
                }
            }
        } else {
            if selection == nil {
                WelcomeView(selection: $selection)
            } else if selection == "login" {
                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    Button("Iniciar sesión") {
                        loginUser()
                    }
                    .padding()
                    .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Volver") {
                        selection = nil
                    }
                    .padding()
                    .foregroundColor(.gray)

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
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)

                    Button("Registrarse") {
                        registerUser()
                    }
                    .padding()
                    .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Volver") {
                        selection = nil
                    }
                    .padding()
                    .foregroundColor(.gray)

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

    private func getFacultades() {
        APIService.shared.fetchFacultades { facultades, error in
            DispatchQueue.main.async {
                if let facultades = facultades {
                    self.facultades = facultades
                } else {
                    self.errorMessage = error ?? "Error desconocido"
                }
            }
        }
    }

    private func getCategorias() {
        APIService.shared.fetchCategorias { categorias, error in
            DispatchQueue.main.async {
                if let categorias = categorias {
                    self.categorias = categorias
                } else {
                    self.errorMessage = error ?? "Error desconocido"
                }
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
