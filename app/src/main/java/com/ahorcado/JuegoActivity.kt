package com.ahorcado

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import android.support.v7.app.AlertDialog
import android.view.View
import android.widget.Button
import kotlinx.android.synthetic.main.activity_juego.*

import org.jsoup.Jsoup
import android.os.StrictMode
import org.json.JSONArray
import java.lang.Exception
import java.text.Normalizer
import org.json.JSONObject
import android.media.MediaPlayer
import android.view.Gravity

class JuegoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_juego)
        supportActionBar?.hide()

        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
        StrictMode.setThreadPolicy(policy)

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val editor = preferencias.edit()
        val nivel = preferencias.getString("modo", "Avanzado")
        val sonido: Boolean = preferencias.getBoolean("sound", true)
        println(nivel)
        println(sonido)

        val palabraAleatoria: String = when(nivel){
            "Avanzado" -> {
                btnPista.visibility = View.INVISIBLE
                buscarPalabra("https://www.palabrasaleatorias.com/?fs=1&fs2=0&Submit=Nueva+palabra")
            }
            "Júnior" -> {
                btnPista.visibility = View.INVISIBLE
                buscarPalabra("https://www.palabrasaleatorias.com/?fs=1&fs2=1&Submit=Nueva+palabra")
            }
            "Temas" -> {
                btnPista.visibility = View.VISIBLE
                vocabulario()
            }
            else -> {
                btnPista.visibility = View.VISIBLE
                vocabulario()
            }
        }
        if (palabraAleatoria.length > 10) tvSecreta.textSize = 18f
        val secreta = palabraAleatoria.toUpperCase()
        val oculta = Array(secreta.length) { "_" }
        tvSecreta.text = oculta.joinToString(separator=" ")

        var error = 0
        var acierto = 0
        val botones = listOf<Button>(
            btnA, btnB, btnC, btnD, btnE, btnF, btnG, btnH, btnI,
            btnJ, btnK, btnL, btnM, btnN, btnÑ, btnO, btnP, btnQ,
            btnR, btnS, btnT, btnU, btnV, btnW, btnX, btnY, btnZ)

        var letra: String
        botones.forEach { button ->
            button.setOnClickListener{
                letra = this.capturaLetra(it)
                println(letra)
                if (letra in secreta){
                    acierto++
                    if (sonido && acierto < secreta.length) MediaPlayer.create(this, R.raw.acierto).start()
                    for (index in secreta.indices) {
                        if (letra == secreta[index].toString()) oculta[index] = letra
                    }
                    tvSecreta.text = oculta.joinToString(separator=" ")
                    if (secreta == oculta.joinToString(separator="")) {
                        if(sonido) MediaPlayer.create(this, R.raw.victoria).start()
                        var victorias: Int = preferencias.getInt("victorias", 0)
                        victorias++
                        editor.putInt("victorias", victorias)
                        editor.apply()
                        alertaOtra("VICTORIA", "¿Otra partida?")
                    }
                } else {
                    error++
                    if (sonido && error < 6) MediaPlayer.create(this, R.raw.error).start()
                    println("ERROR $error")
                    if (error == 3) println("Has muerto en la horca.")
                    when(error){
                        1 -> imgAhorcado.setImageResource(R.drawable.img2)
                        2 -> imgAhorcado.setImageResource(R.drawable.img3)
                        3 -> imgAhorcado.setImageResource(R.drawable.img4)
                        4 -> imgAhorcado.setImageResource(R.drawable.img5)
                        5 -> imgAhorcado.setImageResource(R.drawable.img6)
                        6 -> {
                            if(sonido) MediaPlayer.create(this, R.raw.gameover).start()
                            imgAhorcado.setImageResource(R.drawable.img7)
                            var derrotas: Int = preferencias.getInt("derrotas", 0)
                            derrotas++
                            editor.putInt("derrotas", derrotas)
                            editor.commit()
                            alertaOtra("Has muerto en la horca", "La palabra era $secreta\n\n¿Otra partida?")
                        }
                    }
                }
            }
        }
    }

    private fun buscarPalabra(source: String): String {
        try {
            val doc = Jsoup.connect(source).get()
            val elementos = doc.select("div[style=font-size:3em; color:#6200C5;]")
            val palabraAleatoria = elementos.text()

            val letras = "ABCDEFGHIJKLMNÑOPQRSTUVWYZ"
            val palabraOnline: String = palabraAleatoria.toUpperCase()

            val reNumber = Regex("[0-9]")
            val tempSinNumber = reNumber.replace(palabraOnline, "")
            val tempSinN: String = tempSinNumber.replace("Ñ", "/001")
            val tempNorm = Normalizer.normalize(tempSinN, Normalizer.Form.NFD)
            val regexSinAcentos = "\\p{InCombiningDiacriticalMarks}+".toRegex()
            val tempSinAc = regexSinAcentos.replace(tempNorm, "")
            val tempConN: String = tempSinAc.replace("/001", "Ñ")
            val re = Regex("[^A-ZÑ]")
            val palabra = re.replace(tempConN, "")
            palabra.forEach { let ->
                if (let !in letras) buscarPalabra(source)
            }
            if(palabra.length < 3 || palabra.length > 12) buscarPalabra(source)
            return palabra
        } catch (e: Exception) {
            val toastFallo = Toast.makeText(this, "Fallo de conexión: cambiando al modo Temas", Toast.LENGTH_LONG)
            toastFallo.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
            toastFallo.show()
            val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
            val editor = preferencias.edit()
            editor.putString("modo", "Temas")
            editor.apply()
            btnPista.visibility = View.VISIBLE
            return vocabulario()
        }
    }

    private fun vocabulario(): String{
        val dataPalabras = try {
            application.assets.open("vocabulario.json")
                .bufferedReader().use { it.readText() }
        } catch (e: Exception) {
            val toastError = Toast.makeText(this, "Error: almacén de palabras no encontrado", Toast.LENGTH_LONG)
            toastError.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
            toastError.show()
            return "AHORCADO"
        }
        val jsonObj = JSONObject(dataPalabras)
        val todosTemas = jsonObj.getString("VOCABULARIO")
        val mJsonArray = JSONArray(todosTemas)

        val categoriaPista = ArrayList<HashMap<String, String>>()
        val categoriaPalabras = ArrayList<HashMap<String, ArrayList<String>>>()

        for (i in 0 until mJsonArray.length()) {
            val dicCatPista = HashMap<String, String>()
            val dicCatPalabras = HashMap<String, ArrayList<String>>()
            val palabras = ArrayList<String>()
            val sObject = mJsonArray.get(i).toString()
            val mItemObject = JSONObject(sObject)
            val categoria = mItemObject.getString("CATEGORIA")
            val pista = mItemObject.getString("PISTA")
            val jsonPalabras = mItemObject.getJSONArray("PALABRAS")
            for(index in 0 until jsonPalabras.length()){
                val palObject = jsonPalabras.get(index).toString()
                palabras.add(palObject)
            }
            dicCatPista[categoria] = pista
            categoriaPista.add(dicCatPista)
            dicCatPalabras[categoria] = palabras
            categoriaPalabras.add(dicCatPalabras)
        }

        val numberCategoria = (0 until categoriaPalabras.size).random()
        val randomCategoria= categoriaPalabras[numberCategoria]
        var categoriaPalabra = ""
        var randomPalabra = ""
        for ((key, value) in randomCategoria) {
            categoriaPalabra = key
            randomPalabra = value.random()
        }
        var pistaPalabra = ""
        for (tema in categoriaPista) {
            for ((key, value) in tema) {
                if (key == categoriaPalabra) {
                    pistaPalabra = value
                }
            }
        }
        btnPista.setOnClickListener {
            val toastPista = Toast.makeText(this, "Pista: $pistaPalabra", Toast.LENGTH_LONG)
            toastPista.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
            toastPista.show()
        }
        return randomPalabra
    }

    private fun capturaLetra(v: View): String {
        val boton = findViewById<Button>(v.id)
        boton.isEnabled = false
        return boton.text.toString()
    }

    private fun alertaOtra (titulo: String, mensaje: String) {
        val icono: Int = if(titulo == "VICTORIA") R.mipmap.triunfosblack else R.mipmap.derrotasblack
        AlertDialog.Builder(this@JuegoActivity)
            .setIcon(icono)
            .setTitle(titulo)
            .setMessage(mensaje)
            .setPositiveButton("Sí"){ _, _ ->
                finish()
                startActivity(Intent(this, JuegoActivity::class.java))
            }
            .setNegativeButton("No") { _, _ ->
                finish()
            }
            .setCancelable(false)
            .create().show()
    }
}
