import UIKit

class PrimeraPantalla: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! // Conectar el UIImageView en el storyboard
    
    var imagenes: [String] = ["Coche1", "Coche2", "Coche3", "Coche4", "Coche5", "Coche6", "Coche7", "Coche8"] // Nombres de las imágenes
    var imagenActual = 0
    var temporizador: Timer?
    var contadorCambios = 0 // Contador para el número de cambios
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarBucleDeImagenes()
    }
    
    func iniciarBucleDeImagenes() {
        // Cambia la imagen cada 1 segundo
        temporizador = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(cambiarImagen), userInfo: nil, repeats: true)
    }
    
    @objc func cambiarImagen() {
        // Cambia la imagen del UIImageView
        imageView.image = UIImage(named: imagenes[imagenActual])
        
        // Actualiza el índice
        imagenActual += 1
        
        // Incrementa el contador de cambios
        contadorCambios += 1
        
        // Verifica si se alcanzó el límite de cambios
        if contadorCambios >= 8 {
            temporizador?.invalidate() // Detiene el temporizador
            temporizador = nil // Libera el temporizador

        }
        
        // Reinicia el índice si alcanza el final
        if imagenActual >= imagenes.count {
            imagenActual = 0
        }
    }
    
    deinit {
        temporizador?.invalidate() // Detiene el temporizador
    }
}


