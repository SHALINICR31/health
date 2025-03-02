package com.example.health; // Change this based on your package name

import android.app.Application;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.FlutterInjector;

public class MainActivity extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        // Initialize FlutterEngine
        FlutterEngine flutterEngine = new FlutterEngine(this);
        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );

        // Optional: Pre-warm Flutter Engine for faster startup
        FlutterInjector.instance().flutterLoader().startInitialization(this);
    }
}
