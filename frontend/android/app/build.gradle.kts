plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tatar_shower"
    compileSdk = 35  // или ваша актуальная версия SDK
    defaultConfig {
        applicationId = "com.example.tatar_shower"
        minSdk = 21       // минимум 21 для поддержки desugaring+multidex
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        multiDexEnabled = true   // <— вот это
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    ndkVersion = "27.0.12077973"
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
