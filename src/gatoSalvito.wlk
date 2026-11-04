import wollok.game.*
import elementos.*
import gestores.*

object salvito {
    // Columna 4 (x = 3), Fila 10 (y = 0)
    const posicionInicial = game.at(3, 0)
    var property position = posicionInicial
    var property image = "gato_frente.png"
    var oxigeno = 100
    var velocidad = 100 
    var puedeMoverse = true

    const sufijosCaminata = ["_izq.png", ".png", "_der.png", ".png"]
    var indicePaso = 0

    // Filas prohibidas (notación 1 a 10 de arriba hacia abajo) para cada columna (1 a 16 de izquierda a derecha)
    const filasNoPermitidasPorColumna = [
        [1, 7, 8, 9],        // Columna 1 (x = 0)
        [1, 7, 8, 9],        // Columna 2 (x = 1)
        [1, 7, 8, 9],        // Columna 3 (x = 2)
        [1, 7, 8],           // Columna 4 (x = 3)
        [1, 7, 8],           // Columna 5 (x = 4)
        [1, 7, 8],           // Columna 6 (x = 5)
        [1, 7, 8, 9],        // Columna 7 (x = 6)
        [1, 7, 8, 9],        // Columna 8 (x = 7)
        [1, 7, 8],           // Columna 9 (x = 8)
        [1, 3, 7, 8],        // Columna 10 (x = 9)
        [1, 3, 7, 8],        // Columna 11 (x = 10)
        [1, 2, 3, 7, 8],     // Columna 12 (x = 11)
        [1, 2, 7, 8],        // Columna 13 (x = 12)
        [1, 2],              // Columna 14 (x = 13)
        [1, 2, 7, 8, 9, 10], // Columna 15 (x = 14)
        [1, 2, 7, 8, 9, 10]  // Columna 16 (x = 15)
    ]

    method oxigeno() = oxigeno
    method velocidad() = velocidad

    method actualizarSprite(direccionBase) {
        image = direccionBase + sufijosCaminata.get(indicePaso)
        indicePaso = (indicePaso + 1) % sufijosCaminata.size()
    }

    method dentroDelTablero(unaPosicion) =
        unaPosicion.x().between(0, game.width() - 1) and
        unaPosicion.y().between(0, game.height() - 1)

    method filaSegunNotacion(unaPosicion) = 10 - unaPosicion.y()

    method esCeldaPermitida(unaPosicion) =
        !filasNoPermitidasPorColumna.get(unaPosicion.x()).contains(self.filaSegunNotacion(unaPosicion))

    method puedeCaminarEn(unaPosicion) =
        self.dentroDelTablero(unaPosicion) and self.esCeldaPermitida(unaPosicion)

    method avanzarSiPuedeA(nuevaPosicion) {
        if (self.puedeCaminarEn(nuevaPosicion)) {
            position = nuevaPosicion
        }
    }

    method tiempoEsperaPaso() = (100 - velocidad) * 8

    method intentarMover(accionDeMovimiento) {
        if (puedeMoverse and self.estaVivo() and velocidad > 0) {
            accionDeMovimiento.apply()
            if (self.tiempoEsperaPaso() > 0) {
                puedeMoverse = false
                game.schedule(self.tiempoEsperaPaso(), { puedeMoverse = true })
            }
        }
    }

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
            gestorDeNivel.perderJuego()
        }
    }

    method sufrirImpacto(unaAmenaza) {
        oxigeno = 0.max(oxigeno - unaAmenaza.danioDeOxigeno())
        velocidad = 0.max(velocidad - unaAmenaza.danioDeVelocidad())
        self.verificarSignosVitales()
    }

    method recuperarVelocidad() {
        velocidad = 100.min(velocidad + 30)
    }

    method recuperarAire() {
        oxigeno = 100.min(oxigeno + 10)
    }

    method detener() {
        puedeMoverse = false
    }

    method habilitarMovimiento() {
        puedeMoverse = true
    }

    method reiniciar() {
        position = posicionInicial
        image = "gato_frente.png"
        oxigeno = 100
        velocidad = 100
        indicePaso = 0
        puedeMoverse = true
    }

    method estaVivo() = oxigeno > 0
}