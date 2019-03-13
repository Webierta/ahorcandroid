package com.ahorcado

import android.content.Context
import android.databinding.DataBindingUtil
import android.net.ConnectivityManager
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
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
        binding = DataBindingUtil.setContentView(this, R.layout.preferences)
        binding.miJuego = miJuego

        setSupportActionBar(binding.barAjustes)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        val actionBar = supportActionBar
        actionBar!!.title = "Ahorcado"
        actionBar.subtitle = "Ajustes"
        actionBar.setDisplayShowHomeEnabled(true)
        actionBar.setLogo(R.mipmap.ic_launcher)
        actionBar.setDisplayUseLogoEnabled(true)

        val niveles = arrayOf("Avanzado", "Júnior", "Temas")
        val adaptador = ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, niveles)
        binding.nivel.adapter = adaptador
        //binding.nivel.setSelection(1)

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val nivel = preferencias.getString("modo", "Avanzado")
        val sonido: Boolean = preferencias.getBoolean("sound", true)
        miJuego.modo = nivel?: "Avanzado"
        miJuego.sonido = sonido

        binding.sonido.isChecked = miJuego.sonido
        binding.textNivel.text = miJuego.modo

        binding.nivel.setSelection(0)
        binding.nivel.selectedItem
        //binding.nivel.defaultFocusHighlightEnabled = true
            //highlightCurrentRow(currentSelectedView);

        binding.nivel.onItemClickListener = AdapterView.OnItemClickListener { parent, _, position, _ ->
            val selectedItem = parent.getItemAtPosition(position) as String
            binding.textNivel.text = selectedItem
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu_ajustes, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem) = when (item.itemId) {
        R.id.action_guardar -> {
            miJuego.modo = (binding.textNivel.text).toString()
            miJuego.sonido = binding.sonido.isChecked

            val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val activeNetwork = cm.activeNetworkInfo
            val isConnected = activeNetwork != null && activeNetwork.isConnected

            val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
            val nivel = preferencias.getString("modo", "Avanzado")
            val editor = preferencias.edit()
            val nivelControl= if (!isConnected) "Temas" else miJuego.modo

            editor.putString("modo", nivelControl)
            editor.putBoolean("sound", miJuego.sonido)
            editor.apply()

            if (!isConnected && nivel!! != "Temas") {
                val toastInternet = Toast.makeText(this, "El nivel $nivel requiere conexión a internet.\nCambiando a Temas", Toast.LENGTH_LONG)
                toastInternet.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
                toastInternet.show()
                miJuego.modo = "Temas"
            } else {
                Toast.makeText(this, "Ajustes guardados", Toast.LENGTH_SHORT).show()
                finish()
            }
            true
        }
        else -> {
            super.onOptionsItemSelected(item)
        }
    }
}

