//
//  ViewcontrollerPantalla.swift
//  IOSAPP
//
//  Created by Cristian on 24/10/24.
//

import UIKit

// Clase que representa la pantalla principal del juego.
class ViewcontrollerPantalla: UIViewController {

    // Variables para manejar la puntuación y el número de botones pulsados.
    var puntuacion: Int = 0
    var botonesPulsados: Int = 0

    // Conexiones a los botones del storyboard.
    @IBOutlet weak var boton1: UIButton!
    @IBOutlet weak var boton2: UIButton!
    @IBOutlet weak var boton3: UIButton!
    @IBOutlet weak var boton4: UIButton!
    @IBOutlet weak var boton5: UIButton!
    @IBOutlet weak var boton6: UIButton!
    @IBOutlet weak var boton7: UIButton!
    @IBOutlet weak var boton8: UIButton!
    
    // Conexión al label que muestra la puntuación.
    @IBOutlet weak var puntuacionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura los tags de los botones.
        configurarTagsDeBotones()
        
        // Inicia la puntuación mostrada en la etiqueta.
        puntuacionLabel.text = "Puntuación: \(puntuacion)"
    }


    // Acción que se ejecuta cuando se pulsa un botón.
    @IBAction func botonPulsado(_ sender: UIButton) {
        // Aumenta el contador de botones pulsados.
        botonesPulsados += 1

        // Verifica si el botón pulsado corresponde al siguiente en la secuencia (por tag).
        if sender.tag == botonesPulsados - 1 {
            puntuacion += 1 // Incrementa la puntuación si la secuencia es correcta.
        }

        // Actualiza la etiqueta de puntuación.
        puntuacionLabel.text = "Puntuación: \(puntuacion)"

        // Comprueba si se han pulsado todos los botones.
        if botonesPulsados == 8 {
            // Muestra una alerta para guardar la puntuación.
            mostrarAlertaParaGuardarPuntuacion()
        }
    }


    // Función que muestra una alerta al terminar el juego.
    func mostrarAlertaParaGuardarPuntuacion() {
        // Crea una alerta con un campo de texto para que el usuario introduzca su nombre.
        let alerta = UIAlertController(title: "Juego terminado", message: "Introduce tu nombre", preferredStyle: .alert)

        // Agrega un campo de texto a la alerta.
        alerta.addTextField { textField in
            textField.placeholder = "Tu nombre"
        }

        // Acción para guardar la puntuación al pulsar el botón "Guardar".
        let guardarAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            if let nombre = alerta.textFields?.first?.text, !nombre.isEmpty {
                // Guarda la puntuación localmente.
                self.guardarPuntuacion(nombre: nombre)
                
                // Navega a la pantalla de puntuaciones.
                self.performSegue(withIdentifier: "irAPantallaPuntuacion", sender: self)
            }
        }

        // Agrega la acción a la alerta y la muestra.
        alerta.addAction(guardarAction)
        present(alerta, animated: true)
    }

    // Función que guarda la puntuación en UserDefaults.
    func guardarPuntuacion(nombre: String) {
        // Recupera las puntuaciones existentes desde UserDefaults, o crea un array vacío si no hay datos.
        var puntuaciones = UserDefaults.standard.array(forKey: "puntuaciones") as? [[String: Any]] ?? []
        
        // Agrega la nueva puntuación al array.
        puntuaciones.append(["name": nombre, "score": puntuacion])
        
        // Guarda el array actualizado en UserDefaults.
        UserDefaults.standard.set(puntuaciones, forKey: "puntuaciones")
    }

    // Asigna un tag a cada botón para identificar su orden.
    func configurarTagsDeBotones() {
        boton1.tag = 0
        boton2.tag = 1
        boton3.tag = 2
        boton4.tag = 3
        boton5.tag = 4
        boton6.tag = 5
        boton7.tag = 6
        boton8.tag = 7
    }
}


