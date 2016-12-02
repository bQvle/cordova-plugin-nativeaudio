//
// 
//  NativeAudio.m
//  NativeAudio
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import "NativeAudio.h"

@implementation NativeAudio

NSString* ERROR_ASSETPATH_INCORRECT = @"(NATIVE AUDIO) Asset not found.";
NSString* ERROR_REFERENCE_EXISTS = @"(NATIVE AUDIO) Asset reference already exists.";
NSString* ERROR_REFERENCE_MISSING = @"(NATIVE AUDIO) Asset reference does not exist.";
NSString* ERROR_VOLUME_NIL = @"(NATIVE AUDIO) Volume cannot be empty.";
NSString* ERROR_VOLUME_FORMAT = @"(NATIVE AUDIO) Volume is declared as float between 0.0 - 3.0";
NSString* ERROR_RATE_NIL = @"(NATIVE AUDIO) Rate cannot be empty.";
NSString* ERROR_RATE_FORMAT = @"(NATIVE AUDIO) Rate is declared as float between 0.0 - 3.0";

NSString* INFO_ASSET_LOADED = @"(NATIVE AUDIO) Asset loaded.";
NSString* INFO_ASSET_UNLOADED = @"(NATIVE AUDIO) Asset unloaded.";
NSString* INFO_PLAYBACK_PLAY = @"(NATIVE AUDIO) Play";
NSString* INFO_PLAYBACK_STOP = @"(NATIVE AUDIO) Stop";
NSString* INFO_PLAYBACK_LOOP = @"(NATIVE AUDIO) Loop.";
NSString* INFO_VOLUME_CHANGED = @"(NATIVE AUDIO) Volume changed.";
NSString* INFO_RATE_CHANGED = @"(NATIVE AUDIO) Rate changed.";

- (void)pluginInitialize
{
    if(audioMapping == nil) {
        audioMapping = [NSMutableDictionary dictionary];
    }

	if (engine == nil) {
		engine = [[AVAudioEngine alloc] init];
		mixer = [engine mainMixerNode];
		[engine startAndReturnError:nil];
	}
}


- (void) setMasterVolume:(CDVInvokedUrlCommand *)command
{
	NSString *callbackId = command.callbackId;
    NSArray *arguments = command.arguments;
    NSNumber *volume = nil;
    if ( [arguments count] > 0) {
        volume = [arguments objectAtIndex:0];
        if([volume isEqual:nil]) {
            NSString* RESULT = [NSString stringWithFormat:@"%@", ERROR_VOLUME_NIL];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    
	} else if (([volume floatValue] < 0.0f) || ([volume floatValue] > 3.0f)) {
        NSString* RESULT = [NSString stringWithFormat:@"%@", ERROR_VOLUME_FORMAT];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
    } else {
		[mixer setOutputVolume:[volume floatValue]];
		[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: INFO_VOLUME_CHANGED] callbackId:callbackId];
	}
}


- (void) preload:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    NSString *assetPath = [arguments objectAtIndex:1];

    NSNumber *volume = nil;
    if ( [arguments count] > 2 ) {
        volume = [arguments objectAtIndex:2];
        if([volume isEqual:nil]) {
            volume = [NSNumber numberWithFloat:1.0f];
        }
    } else {
        volume = [NSNumber numberWithFloat:1.0f];
    }

	NSNumber *rate = nil;
    if ( [arguments count] > 3 ) {
        rate = [arguments objectAtIndex:3];
        if([rate isEqual:nil]) {
            rate = [NSNumber numberWithFloat:1.0f];
        }
    } else {
        rate = [NSNumber numberWithFloat:1.0f];
    }




    NSNumber* existingReference = audioMapping[audioID];

    [self.commandDelegate runInBackground:^{
        if (existingReference == nil) {
		    NSString* basePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www"];
            NSString* path = [NSString stringWithFormat:@"%@", assetPath];

			if (![[NSFileManager defaultManager] fileExistsAtPath : path]) {
				path = [NSString stringWithFormat:@"%@/%@", basePath ,assetPath];

				if (![[NSFileManager defaultManager] fileExistsAtPath : path]) {
					NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
					path = [NSString stringWithFormat:@"%@/%@", tempPath,assetPath];
				}
			}
			

            if (![[NSFileManager defaultManager] fileExistsAtPath : path]) {
				NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_ASSETPATH_INCORRECT, assetPath];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];

               

            } else {
                 NativeAudioAsset* asset = [[NativeAudioAsset alloc] initWithEngine:engine 
																			   Path:path
                                                                             Volume:volume
																	           Rate:rate];
                
                audioMapping[audioID] = asset;

                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_ASSET_LOADED, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
            }
        } else {

            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_EXISTS, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }

    }];
}

