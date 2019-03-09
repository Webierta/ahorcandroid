package com.ahorcado

import android.content.Context
import android.databinding.DataBindingUtil
import android.net.ConnectivityManager
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Gravity
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import com.ahorcado.databinding.PreferencesBinding

class SettingsActivity : AppCompatActivity() {

    private lateinit var binding: PreferencesBinding
    private val miJuego = MiJuego()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.preferences)
        binding.miJuego = miJuego

        val niveles = arrayOf("Avanzado", "Júnior", "Temas")
        val adaptador = ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, niveles)
        binding.nivel.adapter = adaptador

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val nivel = preferencias.getString("modo", "Avanzado")
        val sonido: Boolean = preferencias.getBoolean("sound", true)
        miJuego.modo = nivel?: "Avanzado"
        miJuego.sonido = sonido

        binding.sonido.isChecked = miJuego.sonido
        binding.textNivel.text = miJuego.modo

        binding.nivel.onItemClickListener = AdapterView.OnItemClickListener { parent, _, position, _ ->
            val selectedItem = parent.getItemAtPosition(position) as String
            binding.textNivel.text = selectedItem
        }

        binding.btnGuardar.setOnClickListener {

            miJuego.modo = (binding.textNivel.text).toString()
            miJuego.sonido = binding.sonido.isChecked

            val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val activeNetwork = cm.activeNetworkInfo
            val isConnected = activeNetwork != null && activeNetwork.isConnected

            val editor = preferencias.edit()
            val nivelControl= if (!isConnected) "Temas" else miJuego.modo
            /*if (!isConnected) {
                editor.putString("modo", "Temas")
            } else {
                editor.putString("modo", miJuego.modo)
            }*/
            editor.putString("modo", nivelControl)
            editor.putBoolean("sound", miJuego.sonido)
            editor.apply()

            if (!isConnected && nivel != "Temas") {
                val toastInternet = Toast.makeText(this, "El nivel $nivel requiere conexión a internet.\nCambiando a Temas", Toast.LENGTH_LONG)
                toastInternet.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
                toastInternet.show()
                miJuego.modo = "Temas"
            } else {
                Toast.makeText(this, "Ajustes guardados", Toast.LENGTH_SHORT).show()
                finish()
            }
        }

        binding.btnVolver.setOnClickListener {
            finish()
        }
    }
}
/*

import android.content.Context
import android.databinding.DataBindingUtil
import android.net.ConnectivityManager
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Gravity
import android.widget.ArrayAdapter
import android.widget.Toast
import com.ahorcado.databinding.ActivitySettingsBinding

class SettingsActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySettingsBinding
    private val miJuego = MiJuego()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_settings)
        binding.miJuego = miJuego

        val niveles = arrayOf("Avanzado", "Júnior", "Temas")
        val adaptador = ArrayAdapter<String>(this, R.layout.spinner_item, niveles)
        adaptador.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinner.adapter = adaptador

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val nivel = preferencias.getString("modo", "Avanzado")
        val sonido: Boolean = preferencias.getBoolean("sound", true)
        miJuego.nivel = when (nivel) {
            "Avanzado" -> 0
            "Júnior" -> 1
            "Temas" -> 2
            else -> 2
        }
        miJuego.sonido = sonido
        //binding.setVariable(BR.miJuego, miJuego)
        //binding.executePendingBindings()

        binding.btnGuardar.setOnClickListener {
            miJuego.nivel = when (binding.spinner.selectedItem.toString()) {
                "Avanzado" -> 0
                "Júnior" -> 1
                "Temas" -> 2
                else -> 0
            }
            miJuego.sonido = binding.rbSonido.isChecked

            val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val activeNetwork = cm.activeNetworkInfo
            val isConnected = activeNetwork != null && activeNetwork.isConnected

            val editor = preferencias.edit()
            if (!isConnected) {
                editor.putString("modo", "Temas")
            } else {
                editor.putString("modo", binding.spinner.selectedItem.toString())
            }
            editor.putBoolean("sound", miJuego.sonido)
            editor.apply()
            if (!isConnected && nivel != "Temas") {
                val toastInternet = Toast.makeText(this, "El nivel $nivel requiere conexión a internet.\nCambiando a Temas", Toast.LENGTH_LONG)
                toastInternet.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
                toastInternet.show()
                miJuego.nivel = 2
            } else {
                Toast.makeText(this, "Ajustes guardados", Toast.LENGTH_SHORT).show()
                finish()
            }
            //binding.setVariable(BR.miJuego, miJuego)
            //binding.executePendingBindings()
        }
        binding.btnVolver.setOnClickListener {
            finish()
        }
    }
}
*/
