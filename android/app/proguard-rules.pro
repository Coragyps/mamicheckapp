# --- FIX para flutter_local_notifications + timezone ---
# Evita que R8 elimine información de tipos genéricos usados por TypeToken
-keep class com.dexterous.** { *; }

# Evita que ProGuard minimice clases de Gson (usadas por el plugin)
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken

# Evita perder firmas genéricas (Signature) y anotaciones necesarias
-keepattributes Signature
-keepattributes *Annotation*

# Asegura compatibilidad con NotificationCompat
-keep class androidx.core.app.NotificationCompat$** { *; }