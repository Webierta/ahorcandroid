package com.ahorcado

import android.content.Context
import android.content.Intent
import android.databinding.DataBindingUtil
import android.media.MediaPlayer
import android.os.Bundle
import android.os.StrictMode
import android.support.v7.app.AlertDialog
import android.support.v7.app.AppCompatActivity
import com.ahorcado.databinding.ActivityJuegoBinding
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.Toast
import org.json.JSONArray
import org.json.JSONObject
import org.jsoup.Jsoup
import java.text.Normalizer


class JuegoActivity : AppCompatActivity() {

    private lateinit var binding: ActivityJuegoBinding
    private val miJuego = MiJuego()
    private lateinit var horcaImage: ImageView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()
        binding = DataBindingUtil.setContentView(this, R.layout.activity_juego)
        binding.miJuego = miJuego

        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
        StrictMode.setThreadPolicy(policy)

        val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
        val editor = preferencias.edit()
        val nivel = preferencias.getString("modo", "Avanzado")
        val sonido: Boolean = preferencias.getBoolean("sound", true)

        val palabraAleatoria = when(nivel){
            "Avanzado" -> {
                binding.btnPista.visibility = View.INVISIBLE
                buscarPalabra("https://www.palabrasaleatorias.com/?fs=1&fs2=0&Submit=Nueva+palabra")
            }
            "Júnior" -> {
                binding.btnPista.visibility = View.INVISIBLE
                buscarPalabra("https://www.palabrasaleatorias.com/?fs=1&fs2=1&Submit=Nueva+palabra")
            }
            "Temas" -> {
                binding.btnPista.visibility = View.VISIBLE
                vocabulario()
            }
            else -> {
                binding.btnPista.visibility = View.VISIBLE
                vocabulario()
            }
        }
        //val palabraAleatoria = "DESMARMCANDOSE" // 14
        //val palabraAleatoria = "DESMARCANDOS"  // 12
        //val palabraAleatoria = "SEPARANDOS" // 10
        //val palabraAleatoria = "DESMARCA"  // 8
        //val palabraAleatoria = "MAPA"  // 4
        /*val sizeRes = when (palabraAleatoria.length){
            3, 4 -> R.dimen.text_macro
            5, 6 -> R.dimen.text_grande
            7, 8 -> R.dimen.text_normal
            9, 10 -> R.dimen.text_mini
            11, 12 -> R.dimen.text_micro
            else -> R.dimen.text_normal
        }
        binding.tvSecreta.textSize = resources.getDimension(sizeRes)*/
        //binding.tvSecreta.letterSpacing = -0.4f
        //if (palabraAleatoria.length > 9) {
        //    binding.tvSecreta.setAutoSizeTextTypeUniformWithPresetSizes(14)
        //}

        val secreta = palabraAleatoria.toUpperCase()
        val oculta = Array(secreta.length) { "_" }
        binding.tvSecreta.text = oculta.joinToString(separator=" ")
        /*val sizeRes = when (palabraAleatoria.length){
            10, 11, 12 -> binding.tvSecreta.letterSpacing = -0.2f
            else -> binding.tvSecreta.letterSpacing = 0f
        }*/

        var error = 0
        var acierto = 0
        val teclado = listaBotones(binding.fila1)
        teclado.addAll(listaBotones(binding.fila2))
        teclado.addAll(listaBotones(binding.fila3))
        var letra: String
        horcaImage = binding.imgAhorcado
        var sonidoRes: Int
        teclado.forEach { button ->
            button.setOnClickListener{
                letra = this.capturaLetra(it)
                if (letra in secreta){
                    acierto++
                    sonidoRes = R.raw.acierto
                    for (index in secreta.indices) {
                        if (letra == secreta[index].toString()) oculta[index] = letra
                    }
                    binding.tvSecreta.text = oculta.joinToString(separator=" ")
                    if (secreta == oculta.joinToString(separator="")) {
                        sonidoRes = R.raw.victoria
                        var victorias: Int = preferencias.getInt("victorias", 0)
                        victorias++
                        editor.putInt("victorias", victorias)
                        editor.apply()
                        alertaOtra("VICTORIA", "¿Otra partida?")
                    }
                } else {
                    error++
                    sonidoRes = R.raw.error
                    when(error){
                        1 -> horcaImage.setImageResource(R.drawable.img2)
                        2 -> horcaImage.setImageResource(R.drawable.img3)
                        3 -> horcaImage.setImageResource(R.drawable.img4)
                        4 -> horcaImage.setImageResource(R.drawable.img5)
                        5 -> horcaImage.setImageResource(R.drawable.img6)
                        6 -> {
                            sonidoRes = R.raw.gameover
                            horcaImage.setImageResource(R.drawable.img7)
                            var derrotas: Int = preferencias.getInt("derrotas", 0)
                            derrotas++
                            editor.putInt("derrotas", derrotas)
                            editor.commit()
                            alertaOtra("Has muerto en la horca", "La palabra era $secreta\n\n¿Otra partida?")
                        }
                    }
                }
                if (sonido) {
                    val mediaPlayer = MediaPlayer.create(this, sonidoRes)
                    mediaPlayer.start()
                }
            }
        }
    }

    private fun listaBotones(fila: LinearLayout): MutableList<Button> {
        val botonesList = mutableListOf<Button>()
        val filaKeys: Int = fila.childCount
        for (i in 0 until filaKeys) {
            val v = fila.getChildAt(i)
            botonesList += findViewById<Button>(v.id)
        }
        return botonesList
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

            var controlPalabra = true
            for (let in palabra) {
                if (let !in letras) controlPalabra = false
            }
            if (palabra.length < 3 || palabra.length > 12) controlPalabra = false //buscarPalabra(source)
            return if (controlPalabra) palabra else buscarPalabra(source)
        } catch (e: Exception) {
            val toastFallo = Toast.makeText(this, "Fallo de conexión: cambiando al modo Temas", Toast.LENGTH_LONG)
            toastFallo.setGravity(Gravity.TOP or Gravity.CENTER, 0, 550)
            toastFallo.show()
            val preferencias = getSharedPreferences("datos", Context.MODE_PRIVATE)
            val editor = preferencias.edit()
            editor.putString("modo", "Temas")
            editor.apply()
            binding.btnPista.visibility = View.VISIBLE
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
            for (index in 0 until jsonPalabras.length()){
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
        binding.btnPista.setOnClickListener {
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
