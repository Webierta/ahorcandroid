import 'package:assets_audio_player/assets_audio_player.dart';

enum Archivo { acierto, error, derrota, victoria }

extension ArchivoExtension on Archivo {
  static const files = {
    Archivo.acierto: 'assets/audio/acierto.aac',
    Archivo.error: 'assets/audio/error.aac',
    Archivo.derrota: 'assets/audio/gameover.aac',
    Archivo.victoria: 'assets/audio/victoria.aac',
  };

  String get file => files[this];
}

class Sound {
  AssetsAudioPlayer assetsAudioPlayer;

  Sound() {
    assetsAudioPlayer = AssetsAudioPlayer();
  }

  Future<void> play(String archivo) async {
    try {
      await assetsAudioPlayer.open(Audio(archivo));
    } catch (e) {
      return null;
    }
  }

  Future<void> stop() async {
    try {
      await assetsAudioPlayer.stop();
    } catch (e) {
      return null;
    }
  }
}
