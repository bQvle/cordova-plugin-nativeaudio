//
//
//  NativeAudioAsset.h
//  NativeAudioAsset
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^CompleteCallback)(NSString*);

@interface NativeAudioAsset : NSObject  {
	AVAudioPlayerNode* player;
	AVAudioPCMBuffer* PCMBuffer;
	NSString* audioId;
	CompleteCallback finished;
	NSNumber *initialVolume;
	NSNumber *fadeDelay;
}

-(id)initWithPath:(NSString*)path withVolume : (NSNumber*)volume withFadeDelay : (NSNumber *)delay;
-(void)play;
-(void)playWithFade;
-(void)stop;
-(void)stopWithFade;
-(void)loop;
-(void)unload;
-(void)setVolume:(NSNumber*)volume;
-(void)setRate:(NSNumber*)rate;
-(void)setCallbackAndId:(CompleteCallback)cb audioId : (NSString*)audioId;
-(void)audioPlayerDidFinishPlaying:(NativeAudioAsset *)ap successfully : (BOOL)flag;
-(void)audioPlayerDecodeErrorDidOccur:(NativeAudioAsset *)ap error : (NSError *)error;
@end
