import wollok.game.*
import elementos.*
import gatoSalvito.*
import niveles.*
import visualesPantalla.*

object gestorMusica {
    var sonidoActual = null
    var sonando = false

    method iniciarMusicaIntro() {
        self.reproducirEnLoop("musica_intro.mp3")
    }

    method iniciarMusicaNevada() {
        self.reproducirEnLoop("musica_nevada.mp3")
    }

    method reproducirEnLoop(nombreArchivo) {
        self.frenarMusica()
        sonidoActual = game.sound(nombreArchivo)
        sonidoActual.shouldLoop(true)
        sonidoActual.volume(0.25)
        sonidoActual.play()
        sonando = true
    }

    method frenarMusica() {
        if (sonando and sonidoActual != null) {
            sonidoActual.stop()
            sonando = false
            sonidoActual = null
        }
    }
}

object gestorDeNivel {
    const nivelesDeJuego = [nivelUno, nivelDos, nivelTres]
    const imagenesSecuenciaFinal = [
        "final_0_radio.png",
        "final_1_salvito.png",
        "final_2_darin.png"
    ]
    var indice = 0 
    var piezasRecolectadas = 0
    var cicloOxigenoActivo = false
    var property partidaEnCurso = false
    var esperandoReinicioNivel = false
    var esperandoReinicioJuego = false
    var enDialogo = false
    var enTransicion = false
    var enSecuenciaFinal = false
    var etapaFinal = 0

    method nivelActual() = nivelesDeJuego.get(indice) 

    method iniciarJuego() {
        partidaEnCurso = true
        esperandoReinicioNivel = false
        esperandoReinicioJuego = false
        enDialogo = false
        enTransicion = false
        enSecuenciaFinal = false
        etapaFinal = 0
        self.mostrarElementosDePartida()
        self.iniciarCicloOxigeno()
        self.nivelActual().cargarNivel()
        gestorMusica.iniciarMusicaNevada()
    }

    method mostrarElementosDePartida() {
        if (!game.hasVisual(salvito)) {
            game.addVisual(salvito)
        }
        if (!game.hasVisual(barraOxigeno)) {
            game.addVisual(barraOxigeno)
        }
        if (!game.hasVisual(barraVelocidad)) {
            game.addVisual(barraVelocidad)
        }
    }

