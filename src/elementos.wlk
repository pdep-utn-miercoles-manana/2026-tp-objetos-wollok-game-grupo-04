import wollok.game.*
import gestores.*

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
}

class NieveToxica inherits ElementoDeSuperficie {
    override method image() = "Nieve.png"

    method danioDeOxigeno() = 30
    method danioDeVelocidad() = 20
    
    override method aplicarEfectoA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }

    override method desaparecer() {
        gestorClima.eliminarCopo(self)
    }

    method caer() {
        position = position.down(1)
    }

    method llegoAlSubte() = position.down(1).y() < 4
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