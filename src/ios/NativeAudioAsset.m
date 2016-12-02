//
// 
//  NativeAudioAsset.m
//  NativeAudioAsset
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import "NativeAudioAsset.h"

@implementation NativeAudioAsset

-(id) initWithEngine:(AVAudioEngine*)mainEngine Path:(NSString*) path Volume:(NSNumber*) volume Rate:(NSNumber*) rate
{
    engine = mainEngine;
    AVAudioMixerNode *mixer = [engine mainMixerNode];

    [self initBuffer:path];
    player = [[AVAudioPlayerNode alloc] init];
    pitcher = [[AVAudioUnitVarispeed alloc] init];
    [engine attachNode:pitcher];
    [engine attachNode:player];
    [engine connect:pitcher to:mixer format:PCMBuffer.format];
    [engine connect:player to:pitcher format:PCMBuffer.format];
    [self setRate: rate];
    [self setVolume: volume];
    return self;
}

- (void) initBuffer:(NSString*) path;
{
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AVAudioFile *fil = [[AVAudioFile alloc] initForReading:pathURL error:nil];
        AVAudioFrameCount length = (AVAudioFrameCount)fil.length;
        PCMBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:fil.processingFormat frameCapacity:length];
        [fil readIntoBuffer:PCMBuffer error:nil];
}



- (void) play
{
    [player scheduleBuffer:PCMBuffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:^{
        [self finishedCallback];
    }];
	[player play];
}



- (void) stop
{
        [player stop];
  
}


- (void) loop
{
    if (player.isPlaying) {
        [player stop];
    }
    [player scheduleBuffer:PCMBuffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:^{[self finishedCallback];}];
    [player play];
}

- (void) unload 
{
    [self stop];
    [engine detachNode:player];
    [engine detachNode:pitcher];
    [engine disconnectNodeOutput:pitcher];
    [engine disconnectNodeOutput:player];
    pitcher = nil;
    player = nil;
    PCMBuffer = nil;
}

- (void) setVolume:(NSNumber*) volume;
{
    [player setVolume:volume.floatValue];
}


- (void) setRate:(NSNumber*) rate;
{
    float rateValue = rate.floatValue;
    if (rateValue == 1.0f) {
        pitcher.bypass = YES;
    }
    else {
        pitcher.bypass = NO;
        pitcher.rate = rateValue;
    }
}

- (void) setCallback:(CompleteCallback)cb audioId:(NSString*)aID
{
    self->audioId = aID;
    self->finished = cb;
}

- (void) finishedCallback
{
    if (self->finished) {
        self->finished(self->audioId);
    }
}


@end
