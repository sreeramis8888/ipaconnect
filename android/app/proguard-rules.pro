# flutter_secure_storage (uses AndroidX EncryptedSharedPreferences)
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Required for AndroidX Security Crypto
-keep class androidx.security.crypto.** { *; }

# Keep EncryptedSharedPreferences and related classes
-keep class androidx.security.** { *; }

# Needed for encryption key generation and secure storage
-keep class javax.crypto.** { *; }
-dontwarn javax.crypto.**


# Avoid stripping out annotations (safe practice)
-keepattributes *Annotation*

# Optional: if you're using reflection (e.g., with Firebase)
-keepclassmembers class * {
  @androidx.annotation.Keep *;
}


-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider