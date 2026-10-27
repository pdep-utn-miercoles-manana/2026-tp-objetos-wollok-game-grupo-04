import wollok.game.*
import elementos.*

object salvito {
    var property position = game.at(5, 2)
    var property image = "gato_frente.png"
    var oxigeno = 100
    var velocidad = 100 
    var puedeMoverse = true

    // Ciclo de 4 tiempos para la caminata del gato.
    const sufijosCaminata = ["_izq.png", ".png", "_der.png", ".png"]
    var indicePaso = 0

    method oxigeno() = oxigeno
    method velocidad() = velocidad

    // Actualiza la imagen según la dirección y avanza al siguiente cuadro de caminata.
    method actualizarSprite(direccionBase) {
        image = direccionBase + sufijosCaminata.get(indicePaso)
        indicePaso = (indicePaso + 1) % sufijosCaminata.size()
    }

    // Verifica que la casilla destino no se salga de los 4 bordes de la ventana.
    method dentroDelTablero(unaPosicion) =
        unaPosicion.x().between(0, game.width() - 1) and
        unaPosicion.y().between(0, game.height() - 1)

    method avanzarSiPuedeA(nuevaPosicion) {
        if (self.dentroDelTablero(nuevaPosicion)) {
            position = nuevaPosicion
        }
    }

    // Cálculo del retraso según la velocidad actual (0 ms cuando velocidad es 100).
    method tiempoEsperaPaso() = (100 - velocidad) * 8

    // Controla la velocidad de paso en el juego interactivo.
    method intentarMover(accionDeMovimiento) {
        if (puedeMoverse and self.estaVivo() and velocidad > 0) {
            accionDeMovimiento.apply()
            if (self.tiempoEsperaPaso() > 0) {
                puedeMoverse = false
                game.schedule(self.tiempoEsperaPaso(), { puedeMoverse = true })
            }
        }
    }

    // Cambio de sprite y movimiento validando bordes.
    method moverArriba() {
        self.actualizarSprite("gato_espalda")
        self.avanzarSiPuedeA(position.up(1))
    }
    method moverAbajo() {
        self.actualizarSprite("gato_frente")
        self.avanzarSiPuedeA(position.down(1))
    }
    method moverIzquierda() {
        self.actualizarSprite("gato_izquierdo")
        self.avanzarSiPuedeA(position.left(1))
    }
    method moverDerecha() {
        self.actualizarSprite("gato_derecho")
        self.avanzarSiPuedeA(position.right(1))
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