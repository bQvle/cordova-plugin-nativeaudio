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
    AVAudioEngine* engine;
	AVAudioPlayerNode* player;
	AVAudioPCMBuffer* PCMBuffer;
    AVAudioUnitVarispeed* pitcher;
	NSString* audioId;
	CompleteCallback finished;
	NSNumber *initialVolume;
	NSNumber *fadeDelay;
}

-(id)initWithEngine:(AVAudioEngine*)mainEngine Path:(NSString*)path Volume : (NSNumber*)volume Rate : (NSNumber*)rate;
-(void)play;
-(void)stop;
-(void)loop;
-(void)unload;
-(void)setVolume:(NSNumber*)volume;
-(void)setRate:(NSNumber*)rate;
-(void)setCallback:(CompleteCallback)cb audioId : (NSString*)audioId;
-(void)finishedCallback;
@end
