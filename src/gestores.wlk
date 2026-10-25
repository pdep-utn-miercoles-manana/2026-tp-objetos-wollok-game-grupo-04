import wollok.game.*
import elementos.*
import gatoSalvito.*
import niveles.*

object gestorDeNivel {
    var property nivelesDeJuego = [nivelUno, nivelDos, nivelTres] 
    var property indice = 0 
    var piezasRecolectadas = 0

    method nivelActual() = nivelesDeJuego.get(indice) 
    method iniciarJuego() {
        self.nivelActual().cargarNivel()
    }
    method recolectarPieza() {
        piezasRecolectadas += 1
        if (piezasRecolectadas == 3) {
            self.pasarASiguienteNivel()
        }
    }
    method pasarASiguienteNivel() {
        piezasRecolectadas = 0
        indice = indice + 1
        if (indice < nivelesDeJuego.size()) { 
            self.nivelActual().cargarNivel()
        } else {
            // BONUS TRACK.
            game.boardGround("refugio.png")
            gestorClima.frenarNevada()
            game.say(salvito, "¡Llegué al refugio! Creo que escucho humanos hablando...")
        }
    }
}

object gestorClima {
    const coposEnPantalla = []
    var tiempoGeneracion = 1500
    var tiempoCaida = 300

    method iniciarNevada() {
        self.arrancarTicks()
    }
    method arrancarTicks() {
        // Generar copos de nieve aleatoriamente.
        game.onTick(tiempoGeneracion, "generarNieve", {
            const xAleatorio = 0.randomUpTo(game.width()).truncate(0)
            const yTecho = game.height() - 1
            const nuevoCopo = new NieveToxica(position = game.at(xAleatorio, yTecho)) 
            game.addVisual(nuevoCopo)
            coposEnPantalla.add(nuevoCopo)
        })
        // Caída de los copos.
        game.onTick(tiempoCaida, "caidaDeNieve", {
            coposEnPantalla.forEach({ copo =>
                const nuevaPos = copo.position().down(1)       
                if (nuevaPos.y() < 4) {
                    game.removeVisual(copo)
                    coposEnPantalla.remove(copo)
                } else {
                    copo.position(nuevaPos)
                }
            })
        })
    }
    method cambiarDificultad(nuevoTiempoGen, nuevoTiempoCaida) {
        self.frenarNevada()
        tiempoGeneracion = nuevoTiempoGen
        tiempoCaida = nuevoTiempoCaida
        self.arrancarTicks()
    }
    
    method frenarNevada() {
        game.removeTickEvent("generarNieve")
        game.removeTickEvent("caidaDeNieve")
    }
}