allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
plugins {

    id ("dev.flutter.flutter-gradle-plugin") version "1.0.0"

    // Add the dependency for the Google services Gradle plugin
    id("com.google.gms.google-services") version "4.4.2"

}
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
