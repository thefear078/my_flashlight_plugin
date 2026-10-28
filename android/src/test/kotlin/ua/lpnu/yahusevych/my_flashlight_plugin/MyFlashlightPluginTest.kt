package ua.lpnu.yahusevych.my_flashlight_plugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

/*
 * Юніт-тест Kotlin-частини: невідомий метод -> notImplemented().
 * Запуск: ./gradlew testDebugUnitTest у example/android/.
 */
internal class MyFlashlightPluginTest {
    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = MyFlashlightPlugin()
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(MethodCall("unknown", null), mockResult)
        Mockito.verify(mockResult).notImplemented()
    }
}
