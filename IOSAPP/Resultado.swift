import UIKit

// Esta clase maneja una vista que muestra y permite subir puntuaciones almacenadas localmente.
class Viewcontroller4: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Conexión a la tabla en el storyboard.
    @IBOutlet weak var tableView: UITableView!
    
    // Array que contiene las puntuaciones cargadas. Cada puntuación incluye un nombre y una puntuación.
    var puntuaciones: [(nombre: String, puntuacion: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura el delegado y la fuente de datos de la tabla.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Carga las puntuaciones guardadas localmente.
        cargarPuntuaciones()
    }

    // Esta función carga las puntuaciones almacenadas en UserDefaults.
    func cargarPuntuaciones() {
        // Intenta obtener los datos guardados bajo la clave "puntuaciones".
        if let datosGuardados = UserDefaults.standard.array(forKey: "puntuaciones") as? [[String: Any]] {
            // Convierte los datos en un array de tuplas (nombre, puntuación) si los datos son válidos.
            puntuaciones = datosGuardados.compactMap { dict in
                if let nombre = dict["name"] as? String, let puntuacion = dict["score"] as? Int {
                    return (nombre, puntuacion)
                }
                return nil
            }.reversed() // Da la vuelta al orden para mostrar las puntuaciones más recientes primero.
        }
        // Recarga la tabla para reflejar los datos actualizados.
        tableView.reloadData()
    }


    // Función que se activa al pulsar el botón para subir puntuaciones.
    @IBAction func subirPuntuaciones(_ sender: UIButton) {
        // Recupera las puntuaciones locales almacenadas en UserDefaults.
        if let puntuacionesLocales = UserDefaults.standard.array(forKey: "puntuaciones") as? [[String: Any]] {
            puntuacionesLocales.forEach { puntuacion in
                if let nombre = puntuacion["name"] as? String, let score = puntuacion["score"] as? Int {
                    // Verifica si el usuario ya existe en la base de datos.
                    verificarSiUsuarioExiste(nombre: nombre) { existe in
                        // Si el usuario no existe, envía la puntuación a la API.
                        if !existe {
                            self.enviarPuntuacion(nombre: nombre, puntuacion: score)
                        }
                    }
                }
            }
        }
    }

    // Esta función envía una puntuación específica a la API.
    func enviarPuntuacion(nombre: String, puntuacion: Int) {
        guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") else {
            print("Error: URL no válida")
            return
        }

        // Configura la solicitud HTTP.
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Define el método HTTP como POST.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "Authorization")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")

        // Define el cuerpo de la solicitud con los datos de la puntuación.
        let body: [String: Any] = ["name": nombre, "score": puntuacion]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // Envía la solicitud a la API.
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al enviar puntuación: \(error.localizedDescription)")
                return
            }

            // Verifica la respuesta de la API.
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: No se recibió una respuesta HTTP válida")
                return
            }

            // Comprueba si la puntuación fue enviada correctamente.
            if httpResponse.statusCode == 201 {
                print("Puntuación enviada correctamente")
            } else {
                print("Error al enviar puntuación, código: \(httpResponse.statusCode)")
            }
        }.resume()
    }

    // Función que verifica si un usuario ya existe en la base de datos.
    func verificarSiUsuarioExiste(nombre: String, completion: @escaping (Bool) -> Void) {
        // Construye la URL de la API con un filtro para buscar por nombre.
        guard let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?name=eq.\(nombre)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Define el método HTTP como GET.
        
        // Agrega los encabezados de autorización requeridos.
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "Authorization")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")

        // Envía la solicitud para comprobar la existencia del usuario.
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]], !json.isEmpty {
                // Si se encuentra el usuario.
                completion(true)
            } else {
                // Si no se encuentra el usuario.
                completion(false)
            }
        }.resume()
    }

    // Devuelve el número de filas en la tabla..
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puntuaciones.count
    }

    // Configura cada celda de la tabla con las puntuaciones.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Crea o reutiliza una celda para mostrar la puntuación.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PuntuacionCell")
        let entrada = puntuaciones[indexPath.row]
        
        // Configura el texto principal y el detalle de la celda.
        cell.textLabel?.text = entrada.nombre
        cell.detailTextLabel?.text = "Puntuación: \(entrada.puntuacion)"
        return cell
    }
}
