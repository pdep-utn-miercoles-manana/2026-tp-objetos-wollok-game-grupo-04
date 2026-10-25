import wollok.game.*
import gestores.*

class NieveToxica {
    var property position
    var property image = "Nieve.png"

    method danioDeOxigeno() = 30
    method danioDeVelocidad() = 20
    
    method afectarA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
        game.removeVisual(self)
    }
}

class LataAtun {
    var property position
    var property image = "Lata.png"

    method afectarA(unMichinauta) {
        unMichinauta.recuperarVelocidad()
        game.removeVisual(self)
    }
}

class PiezaDeLore {
    var property position
    var property image 
    var property nombreDeLaPieza

    method afectarA(unMichinauta) {
        // El gestor de nivel suma 1 al progreso.
        gestorDeNivel.recolectarPieza()
        game.say(unMichinauta, "Encontré: ¡" + nombreDeLaPieza + "! :O")
        game.removeVisual(self)
    }
}
// Representa la calle por la que cae nieve tóxica.
object ambienteCalle {
    method danioDeOxigeno() = 5
    method danioDeVelocidad() = 0
    
    method afectarA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }
}