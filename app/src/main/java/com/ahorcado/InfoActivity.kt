package com.ahorcado

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_info.*

class InfoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_info)
        supportActionBar?.hide()

        val texto = try {
            application.assets.open("info.txt")
                .bufferedReader().use { it.readText() }
            } catch (e: Exception) {
                "Error: archivo info.txt no encontrado."
            }
        etInfo.setText(texto)

        btnVolver.setOnClickListener {
            finish()
        }
    }
}
