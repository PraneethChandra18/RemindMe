package com.example.scheduler
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin
import io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
    }

    override  fun registerWith(registry: PluginRegistry) {
        FlutterFirebaseAuthPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin"))
        FlutterFirebaseCorePlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin"))
        FlutterFirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
    }
}