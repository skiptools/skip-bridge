## SkipBridge

SkipBridge provides bridging between Swift and Java.


demo-package
  ModA
  ModB

demo-package.output/ModA/skipstone/ModA/src/main/swift/Package.swift -> FileA_SpecialBridge.swift

demo-package.output/ModB/skipstone/ModA/src/main/build.gradle.kts
demo-package.output/ModB/skipstone/ModA/src/main/kotlin/…
demo-package.output/ModB/skipstone/ModA/src/main/swift/Package.swift
                                                      /Sources
                                                              /ModA
                                                                    /FileA.swift
                                                                    /FileA_Bridge.swift
                                                                    /FileA_SpecialBridge.swift

demo-package.output/ModB/skipstone/ModB/src/main/build.gradle.kts
demo-package.output/ModB/skipstone/ModB/src/main/kotlin/…
demo-package.output/ModB/skipstone/ModB/src/main/swift/Package.swift
                                                      /Sources
                                                              /ModA -> ../../../../ModA/src/main/swift/Sources/ModA
                                                                    /FileA.swift
                                                                    /FileA_Bridge.swift
                                                              /ModB
                                                                    /FileB.swift
                                                                    /FileB_Bridge.swift
                                                                    /FileB_SpecialBridge.swift

demo-package.output/ModB/skipstone/ModB/test/main/build.gradle.kts
demo-package.output/ModB/skipstone/ModB/test/main/kotlin/…
demo-package.output/ModB/skipstone/ModB/test/main/swift/Package.swift
                                                       /Tests
                                                              /ModATests
                                                                        /TestFileA.swift
                                                              /ModBTests
                                                                        /TestFileB.swift


## Tips

To speed up local testing, set the `SKIP_BRIDGE_ANDROID_BUILD_DISABLED=1` environment variable from Xcode, which will prevent the `skip android` command from building the Android libraries for each supported architecture, leaving just the local Robolectric build. Conversly, if you are *only* testing against an Android emulator/device (by setting the `ANDROID_SERIAL` environment variable), you can disable the local Robolectric build by setting the `SKIP_BRIDGE_ROBOLECTRIC_BUILD_DISABLED=1` variable, which will only build for the support Android architectures and avoid building locally.

