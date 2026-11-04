import wollok.game.*
import gatoSalvito.*
import gestores.*
import elementos.*
import visualesPantalla.*

class Nivel {
    const imagenFondo 
    const velGeneracion
    const velCaida
    const conMovimientoHorizontal = false
    const mensajeInicial
    const property imagenTransicionEntrada = ""
    const elementosDelNivel = []
    var reubicacionActiva = false

    method cargarNivel() {
        salvito.reiniciar()
        fondo.image(imagenFondo) 
        game.say(salvito, mensajeInicial)
        gestorClima.cambiarDificultad(velGeneracion, velCaida, conMovimientoHorizontal)
        elementosDelNivel.forEach({ elemento => 
            if (!game.hasVisual(elemento)) {
                game.addVisual(elemento)
            }
        })
        self.iniciarReubicacionElementos()
    }

    method iniciarReubicacionElementos() {
        self.frenarReubicacionElementos()
        reubicacionActiva = true
        game.onTick(5000, "reubicarElementos", {
            self.reubicarElementosActivos()
        })
    }

    method reubicarElementosActivos() {
        elementosDelNivel.forEach({ elemento =>
            if (game.hasVisual(elemento)) {
                elemento.cambiarPosicionAleatoria()
            }
        })
    }

    method frenarReubicacionElementos() {
        if (reubicacionActiva) {
            game.removeTickEvent("reubicarElementos")
            reubicacionActiva = false
        }
    }

    method limpiarElementos() {
        self.frenarReubicacionElementos()
        elementosDelNivel.forEach({ elemento =>
            if (game.hasVisual(elemento)) {
                game.removeVisual(elemento)
            }
        })
    }
}

const nivelUno = new Nivel(
    imagenFondo = "nivel1.png", velGeneracion = 1500, velCaida = 300,
    conMovimientoHorizontal = false,
    mensajeInicial = "Debo armar una radio, ¡tengo que saber qué pasó!",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(2, 6), image = "cable.png", nombreDeLaPieza = "Cable", imagenDialogo = "dialogo_cable.png"),
        new PiezaDeLore(position = game.at(7, 8), image = "radio.png", nombreDeLaPieza = "Radio", imagenDialogo = "dialogo_radio.png"),
        new LataAtun(position = game.at(5, 7))
    ]
)

const nivelDos = new Nivel(
    imagenFondo = "nivel2.png", velGeneracion = 1200, velCaida = 200,
    conMovimientoHorizontal = true,
    mensajeInicial = "Está nevando con más fuerza... ¿eso que escuché fueron disparos?",
    imagenTransicionEntrada = "transicion_nivel2.png",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(1, 8), image = "gorra.png", nombreDeLaPieza = "Gorra militar", imagenDialogo = "dialogo_gorra.png"),
        new PiezaDeLore(position = game.at(8, 5), image = "arma.png", nombreDeLaPieza = "Arma", imagenDialogo = "dialogo_arma.png"),
        new LataAtun(position = game.at(4, 6))
    ]
)

const nivelTres = new Nivel(
    imagenFondo = "nivel3.png", velGeneracion = 800, velCaida = 100,
    conMovimientoHorizontal = true,
    mensajeInicial = "La nieve es demasiada... no sé si logre salir de esta.",
    imagenTransicionEntrada = "transicion_nivel3.png",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(3, 8), image = "bateria.png", nombreDeLaPieza = "Batería militar", imagenDialogo = "dialogo_bateria.png"),
        new PiezaDeLore(position = game.at(8, 7), image = "antena.png", nombreDeLaPieza = "Antena", imagenDialogo = "dialogo_antena.png"),
        new LataAtun(position = game.at(6, 5))
    ]
)