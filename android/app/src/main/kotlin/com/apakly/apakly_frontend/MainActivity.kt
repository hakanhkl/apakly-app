package com.apakly.apakly_frontend

import io.flutter.embedding.android.FlutterFragmentActivity
import com.ryanheise.audioservice.AudioServiceFragmentActivity
import android.os.Bundle
import android.media.AudioManager
import android.media.AudioAttributes
import android.os.Build

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


internal class MainActivity : AudioServiceFragmentActivity() {

    // val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
    // audioManager.setAllowedCapturePolicy(AudioAttributes.ALLOW_CAPTURE_BY_NONE)

    private val CHANNEL = "samples.flutter.dev/screenRecording"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "isScreenCaptured")   {
                // AudioAttributes.Builder().setAllowedCapturePolicy(AudioAttributesALLOW_CAPTURE_BY_NONE)
                val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
                audioManager.setAllowedCapturePolicy(AudioAttributes.ALLOW_CAPTURE_BY_NONE)
            } else {
                result.notImplemented()
            }
        }
    }

}
