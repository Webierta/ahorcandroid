package com.ahorcado

import android.content.Intent
import android.databinding.DataBindingUtil
import android.net.Uri
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.ahorcado.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val miJuego = MiJuego()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        binding.miJuego = miJuego

        val pinfo = this.packageManager.getPackageInfo(packageName, 0)
        val versionName = pinfo.versionName
        miJuego.version = "Versión: $versionName\nCopyleft 2019 Jesús Cuerda"
        binding.setVariable(BR.miJuego, miJuego)
        binding.executePendingBindings()

        binding.btnJugar.setOnClickListener {
            startActivity(Intent(this, JuegoActivity::class.java))
        }
        binding.btnMarcador.setOnClickListener {
            startActivity(Intent(this, MarcadorActivity::class.java))
        }
        binding.btnOpciones.setOnClickListener {
            startActivity(Intent(this, SettingsActivity::class.java))
        }
        binding.btnInfo.setOnClickListener {
            startActivity(Intent(this, InfoActivity::class.java))
        }
        binding.btnSalir.setOnClickListener {
            finish()
        }
        binding.btnPayPal.setOnClickListener {
            val urlPaypal = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=986PSAHLH6N4L"
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(urlPaypal)))
        }
    }
}
