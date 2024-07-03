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
    @State private var bio = ""
    @State private var selection: String? = nil
    @State private var facultadOptions: [Facultad] = []
    @State private var selectedFacultadId: Int?
    @State private var userId: Int?
    @State private var rolId: Int?
    @State private var facultadId: Int?
    
    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    NavigationLink(
                        destination: ProfileView(
                            name: $name,
                            email: $email,
                            selectedFacultad: $selectedFacultad,
                            bio: $bio,
                            userId: $userId,
                            password: password,
                            rolId: rolId ?? 0,
                            facultadId: facultadId ?? 0
                        )
                    ) {
                        Text("Ver Perfil")
                            .padding()
                            .background(Color(red: 188/255, green: 184/255, blue: 206/255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

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
                        .padding()
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
                    fetchFacultadOptions {
                        getFacultades()
                        getCategorias()
                        getNegocios()
                    }
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
                        fetchFacultadOptions {
                            loginUser()
                        }
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
                    
                    Picker("Selecciona una facultad", selection: $selectedFacultad) {
                        ForEach(facultadOptions, id: \.id) { facultad in
                            Text(facultad.nombre)
                                .tag(facultad as Facultad?)
                        }
                    }
                    .onChange(of: selectedFacultad) { newValue in
                        if let selectedFacultad = newValue {
                            selectedFacultadId = selectedFacultad.id
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    TextField("Bio", text: $bio)
                        .padding()
                        .background(Color.gray.opacity(0.1))
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
                .onAppear {
                    fetchFacultadOptions()
                }
            }
        }
    }

    private func getFacultades() {
        APIService.shared.fetchFacultades { facultades, error in
            DispatchQueue.main.async {
                if let facultades = facultades {
                    self.facultades = facultades
                } else {
                    self.errorMessage = error ?? "Error desconocido al cargar las facultades"
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

    private func fetchFacultadOptions(completion: @escaping () -> Void = {}) {
        APIService.shared.fetchFacultades { facultades, error in
            DispatchQueue.main.async {
                if let facultades = facultades {
                    self.facultadOptions = facultades
                    print("Facultades cargadas:", facultades) // Verificar que se cargan las facultades
                    completion()
                } else {
                    self.errorMessage = error ?? "Error al cargar las facultades"
                }
            }
        }
    }

    private func loginUser() {
           // Lógica para iniciar sesión, obteniendo rolId y facultadId
           APIService.shared.loginUser(email: email, password: password) { success, response, error in
               DispatchQueue.main.async {
                   if success {
                       if let responseDict = response,
                          let userDict = responseDict["user"] as? [String: Any] {
                           
                           if let name = userDict["nombre"] as? String {
                               self.name = name
                           }
                           
                           if let facultadId = userDict["facultad_id"] as? Int {
                               // Asignar facultadId desde la respuesta del servidor
                               self.selectedFacultad = self.facultadOptions.first(where: { $0.id == facultadId })
                               self.facultadId = facultadId
                           }
                           
                           if let bio = userDict["bio"] as? String {
                               self.bio = bio
                           }
                           
                           if let id = userDict["id"] as? Int {
                               self.userId = id
                           }
                           
                           // Asignar rolId según la lógica de tu aplicación
                           self.rolId = 1 // Esto es un ejemplo, asigna rolId según corresponda
                           
                           self.isLoggedIn = true
                           self.successMessage = "Inicio de sesión exitoso"
                           self.errorMessage = ""
                           
                       } else {
                           self.errorMessage = "Respuesta inválida del servidor"
                           self.successMessage = ""
                       }
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
        guard let selectedFacultadId = selectedFacultad?.id else {
            errorMessage = "Selecciona una facultad"
            return
        }
        
        // Llamar a APIService para registrar usuario con selectedFacultadId
        APIService.shared.addUser(name: name, email: email, password: password, facultadId: selectedFacultadId, bio: bio) { success, error in
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

