import wollok.game.*
import gatoSalvito.*
import gestores.*
import elementos.*

class Nivel {
    const imagenFondo 
    const velGeneracion
    const velCaida
    const mensajeInicial
    const elementosDelNivel = []

    method cargarNivel() {
        game.boardGround(imagenFondo) 
        game.say(salvito, mensajeInicial)
        gestorClima.cambiarDificultad(velGeneracion, velCaida)
        elementosDelNivel.forEach({ elemento => 
            if (!game.hasVisual(elemento)) {
                game.addVisual(elemento)
            }
        })
    }
}

const nivelUno = new Nivel(
    imagenFondo = "nivel1.png", velGeneracion = 1500, velCaida = 300, 
    mensajeInicial = "Debo armar una radio, ¡tengo que saber qué pasó!",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(2, 6), image = "cable.png", nombreDeLaPieza = "Cable"),
        new PiezaDeLore(position = game.at(7, 8), image = "radio.png", nombreDeLaPieza = "Radio"),
        new LataAtun(position = game.at(5, 7))
    ]
)

const nivelDos = new Nivel(
    imagenFondo = "nivel2.png", velGeneracion = 1200, velCaida = 200, 
    mensajeInicial = "Está nevando con más fuerza... ¿eso que escuché fueron disparos?",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(1, 8), image = "casco.png", nombreDeLaPieza = "Casco roto"),
        new PiezaDeLore(position = game.at(8, 5), image = "arma.png", nombreDeLaPieza = "Arma"),
        new LataAtun(position = game.at(4, 6))
    ]
)

const nivelTres = new Nivel(
    imagenFondo = "nivel3.png", velGeneracion = 800, velCaida = 100, 
    mensajeInicial = "La nieve es demasiada... no sé si logre salir de esta.",
    elementosDelNivel = [
        new PiezaDeLore(position = game.at(3, 9), image = "bateria.png", nombreDeLaPieza = "Batería militar"),
        new PiezaDeLore(position = game.at(8, 7), image = "antena.png", nombreDeLaPieza = "Antena"),
        new LataAtun(position = game.at(6, 5))
    ]
)