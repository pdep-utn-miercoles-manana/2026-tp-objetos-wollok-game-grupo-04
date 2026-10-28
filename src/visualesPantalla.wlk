import wollok.game.*
import gatoSalvito.*

object fondo {
    var property image = "nivel1.png"
    method position() = game.origin()
}

object iconoPecera {
    method position() = game.at(0, game.height() - 1) 
    method image() = "icono_pecera.png" 
}

object medidorOxigeno {
    method position() = game.at(0, game.height() - 2) 
    method text() = "OXÍGENO: " + salvito.oxigeno().toString() + "%" 
    method textColor() = "00FF00FF" 
}

object pantallaDeTitulo {
    method position() = game.origin() 
    method image() = "titulo.png"
}

object pantallaGameOver {
    method position() = game.origin()
    method image() = "game_over.png"
}

object pantallaGanaste {
    method position() = game.origin()
    method image() = "ganaste.png"
}