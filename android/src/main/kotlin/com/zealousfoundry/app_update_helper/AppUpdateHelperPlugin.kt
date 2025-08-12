package com.zealousfoundry.app_update_helper

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.app.Activity
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** AppUpdateHelperPlugin */
class AppUpdateHelperPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null
    private var appUpdateManager: AppUpdateManager? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        appUpdateManager = AppUpdateManagerFactory.create(activity!!)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        appUpdateManager = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        appUpdateManager = AppUpdateManagerFactory.create(activity!!)
    }

    override fun onDetachedFromActivity() {
        activity = null
        appUpdateManager = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_update_helper")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        when (call.method) {
            "canUpdate" -> canUpdate(result)
            "update" -> update(result)
            else -> result.notImplemented()
        }
    }

    private fun canUpdate(result: Result) {
         val manager = appUpdateManager
        if (manager == null) {
            result.error("NO_ACTIVITY", "Activity is null", null)
            return
        }

      manager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            val available =
                appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                        appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
            result.success(available)
        }.addOnFailureListener {
            result.error("CHECK_FAILED", it.message, null)
        }
    }

    private fun update(result: Result) {
        val activity = this.activity
        val manager = this.appUpdateManager
        if (activity == null || manager == null) {
            result.error("NO_ACTIVITY", "Activity is null", null)
            return
        }

        manager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            val options = AppUpdateOptions.newBuilder(AppUpdateType.IMMEDIATE).build()

            manager.startUpdateFlow(appUpdateInfo, activity, options)
                .addOnSuccessListener {
                    // Update flow started successfully
                    result.success(true)
                }
                .addOnFailureListener {
                    result.error("UPDATE_FAILED", it.message, null)
                }
        }.addOnFailureListener {
            result.error("CHECK_FAILED", it.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}
