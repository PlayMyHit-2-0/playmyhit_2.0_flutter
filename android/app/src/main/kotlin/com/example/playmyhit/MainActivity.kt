package com.example.playmyhit

import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import android.os.Bundle
import android.app.Application

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        AppCenter.start(application, "2955061c-9635-4356-a9c0-236d3506dc58", Analytics::class.java, Crashes::class.java)
        super.onCreate(savedInstanceState)
    }
}
