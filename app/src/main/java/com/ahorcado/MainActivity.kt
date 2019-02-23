package com.ahorcado

import android.content.Intent
import android.net.Uri
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        supportActionBar?.hide()

        val pinfo = this.packageManager.getPackageInfo(packageName, 0)
        val versionName = pinfo.versionName
        val textoVersion = "Versión: $versionName\nCopyleft 2019 Jesús Cuerda"
        editText.setText(textoVersion)

        btnJugar.setOnClickListener {
            startActivity(Intent(this, JuegoActivity::class.java))
        }
        btnMarcador.setOnClickListener {
            startActivity(Intent(this, MarcadorActivity::class.java))
        }
        btnOpciones.setOnClickListener {
            startActivity(Intent(this, SettingsActivity::class.java))
        }
        btnInfo.setOnClickListener {
            startActivity(Intent(this, InfoActivity::class.java))
        }
        btnSalir.setOnClickListener {
            finish()
        }
        btnPayPal.setOnClickListener {
            val urlPaypal = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=986PSAHLH6N4L"
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(urlPaypal)))
        }
    }
}
