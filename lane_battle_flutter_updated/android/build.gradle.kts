allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
subprojects {
    project.plugins.whenPluginAdded {
        if (this is com.android.build.gradle.BasePlugin) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            android.compileSdkVersion(34)
            android.buildToolsVersion("34.0.0")
        }
        if (this is com.android.build.gradle.LibraryPlugin) {
            val library = project.extensions.getByName("android") as com.android.build.gradle.LibraryExtension
            if (library.namespace == null) {
                library.namespace = project.group.toString()
            }
        }
    }
}
