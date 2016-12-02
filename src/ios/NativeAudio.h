//
// 
//  NativeAudio.h
//  NativeAudio
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>
#import "NativeAudioAsset.h"

@interface NativeAudio : CDVPlugin{
	NSMutableDictionary* audioMapping;
	NSMutableDictionary* completeCallbacks;
	AVAudioEngine* engine;
	AVAudioMixerNode* mixer;
}

-(void)setMasterVolume:(CDVInvokedUrlCommand *)command;
-(void)preload:(CDVInvokedUrlCommand *)command;
-(void)play:(CDVInvokedUrlCommand *)command;
-(void)stop:(CDVInvokedUrlCommand *)command;
-(void)loop:(CDVInvokedUrlCommand *)command;
-(void)unload:(CDVInvokedUrlCommand *)command;
-(void)setVolume:(CDVInvokedUrlCommand *)command;
-(void)setRate:(CDVInvokedUrlCommand *)command;
-(void)addCompleteListener:(CDVInvokedUrlCommand *)command;
@end