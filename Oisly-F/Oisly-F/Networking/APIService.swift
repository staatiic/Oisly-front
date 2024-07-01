//
//  APIService.swift
//  Oisly-F
//
//  Created by Diana Ovalle on 01/07/24.
//

import Foundation
import SwiftUI

class APIService {
    static let shared = APIService()
    
    func addUser(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/users/") else {
            completion(false, "Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "rol_id": 1
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(false, "Error al crear el cuerpo de la solicitud")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Error de respuesta del servidor")
                return
            }
            
            if httpResponse.statusCode == 201 {
                completion(true, nil)
            } else {
                let errorDescription = String(data: data ?? Data(), encoding: .utf8) ?? "Error desconocido"
                completion(false, errorDescription)
            }
        }.resume()
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, [String: Any]?, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/users/login") else {
            completion(false, nil, "Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(false, nil, "Error al crear el cuerpo de la solicitud")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, nil, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil, "Error de respuesta del servidor")
                return
            }
            
            if httpResponse.statusCode == 200, let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completion(true, json, nil)
                } catch {
                    completion(false, nil, error.localizedDescription)
                }
            } else {
                let errorDescription = String(data: data ?? Data(), encoding: .utf8) ?? "Error desconocido"
                completion(false, nil, errorDescription)
            }
        }.resume()
    }
    
    func fetchMenusByNegocio(negocioId: Int, completion: @escaping ([Menu]?, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/menus/negocio/\(negocioId)") else {
            completion(nil, "URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "Datos no válidos")
                return
            }
            
            do {
                let menus = try JSONDecoder().decode([Menu].self, from: data)
                completion(menus, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchNegocios(completion: @escaping ([Negocio]?, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/negocios") else {
            completion(nil, "URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "Datos no válidos")
                return
            }
            
            do {
                let negocios = try JSONDecoder().decode([Negocio].self, from: data)
                completion(negocios, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
    func fetchItemsByMenu(menuId: Int, completion: @escaping ([Item]?, String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/v1/items/menu/\(menuId)") else {
            completion(nil, "URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "Datos no válidos")
                return
            }
            
            do {
                // Imprimir la respuesta en formato JSON
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Datos recibidos del servidor: \(jsonString)")
                }
                
                let items = try JSONDecoder().decode([Item].self, from: data)
                completion(items, nil)
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
}

