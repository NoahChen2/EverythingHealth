// Using fully qualified names to avoid any import issues
import java.util.Properties
import java.io.File

pluginManagement {
    val flutterSdkPath = run {
        val properties = Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")


// START: ADD THIS ENTIRE BLOCK TO THE END OF THE FILE
// This block manually loads the Flutter plugins and allows us to inject a fix.

val flutterProjectRoot = rootProject.projectDir.parentFile
val pluginsFile = File(flutterProjectRoot, ".flutter-plugins")
if (pluginsFile.exists()) {
    val plugins = Properties()
    pluginsFile.inputStream().use { plugins.load(it) }
    plugins.forEach { (name, path) ->
        val pluginDirectory = File(flutterProjectRoot, path as String).resolve("android")
        include(":$name")
        project(":$name").projectDir = pluginDirectory

        // THIS IS THE FIX:
        // If we find the problematic package, create a build.gradle file for it
        // that ONLY sets the namespace.
        if (name == "isar_flutter_libs") {
            File(pluginDirectory, "build.gradle").writeText("""
                android {
                    namespace = "com.isar.isar_flutter_libs"
                }
            """.trimIndent())
        }
    }
}
// END: ADD THIS ENTIRE BLOCK