- (void) play:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];

    [self.commandDelegate runInBackground:^{
        if (audioMapping) {
            NSObject* asset = audioMapping[audioID];
            if (asset != nil){
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                [_asset play];
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_PLAYBACK_PLAY, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
            } else {
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
            }
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    }];
}

- (void) stop:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];

    if ( audioMapping ) {
        NSObject* asset = audioMapping[audioID];

        if (asset != nil){
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset stop];
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_PLAYBACK_STOP, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];    }
}

- (void) loop:(CDVInvokedUrlCommand *)command
{

    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];


    if ( audioMapping ) {
        NSObject* asset = audioMapping[audioID];
        if (asset != nil){
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset loop];
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_PLAYBACK_LOOP, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        };
    }
}

- (void) unload:(CDVInvokedUrlCommand *)command
{

    NSString* callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString* audioID = [arguments objectAtIndex:0];

    if ( audioMapping ) {
        NSObject* asset = audioMapping[audioID];

        if (asset != nil){
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset unload];
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
        [audioMapping removeObjectForKey: audioID];
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_ASSET_UNLOADED, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
    }
    
}

- (void) setVolume:(CDVInvokedUrlCommand *)command
{
    NSString* callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString* audioID = [arguments objectAtIndex:0];
    NSNumber* volume = nil;

    if ( [arguments count] > 1 ) {
        volume = [arguments objectAtIndex:1];
        if([volume isEqual:nil]) {
            NSString* RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_VOLUME_NIL, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    
	} else if (([volume floatValue] < 0.0f) || ([volume floatValue] > 1.0f)) {
        NSString* RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_VOLUME_FORMAT, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
    }

    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];

        if (asset != nil){
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset setVolume:volume];

            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_VOLUME_CHANGED, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];    }
}


- (void) setRate:(CDVInvokedUrlCommand *)command
{
    NSString* callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString* audioID = [arguments objectAtIndex:0];
    NSNumber* rate = nil;

    if ( [arguments count] > 1 ) {

        rate = [arguments objectAtIndex:1];

        if([rate isEqual:nil]) {

            NSString* RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_RATE_NIL, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else if (([rate floatValue] < 0.0f) || ([rate floatValue] > 3.0f)) {
        NSString* RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_RATE_FORMAT, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
    }

    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];

        if (asset != nil){
            NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
            [_asset setRate:rate];

            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_RATE_CHANGED, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];    }
}

- (void) sendCompleteCallback:(NSString*)forId {
    NSString* callbackId = self->completeCallbacks[forId];
    if (callbackId) {
        NSDictionary* RESULT = [NSDictionary dictionaryWithObject:forId forKey:@"id"];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:RESULT] callbackId:callbackId];
        [self->completeCallbacks removeObjectForKey:forId];
    }
}

- (void) addCompleteListener:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    [self.commandDelegate runInBackground:^{
        if (audioMapping) {
            
            NSObject* asset = audioMapping[audioID];
            
            if (asset != nil){
                
                if(completeCallbacks == nil) {
                    completeCallbacks = [NSMutableDictionary dictionary];
                }
                completeCallbacks[audioID] = command.callbackId;
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                [_asset setCallback:^(NSString* audioID) {[self sendCompleteCallback:audioID];} audioId:audioID];
            } else {
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
            }
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    }];
}

@end
