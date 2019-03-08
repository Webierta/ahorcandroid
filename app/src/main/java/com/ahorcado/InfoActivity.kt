package com.ahorcado

import android.databinding.DataBindingUtil
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.ahorcado.databinding.ActivityInfoBinding

class InfoActivity : AppCompatActivity() {

    private lateinit var binding: ActivityInfoBinding
    private val miJuego = MiJuego()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_info)
        binding.miJuego = miJuego

        miJuego.texto = try {
            application.assets.open("info.txt")
                .bufferedReader().use { it.readText() }
            } catch (e: Exception) {
                "Error: archivo info.txt no encontrado."
            }
        binding.setVariable(BR.miJuego, miJuego)
        binding.executePendingBindings()

        binding.btnVolver.setOnClickListener {
            finish()
        }
    }
}
