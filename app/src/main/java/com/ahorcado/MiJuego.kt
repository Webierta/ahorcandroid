package com.ahorcado

data class MiJuego (
    var victorias: Int = 0,
    var derrotas: Int = 0,
    var modo: String = "",
    var sonido: Boolean = true,
    var texto: String = "",
    var version: String = ""
)