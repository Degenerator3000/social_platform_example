# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Аннотации
-keepattributes *Annotation*

# Native-методы (Platform Channels)
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----- Правила для Google Play Core (убирают ошибку R8) -----
# Эти классы используются только в App Bundle, для APK их нет
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }