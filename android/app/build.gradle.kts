plugins {
    id("com.android.application")
    id("kotlin-android")
    // Wtyczka Flutter Gradle musi być zastosowana po wtyczkach Android i Kotlin Gradle.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.appdistribution")
}

android {
    namespace = "com.example.gymbeast"
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
        // TODO: Określ swój własny, unikalny identyfikator aplikacji (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.gymbeast"
        // Możesz zaktualizować poniższe wartości, aby dopasować je do potrzeb swojej aplikacji.
        // Więcej informacji znajdziesz na stronie: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Dodaj własną konfigurację podpisywania dla kompilacji wydania.
            // Na razie podpisywanie kluczami debugowania, aby polecenie `flutter run --release` działało.
            signingConfig = signingConfigs.getByName("debug")
            
            // Konfiguracja Firebase App Distribution
            firebaseAppDistribution {
                appId = "1:1234567890:android:xxxxxxxxxxxxxxxx" // Tu wstaw App ID z Firebase Console
                // serviceCredentialsFile = "path/to/service-account.json"
                releaseNotes = "New release version"
                testers = "tester@example.com, tester2@example.com"
                artifactType = "APK"
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Importowanie Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))


    // TODO: Dodaj zależności dla produktów Firebase, których chcesz używać
    // Korzystając z BoM, nie określaj wersji w zależnościach Firebase
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")


    // Dodaj zależności dla innych pożądanych produktów Firebase
    // https://firebase.google.com/docs/android/setup#available-libraries
}