    method ocultarElementosDePartida() {
        if (game.hasVisual(salvito)) {
            game.removeVisual(salvito)
        }
        if (game.hasVisual(barraOxigeno)) {
            game.removeVisual(barraOxigeno)
        }
        if (game.hasVisual(barraVelocidad)) {
            game.removeVisual(barraVelocidad)
        }
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

    // Pausa todos los relojes y el movimiento mientras se lee una pantalla
    method pausarPartida() {
        salvito.detener()
        self.frenarCicloOxigeno()
        gestorClima.pausarNevada()
        self.nivelActual().frenarReubicacionElementos()
    }

    // Reanuda todos los relojes cuando se cierra un diálogo en medio del nivel
    method reanudarPartida() {
        salvito.habilitarMovimiento()
        self.iniciarCicloOxigeno()
        gestorClima.reanudarNevada()
        self.nivelActual().iniciarReubicacionElementos()
    }

    method mostrarDialogo(nombreImagen) {
        if (partidaEnCurso) {
            self.pausarPartida()
            pantallaDialogo.image(nombreImagen)
            if (!game.hasVisual(pantallaDialogo)) {
                game.addVisual(pantallaDialogo)
            }
            enDialogo = true
        }
    }

    method recolectarPiezaConDialogo(nombreImagen) {
        if (partidaEnCurso) {
            piezasRecolectadas += 1
            self.mostrarDialogo(nombreImagen)
        } else {
            // Modo test unitario (sin bloqueo de teclado ni audio)
            self.recolectarPieza()
        }
    }

    method recolectarPieza() {
        piezasRecolectadas += 1
        if (self.completoPiezasDelNivel()) {
            self.pasarASiguienteNivel()
        }
    }

    // Acción de la tecla X (o ENTER) para cerrar diálogos y avanzar transiciones
    method continuarConX() {
        if (enDialogo) {
            if (game.hasVisual(pantallaDialogo)) {
                game.removeVisual(pantallaDialogo)
            }
            enDialogo = false
            if (self.completoPiezasDelNivel()) {
                self.iniciarTransicionNivel()
            } else {
                self.reanudarPartida()
            }
        } else if (enTransicion) {
            if (game.hasVisual(pantallaTransicion)) {
                game.removeVisual(pantallaTransicion)
            }
            enTransicion = false
            self.nivelActual().cargarNivel()
            self.iniciarCicloOxigeno()
            gestorMusica.iniciarMusicaNevada()
        } else if (enSecuenciaFinal) {
            self.avanzarSecuenciaFinal()
        }
    }

    method iniciarTransicionNivel() {
        self.nivelActual().limpiarElementos()
        gestorClima.frenarNevada()
        if (partidaEnCurso) {
            gestorMusica.frenarMusica()
        }
        piezasRecolectadas = 0
        indice += 1
        if (self.hayMasNiveles()) {
            pantallaTransicion.image(self.nivelActual().imagenTransicionEntrada())
            if (!game.hasVisual(pantallaTransicion)) {
                game.addVisual(pantallaTransicion)
            }
            enTransicion = true
        } else {
            self.iniciarSecuenciaFinal()
        }
    }

    method iniciarSecuenciaFinal() {
        self.frenarCicloOxigeno()
        gestorClima.frenarNevada()
        salvito.detener()
        self.ocultarElementosDePartida()
        fondo.image("refugio.png")
        enSecuenciaFinal = true
        etapaFinal = 0
        pantallaTransicion.image(imagenesSecuenciaFinal.get(etapaFinal))
        if (!game.hasVisual(pantallaTransicion)) {
            game.addVisual(pantallaTransicion)
        }
    }

    method avanzarSecuenciaFinal() {
        etapaFinal += 1
        if (etapaFinal < imagenesSecuenciaFinal.size()) {
            pantallaTransicion.image(imagenesSecuenciaFinal.get(etapaFinal))
        } else {
            if (game.hasVisual(pantallaTransicion)) {
                game.removeVisual(pantallaTransicion)
            }
            enSecuenciaFinal = false
            self.ganarJuego()
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
        if (partidaEnCurso) {
            gestorMusica.frenarMusica()
        }
        salvito.detener()
        if (!game.hasVisual(pantallaGanaste)) {
            game.addVisual(pantallaGanaste)
        }
        esperandoReinicioJuego = true
    }

    method perderJuego() {
        self.frenarCicloOxigeno()
        gestorClima.frenarNevada()
        if (partidaEnCurso) {
            gestorMusica.frenarMusica()
        }
        self.nivelActual().limpiarElementos()
        salvito.detener()
        if (!game.hasVisual(pantallaGameOver)) {
            game.addVisual(pantallaGameOver)
        }
        esperandoReinicioNivel = true
    }

    method intentarReiniciarNivel() {
        if (esperandoReinicioNivel) {
            if (game.hasVisual(pantallaGameOver)) {
                game.removeVisual(pantallaGameOver)
            }
            piezasRecolectadas = 0
            self.iniciarJuego()
        }
    }

    method intentarVolverAEmpezar() {
        if (esperandoReinicioJuego) {
            if (game.hasVisual(pantallaGanaste)) {
                game.removeVisual(pantallaGanaste)
            }
            indice = 0
            piezasRecolectadas = 0
            self.iniciarJuego()
        }
    }
}

object gestorClima {
    const coposEnPantalla = []
    const copitosDecorativos = [
        new CopoMiniatura(position = game.at(1, 9)),
        new CopoMiniatura(position = game.at(3, 7)),
        new CopoMiniatura(position = game.at(5, 5)),
        new CopoMiniatura(position = game.at(7, 8)),
        new CopoMiniatura(position = game.at(9, 6)),
        new CopoMiniatura(position = game.at(11, 9)),
        new CopoMiniatura(position = game.at(13, 7)),
        new CopoMiniatura(position = game.at(15, 5))
    ]
    var tiempoGeneracion = 1500
    var tiempoCaida = 300
    // Velocidad SIEMPRE constante para copito.png en todos los niveles
    const tiempoCaidaCopito = 300
    var nevando = false
    var property movimientoHorizontalActivo = false

    method iniciarNevada() {
        movimientoHorizontalActivo = false
        self.arrancarTicks()
    }

    method mostrarCopitosDecorativos() {
        copitosDecorativos.forEach({ copito =>
            if (!game.hasVisual(copito)) {
                game.addVisual(copito)
            }
        })
        self.mantenerBarrasAdelante()
    }

    method ocultarCopitosDecorativos() {
        copitosDecorativos.forEach({ copito =>
            if (game.hasVisual(copito)) {
                game.removeVisual(copito)
            }
        })
    }

    method arrancarTicks() {
        nevando = true
        self.mostrarCopitosDecorativos()
        game.onTick(tiempoGeneracion, "generarNieve", {
            self.generarCopo()
        })
        game.onTick(tiempoCaida, "caidaDeNieve", {
            self.actualizarCaidaDeCopos()
        })
        game.onTick(tiempoCaidaCopito, "caidaDeCopitos", {
            self.actualizarCaidaDeCopitos()
        })
    }

    method pausarNevada() {
        if (nevando) {
            game.removeTickEvent("generarNieve")
            game.removeTickEvent("caidaDeNieve")
            game.removeTickEvent("caidaDeCopitos")
            nevando = false
        }
    }

    method reanudarNevada() {
        if (!nevando) {
            self.arrancarTicks()
        }
    }

    method generarCopo() {
        const xAleatorio = 0.randomUpTo(game.width()).truncate(0)
        const yTecho = game.height() - 1
        const nuevoCopo = new NieveToxica(position = game.at(xAleatorio, yTecho)) 
        game.addVisual(nuevoCopo)
        coposEnPantalla.add(nuevoCopo)
        if (xAleatorio >= 10) {
            self.mantenerBarrasAdelante()
        }
    }

    method mantenerBarrasAdelante() {
        if (game.hasVisual(barraOxigeno)) {
            game.removeVisual(barraOxigeno)
            game.addVisual(barraOxigeno)
        }
        if (game.hasVisual(barraVelocidad)) {
            game.removeVisual(barraVelocidad)
            game.addVisual(barraVelocidad)
        }
    }

    method actualizarCaidaDeCopos() {
        const coposAEliminar = coposEnPantalla.filter({ copo => copo.llegoAlSubte() })
        coposAEliminar.forEach({ copo => self.eliminarCopo(copo) })
        coposEnPantalla.forEach({ copo => copo.caer() })
    }

    method actualizarCaidaDeCopitos() {
        copitosDecorativos.forEach({ copito => copito.caer() })
    }

    method eliminarCopo(unCopo) {
        if (game.hasVisual(unCopo)) {
            game.removeVisual(unCopo)
        }
        coposEnPantalla.remove(unCopo)
    }

    method cambiarDificultad(nuevoTiempoGen, nuevoTiempoCaida, conMovimientoHorizontal) {
        self.frenarNevada()
        tiempoGeneracion = nuevoTiempoGen
        tiempoCaida = nuevoTiempoCaida
        movimientoHorizontalActivo = conMovimientoHorizontal
        self.arrancarTicks()
    }
    
    // Limpia SIEMPRE los copos y copitos en pantalla, incluso si ya estaba pausada por un diálogo
    method frenarNevada() {
        self.pausarNevada()
        coposEnPantalla.copy().forEach({ copo => self.eliminarCopo(copo) })
        self.ocultarCopitosDecorativos()
    }
}