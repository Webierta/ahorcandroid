package com.ahorcado

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_info.*
import java.lang.Exception

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
