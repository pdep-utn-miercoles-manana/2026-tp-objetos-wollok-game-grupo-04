import wollok.game.*
import gatoSalvito.*

object iconoPecera {
    method position() = game.at(0, game.height() - 1) 
    method image() = "icono_pecera.png" 
}

object medidorOxigeno {
    method position() = game.at(0, game.height() - 2) 
    method text() = "OXÍGENO: " + salvito.oxigeno().toString() + "%" 
    method textColor() = "00FF00FF" 
}