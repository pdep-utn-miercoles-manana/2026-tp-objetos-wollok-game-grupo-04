import wollok.game.*
import gestores.*
import gatoSalvito.*

class ElementoDeSuperficie {
    var property position

    method image()

    method afectarA(unMichinauta) {
        self.aplicarEfectoA(unMichinauta)
        self.desaparecer()
    }

    method aplicarEfectoA(unMichinauta)

    method desaparecer() {
        game.removeVisual(self)
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

    // En lugar de destruir y crear objetos nuevos (que da lag), cuando llega abajo vuelve arriba
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
    }
}

class PiezaDeLore inherits ElementoDeSuperficie {
    const image
    const nombreDeLaPieza

    override method image() = image

    override method aplicarEfectoA(unMichinauta) {
        game.say(unMichinauta, "Encontré: ¡" + nombreDeLaPieza + "! :O")
        gestorDeNivel.recolectarPieza()
    }
}

object ambienteCalle {
    method danioDeOxigeno() = 5
    method danioDeVelocidad() = 0
    
    method afectarA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }
}