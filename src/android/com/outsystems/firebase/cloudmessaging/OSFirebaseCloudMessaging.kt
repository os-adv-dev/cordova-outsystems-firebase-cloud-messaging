package com.outsystems.firebase.cloudmessaging;

import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingController
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingInterface
import com.outsystems.plugins.firebasemessaging.controller.FirebaseMessagingManager
import com.outsystems.plugins.firebasemessaging.controller.FirebaseNotificationManager
import com.outsystems.plugins.firebasemessaging.model.FirebaseMessagingError
import com.outsystems.plugins.oscordova.CordovaImplementation
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.Default
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.apache.cordova.CallbackContext
import org.json.JSONArray

class OSFirebaseCloudMessaging : CordovaImplementation() {

    override var callbackContext: CallbackContext? = null

    private val controllerDelegate = object: FirebaseMessagingInterface {
        override fun callback(token: String) {
            sendPluginResult(token)
        }
        override fun callbackSuccess() {
            sendPluginResult(true)
        }
        override fun callbackBadgeNumber(number: Int) {
            TODO("Not yet implemented")
        }
        override fun callbackError(error: FirebaseMessagingError) {
            sendPluginResult(false, Pair(error.code, error.description))
        }
    }
    private val messagingManager = FirebaseMessagingManager()
    private val notificationManager = FirebaseNotificationManager()
    private val controller = FirebaseMessagingController(controllerDelegate, messagingManager, notificationManager)

    override fun execute(action: String, args: JSONArray, callbackContext: CallbackContext): Boolean {
        this.callbackContext = callbackContext
        CoroutineScope(Default).launch {
            when (action) {
                "getToken" -> {
                    controller.getToken()
                }
                "subscribe" -> {
                    args.getString(0)?.let { topic ->
                        controller.subscribe(topic)
                    }
                }
                "unsubscribe" -> {
                    args.getString(0)?.let { topic ->
                        controller.unsubscribe(topic)
                    }
                }
                "registerDevice" -> {
                    controller.registerDevice()
                }
                "unregisterDevice" -> {
                    controller.unregisterDevice()
                }
                else -> {}
            }
        }
        return true
    }

    override fun onRequestPermissionResult(requestCode: Int,
                                           permissions: Array<String>,
                                           grantResults: IntArray) {
        TODO("Not yet implemented")
    }

    override fun areGooglePlayServicesAvailable(): Boolean {
        TODO("Not yet implemented")
    }
}