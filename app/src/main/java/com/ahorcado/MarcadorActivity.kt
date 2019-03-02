package com.ahorcado

import android.content.Context
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_marcador.*

class MarcadorActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_marcador)
        supportActionBar?.hide()

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val victorias: Int = preferencias.getInt("victorias", 0)
        val derrotas: Int = preferencias.getInt("derrotas", 0)
        tvVictorias.text = victorias.toString()
        tvDerrotas.text = derrotas.toString()

        btnReset.setOnClickListener {
            val editor = preferencias.edit()
            editor.putInt("victorias", 0)
            editor.putInt("derrotas", 0)
            editor.apply()
            tvVictorias.text = "0"
            tvDerrotas.text = "0"
        }
        btnVolver.setOnClickListener {
            finish()
        }
    }
}
