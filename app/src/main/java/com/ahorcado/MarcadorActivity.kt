package com.ahorcado

import android.content.Context
import android.databinding.DataBindingUtil
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import com.ahorcado.databinding.ActivityMarcadorBinding

class MarcadorActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMarcadorBinding
    private val miJuego = MiJuego()
    private val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_marcador)
        binding.miJuego = miJuego

        setSupportActionBar(binding.barMarcador)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        val actionBar = supportActionBar
        actionBar!!.title = "Ahorcado"
        actionBar.subtitle = "Marcador"
        actionBar.setDisplayShowHomeEnabled(true)
        actionBar.setLogo(R.mipmap.ic_launcher)
        actionBar.setDisplayUseLogoEnabled(true)

        val victorias: Int  = preferencias.getInt("victorias", 0)
        val derrotas: Int = preferencias.getInt("derrotas", 0)
        miJuego.victorias = victorias
        miJuego.derrotas = derrotas
        //binding.invalidateAll()
        binding.setVariable(BR.miJuego, miJuego)
        binding.executePendingBindings()
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu_marcador, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem) = when (item.itemId) {
        R.id.action_reset -> {
            val editor = preferencias.edit()
            editor.putInt("victorias", 0)
            editor.putInt("derrotas", 0)
            editor.apply()
            miJuego.victorias = 0
            miJuego.derrotas = 0
            binding.setVariable(BR.miJuego, miJuego)
            binding.executePendingBindings()
            true
        }
        else -> {
            super.onOptionsItemSelected(item)
        }
    }
}
