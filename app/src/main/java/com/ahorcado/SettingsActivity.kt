package com.ahorcado

import android.content.Context
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import android.widget.ArrayAdapter
import kotlinx.android.synthetic.main.activity_settings.*
import android.net.ConnectivityManager
import android.view.Gravity

class SettingsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_settings)
        supportActionBar?.hide()

        val niveles = arrayOf("Avanzado", "Júnior", "Temas")
        //val adaptador = ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, niveles)
        val adaptador = ArrayAdapter<String>(this, R.layout.spinner_item, niveles)
        adaptador.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = adaptador

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        var nivel = preferencias.getString("modo", "Avanzado")
        var sonido: Boolean = preferencias.getBoolean("sound", true)
        when (nivel) {
            "Avanzado" -> spinner.setSelection(0)
            "Júnior" -> spinner.setSelection(1)
            "Temas" -> spinner.setSelection(2)
        }
        rbSonido.isChecked = sonido
        rbMute.isChecked = !sonido

        btnGuardar.setOnClickListener {
            nivel = when (spinner.selectedItem.toString()) {
                "Avanzado" -> "Avanzado"
                "Júnior" -> "Júnior"
                "Temas" -> "Temas"
                else -> "Avanzado"
            }
            val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val activeNetwork = cm.activeNetworkInfo
            val isConnected = activeNetwork != null && activeNetwork.isConnected

            sonido = rbSonido.isChecked

            val editor = preferencias.edit()
            if (!isConnected) {
                editor.putString("modo", "Temas")
            } else {
                editor.putString("modo", nivel)
            }
            editor.putBoolean("sound", sonido)
            editor.apply()
            if (!isConnected && nivel != "Temas") {
                val toastInternet = Toast.makeText(this, "El nivel $nivel requiere conexión a internet.\nCambiando a Temas", Toast.LENGTH_LONG)
                toastInternet.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
                toastInternet.show()
                spinner.setSelection(2)
            } else {
                Toast.makeText(this, "Ajustes guardados", Toast.LENGTH_SHORT).show()
                finish()
            }
        }

        btnVolver.setOnClickListener {
            finish()
        }
    }
}
