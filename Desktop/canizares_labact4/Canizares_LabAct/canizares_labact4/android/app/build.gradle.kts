import java.util.Properties
import java.io.FileInputStream

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    throw GradleException("key.properties not found in android/ folder")
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.devera_labact4"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.devera_labact4"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing config for release build
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]?.toString()
                ?: throw GradleException("keyAlias not found in key.properties")
            keyPassword = keystoreProperties["keyPassword"]?.toString()
                ?: throw GradleException("keyPassword not found in key.properties")
            storePassword = keystoreProperties["storePassword"]?.toString()
                ?: throw GradleException("storePassword not found in key.properties")
            storeFile = file(keystoreProperties["storeFile"]?.toString()
                ?: throw GradleException("storeFile not found in key.properties"))
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}
