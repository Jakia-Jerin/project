plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("android/key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}




android {
    namespace = "com.example.theme_desiree"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.theme_desiree"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
       release {
        try {
            def storeFilePath = keystoreProperties['STORE_FILE']
            if (storeFilePath != null) {
                storeFile file("android/app/" + storeFilePath)
                storePassword keystoreProperties['STORE_PASSWORD']
                keyAlias keystoreProperties['KEY_ALIAS']
                keyPassword keystoreProperties['KEY_PASSWORD']
            } else {
                println("❌ STORE_FILE is null!")
               
            }
             println("👉 STORE_FILE = " + keystoreProperties['STORE_FILE'])
        } catch(Exception e) {
            println("❌ Error loading keystore: " + e.message)
        }
    }
}

    buildTypes {
        release {
        signingConfig signingConfigs.release
        minifyEnabled false
        shrinkResources false
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
    }
}

flutter {
    source = "../.."
}
