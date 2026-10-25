import wollok.game.*
import elementos.*

object salvito {
    var property position = game.at(5, 2)
    var property image = "gatoMichinauta.png"
    var oxigeno = 100
    var velocidad = 100 

    method oxigeno() = oxigeno
    method velocidad() = velocidad

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
    method asimilarAmbiente() {
        if (self.position().y() >= 4) {
            ambienteCalle.afectarA(self)
        } else {
            self.recuperarAire()
        }
    if (!self.estaVivo()) {
        game.say(self, "No puedo... respirar...")
    }
}
}