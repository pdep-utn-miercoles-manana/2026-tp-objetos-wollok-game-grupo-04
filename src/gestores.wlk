import wollok.game.*
import elementos.*
import gatoSalvito.*
import niveles.*
import visualesPantalla.*

object gestorDeNivel {
    const nivelesDeJuego = [nivelUno, nivelDos, nivelTres] 
    var indice = 0 
    var piezasRecolectadas = 0
    var cicloOxigenoActivo = false
    var esperandoReinicio = false

    method nivelActual() = nivelesDeJuego.get(indice) 

    method iniciarJuego() {
        esperandoReinicio = false
        self.iniciarCicloOxigeno()
        self.nivelActual().cargarNivel()
    }

    method iniciarCicloOxigeno() {
        if (!cicloOxigenoActivo) {
            cicloOxigenoActivo = true
            game.onTick(1000, "cicloDeOxigeno", {
                salvito.asimilarAmbiente()
            })
        }
    }

    method frenarCicloOxigeno() {
        if (cicloOxigenoActivo) {
            game.removeTickEvent("cicloDeOxigeno")
            cicloOxigenoActivo = false
        }
    }

    method recolectarPieza() {
        piezasRecolectadas += 1
        if (self.completoPiezasDelNivel()) {
            self.pasarASiguienteNivel()
        }
    }

    method completoPiezasDelNivel() = piezasRecolectadas == 2

    method pasarASiguienteNivel() {
        self.nivelActual().limpiarElementos()
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
        fondo.image("refugio.png")
        self.frenarCicloOxigeno()
        gestorClima.frenarNevada()
        salvito.detener()
        game.say(salvito, "¡Llegué al refugio! Creo que escucho humanos hablando...")
        game.schedule(4000, {
            if (!game.hasVisual(pantallaGanaste)) {
                game.addVisual(pantallaGanaste)
            }
            esperandoReinicio = true
        })
    }

    method perderJuego() {
        self.frenarCicloOxigeno()
        gestorClima.frenarNevada()
        self.nivelActual().limpiarElementos()
        salvito.detener()
        if (!game.hasVisual(pantallaGameOver)) {
            game.addVisual(pantallaGameOver)
        }
        esperandoReinicio = true
    }

    method intentarReiniciar() {
        if (esperandoReinicio) {
            if (game.hasVisual(pantallaGameOver)) {
                game.removeVisual(pantallaGameOver)
            }
            if (game.hasVisual(pantallaGanaste)) {
                game.removeVisual(pantallaGanaste)
            }
            indice = 0
            piezasRecolectadas = 0
            salvito.reiniciar()
            self.iniciarJuego()
        }
    }
}

// (El object gestorClima queda exactamente igual a como ya lo tenés)

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