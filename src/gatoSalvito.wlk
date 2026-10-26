import wollok.game.*
import elementos.*

object salvito {
    var property position = game.at(5, 2)
    var property image = "gato_frente.png"
    var oxigeno = 100
    var velocidad = 100 

    // Ciclo de 4 tiempos para la caminata del gato.
    const sufijosCaminata = ["_izq.png", ".png", "_der.png", ".png"]
    var indicePaso = 0

    method oxigeno() = oxigeno
    method velocidad() = velocidad

    // Actualiza la imagen según la dirección y avanza al siguiente cuadro de caminata
    method actualizarSprite(direccionBase) {
        image = direccionBase + sufijosCaminata.get(indicePaso)
        indicePaso = (indicePaso + 1) % sufijosCaminata.size()
    }

    // Cambio de sprite con la posición.
    method moverArriba() {
        image = "gato_espalda.png"
        position = position.up(1)
    }
    method moverAbajo() {
        image = "gato_frente.png"
        position = position.down(1)
    }
    method moverIzquierda() {
        image = "gato_izquierdo.png"
        position = position.left(1)
    }
    method moverDerecha() {
        image = "gato_derecho.png"
        position = position.right(1)
    }

    // Interacción con el ambiente.
    method asimilarAmbiente() {
        if (self.estaEnLaSuperficie()) {
            ambienteCalle.afectarA(self)
        } else {
            self.recuperarAire()
        }
        self.verificarSignosVitales()
    }

    method estaEnLaSuperficie() = position.y() >= 4

    method verificarSignosVitales() {
        if (!self.estaVivo()) {
            game.say(self, "No puedo... respirar...")
        }
    }

    method sufrirImpacto(unaAmenaza) {
        oxigeno = 0.max(oxigeno - unaAmenaza.danioDeOxigeno())
        velocidad = 0.max(velocidad - unaAmenaza.danioDeVelocidad())
    }

    method recuperarVelocidad() {
        velocidad = 100.min(velocidad + 30)
    }

    method recuperarAire() {
        oxigeno = 100.min(oxigeno + 10)
    }

    method estaVivo() = oxigeno > 0
}