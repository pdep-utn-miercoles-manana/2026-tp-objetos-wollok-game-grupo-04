import wollok.game.*
import gatoSalvito.*
import gestores.*

class Nivel {
    const property imagenFondo 
    const property velGeneracion
    const property velCaida
    const property mensajeInicial

    method cargarNivel() {
        game.boardGround(imagenFondo) 
        game.say(salvito, mensajeInicial)
        gestorClima.cambiarDificultad(velGeneracion, velCaida)
    }
}

const nivelUno = new Nivel(
    imagenFondo = "nivel1.png", velGeneracion = 1500, velCaida = 300, mensajeInicial = "Debo armar una radio, ¡tengo que saber qué pasó!"
)
const nivelDos = new Nivel(
    imagenFondo = "nivel2.png", velGeneracion = 1200, velCaida = 200, mensajeInicial = "Está nevando con más fuerza... ¿eso que escuché fueron disparos?"
)
const nivelTres = new Nivel(
    imagenFondo = "nivel3.png", velGeneracion = 800, velCaida = 100, mensajeInicial = "La nieve es demasiada... no sé si logre salir de esta."
)