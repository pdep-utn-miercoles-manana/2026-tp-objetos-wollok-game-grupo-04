import wollok.game.*
import elementos.*
import gatoSalvito.*
import niveles.*

object gestorDeNivel {
    const nivelesDeJuego = [nivelUno, nivelDos, nivelTres] 
    var indice = 0 
    var piezasRecolectadas = 0

    method nivelActual() = nivelesDeJuego.get(indice) 

    method iniciarJuego() {
        self.nivelActual().cargarNivel()
    }

    method recolectarPieza() {
        piezasRecolectadas += 1
        if (self.completoPiezasDelNivel()) {
            self.pasarASiguienteNivel()
        }
    }

    method completoPiezasDelNivel() = piezasRecolectadas == 2

    method pasarASiguienteNivel() {
        piezasRecolectadas = 0
        indice += 1
        if (self.hayMasNiveles()) { 
            self.nivelActual().cargarNivel()
        } else {
            self.ganarJuego()
        }
    }

    method hayMasNiveles() = indice < nivelesDeJuego.size()

    method ganarJuego() {
        game.boardGround("refugio.png")
        game.removeTickEvent("cicloDeOxigeno")
        gestorClima.frenarNevada()
        game.say(salvito, "¡Llegué al refugio! Creo que escucho humanos hablando...")
    }
}

object gestorClima {
    const coposEnPantalla = []
    var tiempoGeneracion = 1500
    var tiempoCaida = 300
    var nevando = false

    method iniciarNevada() {
        self.arrancarTicks()
    }

    method arrancarTicks() {
        nevando = true
        game.onTick(tiempoGeneracion, "generarNieve", {
            self.generarCopo()
        })
        game.onTick(tiempoCaida, "caidaDeNieve", {
            self.actualizarCaidaDeCopos()
        })
    }

    method generarCopo() {
        const xAleatorio = 0.randomUpTo(game.width()).truncate(0)
        const yTecho = game.height() - 1
        const nuevoCopo = new NieveToxica(position = game.at(xAleatorio, yTecho)) 
        game.addVisual(nuevoCopo)
        coposEnPantalla.add(nuevoCopo)
    }

    method actualizarCaidaDeCopos() {
        const coposAEliminar = coposEnPantalla.filter({ copo => copo.llegoAlSubte() })
        coposAEliminar.forEach({ copo => self.eliminarCopo(copo) })
        coposEnPantalla.forEach({ copo => copo.caer() })
    }

    method eliminarCopo(unCopo) {
        if (game.hasVisual(unCopo)) {
            game.removeVisual(unCopo)
        }
        coposEnPantalla.remove(unCopo)
    }

    method cambiarDificultad(nuevoTiempoGen, nuevoTiempoCaida) {
        self.frenarNevada()
        tiempoGeneracion = nuevoTiempoGen
        tiempoCaida = nuevoTiempoCaida
        self.arrancarTicks()
    }
    
    method frenarNevada() {
        if (nevando) {
            coposEnPantalla.copy().forEach({ copo => self.eliminarCopo(copo) })
            game.removeTickEvent("generarNieve")
            game.removeTickEvent("caidaDeNieve")
            nevando = false
        }
    }
}