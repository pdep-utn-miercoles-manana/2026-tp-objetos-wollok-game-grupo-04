import wollok.game.*

class NieveToxica {
    var property position
    var property image = "Nieve.png"

    method danoDeOxigeno() = 30
    method danoDeVelocidad() = 20
    
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

// Representa la calle por la que cae nieve tóxica.
object ambienteCalle {
    method danioDeOxigeno() = 5
    method danioDeVelocidad() = 0
    
    method afectarA(unMichinauta) {
        unMichinauta.sufrirImpacto(self)
    }
}