## 0.6.2

Released 2025-01-23

  - Add TARGET_OS_ANDROID envrionment and compiler directive to Android build (#50)

## 0.2.1

Released 2024-12-12

  - Merge pull request #33 from skiptools/anybridge
  - Bridge 'Any' types
  - Snapshot progress towards bridging Any and polymorphic types
  - Update README

## 0.1.1

Released 2024-12-01

  - Add -fPIC compiler argument when building (works around https://github.com/finagolfin/swift-android-sdk/issues/195)
  - Merge pull request #30 from skiptools/dynamicconfig
  - Tweaks to dynamic object support
  - Merge pull request #29 from skiptools/enums2
  - Add additional enum tests
  - Attempt to re-enable skip export in CI

## 0.1.0

Released 2024-11-27

  - Set SKIP_BRIDGE_MODULES metadata template in AndroidManifest.xml to the primary native module so it can be loaded at app launch time
  - Merge pull request #28 from skiptools/enum1
  - Support Kotlin -> Swift enum bridging
  - Merge pull request #26 from skiptools/dynamic
  - Add support for accessing statics
  - Support dynamic Java access

## 0.0.6

Released 2024-11-21

  - Merge pull request #23 from skiptools/remove-macros
  - Remove macros
  - Re-enable local test cases

## 0.0.5

Released 2024-11-20

  - Only run the skip android build process for the root bridged module as specified in the settings.gradle.kts
  - Change swift/kotlin mode names to native/transpiled
  - Merge pull request #22 from skiptools/bridgekotlin
  - Disable export in CI
  - Support Java/Kotlin conversion options
  - Update checking for multiple modules; disable export in CI
  - Add module-cache-path flag to swift command to avoid conflicts in in cached modules between different targets

## 0.0.4

Released 2024-11-17


## 0.0.3

Released 2024-11-17

  - Disable global build flag for building a dependent package only once
  - Restore global build flag for building a dependent package only once
  - Fix for locating skip command
  - Update jni-libs output folder to native build; add flag to only perform the native build once per project
  - Merge pull request #21 from skiptools/bridgepublic
  - Updates for bridging all public API
  - Merge pull request #20 from skiptools/singlemode
  - Fix path to local skip tool to accomodate iOS builds
  - Updates to work with new package output tree; add SKIP_BRIDGE blocks
  - Divide SkipBridgeSamples into single-mode modules
  - Divide SkipBridge into SkipBridge/SkipBridge
  - Merge pull request #19 from skiptools/skip-bridge-deps
  - Change SKIP_JNI_MODE to SKIP_BRIDGE and outpit swift build to shared buildDir
  - Merge pull request #18 from skiptools/kotlinstruct
  - Test @BridgeToSwift structs
  - Merge pull request #17 from skiptools/protocols
  - Support protocols
  - Merge pull request #16 from skiptools/equalshash
  - Support bridging Equatable, Hashable, Comparable, Codable
  - Fix call to jni.releaseByteArrayElements to use JniReleaseArrayElementsMode
  - Fix final parameter of releaseByteArrayElements to use JniReleaseArrayElementsMode rather than the size of the array (which causes a crash on the device)
  - Merge pull request #15 from skiptools/foundationtypes
  - Bridge common Foundation types
  - Progress on bridging common Foundation types

## 0.0.2

Released 2024-10-31

  - Configure jniLibs to use pickFirsts to prevent errors about duplicate symbols

