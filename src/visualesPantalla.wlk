import wollok.game.*
import gatoSalvito.*

object fondo {
    var property image = "nivel1.png"
    method position() = game.origin()
}

// --- HUD DE OXÍGENO (Esquina superior derecha: x=11, y=9) ---
object barraOxigeno {
    method position() = game.at(11, game.height() - 1)
    
    method nivelVisual() {
        if (salvito.oxigeno() > 80) return 100
        if (salvito.oxigeno() > 60) return 80
        if (salvito.oxigeno() > 40) return 60
        if (salvito.oxigeno() > 20) return 40
        if (salvito.oxigeno() > 0) return 20
        return 0
    }
    
    method image() = "oxigeno_" + self.nivelVisual().toString() + ".png"
}

// --- HUD DE VELOCIDAD (Debajo del oxígeno: x=11, y=8) ---
object barraVelocidad {
    method position() = game.at(11, game.height() - 2)
    
    method nivelVisual() {
        if (salvito.velocidad() > 80) return 100
        if (salvito.velocidad() > 60) return 80
        if (salvito.velocidad() > 40) return 60
        if (salvito.velocidad() > 20) return 40
        if (salvito.velocidad() > 0) return 20
        return 0
    }
    
    method image() = "velocidad_" + self.nivelVisual().toString() + ".png"
}

// --- PANTALLAS DE FLUJO, INTRO, DIÁLOGOS OTOME Y TRANSICIONES ---
object pantallaIntro {
    var property image = "intro_negro.png"
    method position() = game.origin()
}

object pantallaDeTitulo {
    method position() = game.origin() 
    method image() = "titulo.png"
}

object pantallaInstrucciones {
    method position() = game.origin()
    method image() = "instrucciones.png"
}

object pantallaDialogo {
    var property image = "dialogo_atun.png"
    method position() = game.origin()
}

object pantallaTransicion {
    var property image = "transicion_nivel2.png"
    method position() = game.origin()
}

object pantallaGameOver {
    method position() = game.origin()
    method image() = "game_over.png"
}

object pantallaGanaste {
    method position() = game.origin()
    method image() = "ganaste.png"
}