//
//  Untitled.swift
//  IOSAPP
//
//  Created by Cristian on 18/11/24.
//
import UIKit

// Esta clase maneja la pantalla que muestra puntuaciones online en una tabla.
class PuntuacionesOnlineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Conexión a la tabla en el storyboard.
    @IBOutlet weak var tableView: UITableView!
    
    // Variable que almacena las puntuaciones obtenidas online.
    // Cada puntuación incluye un nombre y una puntuación.
    var puntuacionesOnline: [(nombre: String, puntuacion: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el delegado y la fuente de datos de la tabla.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registra una celda básica para las filas de la tabla.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PuntuacionCell")
        
        // Llama a la función para obtener las puntuaciones desde la API.
        obtenerPuntuacionesOnline()
    }

    // Función para obtener puntuaciones desde una API REST.
    func obtenerPuntuacionesOnline() {
        // Crea la URL de la API que contiene las puntuaciones.
        guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=name,score") else { return }

        // Configura la solicitud HTTP.
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Define el método HTTP como GET.
        
        // Agrega los encabezados de autorización necesarios para la API.
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "Authorization")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")

        // Inicia una tarea de red para obtener datos desde la API.
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Maneja errores de red.
            if let error = error {
                print("Error al obtener puntuaciones: \(error.localizedDescription)")
                return
            }

            // Verifica si se recibieron datos válidos.
            guard let data = data else {
                print("No se recibieron datos de la API")
                return
            }

            // Intenta convertir los datos JSON recibidos en un array de diccionarios.
            if let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                print("Datos obtenidos: \(json)")

                // Procesa los datos y convierte cada entrada en una tupla (nombre, puntuación).
                self.puntuacionesOnline = json.compactMap {
                    if let nombre = $0["name"] as? String, let puntuacion = $0["score"] as? Int {
                        return (nombre, puntuacion)
                    }
                    return nil
                }.sorted { $0.puntuacion > $1.puntuacion } // Ordena las puntuaciones de mayor a menor.

                // Actualiza la tabla en el hilo principal.
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error al parsear los datos")
            }
        }.resume() // Inicia la tarea de red.
    }

    // MARK: - Métodos de UITableViewDataSource

    // Devuelve el número de filas en la tabla, basado en las puntuaciones obtenidas.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puntuacionesOnline.count
    }

    // Configura cada celda de la tabla con los datos de puntuaciones.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Crea o reutiliza una celda con el identificador especificado.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PuntuacionCell")
        
        // Obtiene la puntuación correspondiente a la fila actual.
        let entrada = puntuacionesOnline[indexPath.row]
        // Configura el texto principal y el detalle de la celda.
        cell.textLabel?.text = entrada.nombre
        cell.detailTextLabel?.text = "Puntuación: \(entrada.puntuacion)"
        
        return cell
    }
}
