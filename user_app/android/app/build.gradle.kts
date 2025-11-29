plugins {
    id("com.android.application")
<<<<<<< HEAD
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
=======
    id("com.google.gms.google-services")
    id("kotlin-android")
>>>>>>> temp-fix
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
    namespace = "com.example.admin_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
=======
    namespace = "com.example.depi_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
>>>>>>> temp-fix

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

<<<<<<< HEAD
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.admin_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
=======
    signingConfigs {
        // التعديل هنا: غيرنا الاسم من "debug" لـ "loginConfig" عشان ميتعارضش مع الافتراضي
        create("loginConfig") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    defaultConfig {
        applicationId = "com.example.depi_app"
>>>>>>> temp-fix
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
<<<<<<< HEAD
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
=======
            // هنا بنقوله استخدم الكونفيج اللي سميناه loginConfig
            signingConfig = signingConfigs.getByName("loginConfig")
        }
        debug {
            // وهنا برضو بنقوله استخدم نفس الكونفيج
            signingConfig = signingConfigs.getByName("loginConfig")
>>>>>>> temp-fix
        }
    }
}

flutter {
    source = "../.."
<<<<<<< HEAD
}
=======
}
>>>>>>> temp-fix
