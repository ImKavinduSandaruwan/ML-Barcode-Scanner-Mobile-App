package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.camera.CameraPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin camera_android, io.flutter.plugins.camera.CameraPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_plugin_android_lifecycle, io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.google_mlkit_barcode_scanning.GoogleMlKitBarcodeScanningPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin google_mlkit_barcode_scanning, com.google_mlkit_barcode_scanning.GoogleMlKitBarcodeScanningPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.google_mlkit_commons.GoogleMlKitCommonsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin google_mlkit_commons, com.google_mlkit_commons.GoogleMlKitCommonsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.google_mlkit_image_labeling.GoogleMlKitImageLabelingPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin google_mlkit_image_labeling, com.google_mlkit_image_labeling.GoogleMlKitImageLabelingPlugin", e);
    }
  }
}
