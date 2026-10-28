package ua.lpnu.yahusevych.my_flashlight_plugin

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Керування апаратним ліхтариком через CameraManager.setTorchMode.
 * Перевіряє наявність спалаху перед викликом, тож на пристроях без нього
 * (планшети, емулятори) повертає помилку NO_FLASH замість винятку.
 */
class MyFlashlightPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var cameraManager: CameraManager? = null
    private var torchOn = false

    private val torchCallback = object : CameraManager.TorchCallback() {
        override fun onTorchModeChanged(cameraId: String, enabled: Boolean) {
            if (cameraId == flashCameraId()) torchOn = enabled
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "my_flashlight_plugin")
        channel.setMethodCallHandler(this)
        cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as? CameraManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            cameraManager?.registerTorchCallback(torchCallback, Handler(Looper.getMainLooper()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isAvailable" -> result.success(flashCameraId() != null)
            "toggle" -> setTorch(!torchOn, result)
            "turnOn" -> setTorch(true, result)
            "turnOff" -> setTorch(false, result)
            else -> result.notImplemented()
        }
    }

    /** Id задньої камери зі спалахом або null, якщо спалаху немає. */
    private fun flashCameraId(): String? {
        if (!context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            return null
        }
        val manager = cameraManager ?: return null
        return try {
            manager.cameraIdList.firstOrNull { id ->
                val c = manager.getCameraCharacteristics(id)
                c.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            }
        } catch (e: CameraAccessException) {
            null
        }
    }

    private fun setTorch(enable: Boolean, result: Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            result.error("UNSUPPORTED_SDK", "Потрібен Android 6.0+", null)
            return
        }
        val id = flashCameraId()
        if (id == null) {
            result.error("NO_FLASH", "На пристрої немає спалаху", null)
            return
        }
        try {
            cameraManager?.setTorchMode(id, enable)
            torchOn = enable
            result.success(torchOn)
        } catch (e: CameraAccessException) {
            result.error("CAMERA_ACCESS", e.message ?: "Камера зайнята", null)
        } catch (e: IllegalArgumentException) {
            result.error("NO_FLASH", e.message ?: "Спалах недоступний", null)
        } catch (e: SecurityException) {
            result.error("CAMERA_ACCESS", e.message ?: "Немає доступу", null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            cameraManager?.unregisterTorchCallback(torchCallback)
        }
        channel.setMethodCallHandler(null)
    }
}
