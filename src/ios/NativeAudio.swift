@objc(NativeAudio) class NativeAudio : CDVPlugin {
	var ERROR_ASSETPATH_INCORRECT: String = "(NATIVE AUDIO) Asset not found.";
	var ERROR_REFERENCE_EXISTS: String = "(NATIVE AUDIO) Asset reference already exists.";
	var ERROR_REFERENCE_MISSING: String = "(NATIVE AUDIO) Asset reference does not exist.";
	var ERROR_TYPE_RESTRICTED: String = "(NATIVE AUDIO) Action restricted to assets loaded using preloadComplex().";
	var ERROR_VOLUME_NIL: String = "(NATIVE AUDIO) Volume cannot be empty.";
	var ERROR_VOLUME_FORMAT: String = "(NATIVE AUDIO) Volume is declared as float between 0.0 - 1.0";
	var ERROR_RATE_NIL: String = "(NATIVE AUDIO) Rate cannot be empty.";
	var ERROR_RATE_FORMAT: String = "(NATIVE AUDIO) Rate is declared as float between 0.0 - 3.0";

	var INFO_ASSET_LOADED: String = "(NATIVE AUDIO) Asset loaded.";
	var INFO_ASSET_UNLOADED: String = "(NATIVE AUDIO) Asset unloaded.";
	var INFO_PLAYBACK_PLAY: String = "(NATIVE AUDIO) Play";
	var INFO_PLAYBACK_STOP: String = "(NATIVE AUDIO) Stop";
	var INFO_PLAYBACK_LOOP: String = "(NATIVE AUDIO) Loop.";
	var INFO_VOLUME_CHANGED: String = "(NATIVE AUDIO) Volume changed.";
	var INFO_RATE_CHANGED: String = "(NATIVE AUDIO) Rate changed.";
	
	func pluginInitialize() {

	}

	func setOptions(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func preloadSimple(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func preloadSimple(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func preloadComplex(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func play(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func stop(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func loop(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func unload(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func setVolumeForComplexAsset(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func setRateForComplexAsset(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}

	func addCompleteListener(command: CDVInvokedUrlCommand) {
		self.commandDelegate!.sendPluginResult(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "not implemented yet"), callbackId: command.callbackId)
	}
}
