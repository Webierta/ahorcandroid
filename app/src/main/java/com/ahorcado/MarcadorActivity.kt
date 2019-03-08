package com.ahorcado

import android.content.Context
import android.databinding.DataBindingUtil
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.ahorcado.databinding.ActivityMarcadorBinding

class MarcadorActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMarcadorBinding
    private val miJuego = MiJuego()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_marcador)
        binding.miJuego = miJuego

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val victorias: Int  = preferencias.getInt("victorias", 0)
        val derrotas: Int = preferencias.getInt("derrotas", 0)

        miJuego.victorias = victorias
        miJuego.derrotas = derrotas
        //binding.invalidateAll()
        binding.setVariable(BR.miJuego, miJuego)
        binding.executePendingBindings()

        binding.btnReset.setOnClickListener {
            val editor = preferencias.edit()
            editor.putInt("victorias", 0)
            editor.putInt("derrotas", 0)
            editor.apply()
            miJuego.victorias = 0
            miJuego.derrotas = 0
            binding.setVariable(BR.miJuego, miJuego)
            binding.executePendingBindings()
        }
        binding.btnVolver.setOnClickListener {
            finish()
        }
    }
}
