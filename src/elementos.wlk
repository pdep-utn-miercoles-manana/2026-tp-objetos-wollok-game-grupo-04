import wollok.game.*
import gestores.*
import gatoSalvito.*

class ElementoDeSuperficie {
    var property position

    method image()

    method afectarA(unMichinauta) {
        self.desaparecer()
        self.aplicarEfectoA(unMichinauta)
    }

    method aplicarEfectoA(unMichinauta)

    method desaparecer() {
        if (game.hasVisual(self)) {
            game.removeVisual(self)
        }
    }

    method cambiarPosicionAleatoria() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 4.randomUpTo(game.height()).truncate(0)
        const nuevaPos = game.at(x, y)
        if (salvito.puedeCaminarEn(nuevaPos) and nuevaPos != salvito.position()) {
            position = nuevaPos
        }
    }
}

class CopoDeNieve inherits ElementoDeSuperficie {
    override method desaparecer() {
        gestorClima.eliminarCopo(self)
    }

    method calcularNuevoX() =
        if (gestorClima.movimientoHorizontalActivo())
            (position.x() + [-1, 1].anyOne()).max(0).min(game.width() - 1)
        else
            position.x()

    method caer() {
        position = game.at(self.calcularNuevoX(), position.y() - 1)
    }

    method llegoAlSubte() = position.y() <= 4
}

class NieveToxica inherits CopoDeNieve {
    override method image() = "Nieve.png"

    method danioDeOxigeno() = 30
    method danioDeVelocidad() = 20
    
    override method aplicarEfectoA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }
}

class CopoMiniatura inherits CopoDeNieve {
    override method image() = "copito.png"

    override method afectarA(unMichinauta) {
        // Es decorativo: no hace nada ni desaparece
    }

    override method aplicarEfectoA(unMichinauta) {}

    // Cuando llega abajo vuelve arriba sin crear ni destruir objetos
    override method caer() {
        if (self.llegoAlSubte()) {
            const xAleatorio = 0.randomUpTo(game.width()).truncate(0)
            position = game.at(xAleatorio, game.height() - 1)
        } else {
            super()
        }
    }
}

class LataAtun inherits ElementoDeSuperficie {
    override method image() = "Lata.png"

    override method aplicarEfectoA(unMichinauta) {
        unMichinauta.recuperarVelocidad()
        gestorDeNivel.mostrarDialogo("dialogo_atun.png")
    }
}

class PiezaDeLore inherits ElementoDeSuperficie {
    const image
    const nombreDeLaPieza
    const imagenDialogo = "dialogo_" + image

    override method image() = image
    method nombreDeLaPieza() = nombreDeLaPieza

    override method aplicarEfectoA(unMichinauta) {
        gestorDeNivel.recolectarPiezaConDialogo(imagenDialogo)
    }
}

object ambienteCalle {
    method danioDeOxigeno() = 5
    method danioDeVelocidad() = 0
    
    method afectarA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }
}