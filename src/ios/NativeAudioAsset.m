//
// 
//  NativeAudioAsset.m
//  NativeAudioAsset
//
//  Created by Sidney Bofah on 2014-06-26.
//

#import "NativeAudioAsset.h"

@implementation NativeAudioAsset

static const CGFloat FADE_STEP = 0.05;
static const CGFloat FADE_DELAY = 0.08;
static bool Initialized= NO;

static AVAudioEngine *engine;
static AVAudioMixerNode *mixer;

-(id) initWithPath:(NSString*) path withVolume:(NSNumber*) volume withRate:(NSNumber*) rate withFadeDelay:(NSNumber *)delay
{
    if (!Initialized) {
        engine = [[AVAudioEngine alloc] init];
        mixer = [engine mainMixerNode];
    }
    
    
    [self initBuffer:path];
    
    
    player = [[AVAudioPlayerNode alloc] init];
    
    player.volume = volume.floatValue;
    
    [engine attachNode:player];
    [engine connect:player to:mixer format:PCMBuffer.format];
    
    if(delay)
    {
        fadeDelay = delay;
    }
    else {
        fadeDelay = [NSNumber numberWithFloat:FADE_DELAY];
    }
            
    initialVolume = volume;
    
    if (rate.floatValue < 1.0) {
        [self setRate: rate];
    }
    
    if (!Initialized) {
        [engine startAndReturnError:nil];
        Initialized= YES;
    }
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
    [player scheduleBuffer:PCMBuffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:^{[self audioPlayerDidFinishPlaying:self successfully:YES];}];
	[player play];
}


// The volume is increased repeatedly by the fade step amount until the last step where the audio is stopped.
// The delay determines how fast the decrease happens
- (void)playWithFade
{

    if (!player.isPlaying)
    {
        [self play];
        dispatch_async(dispatch_get_main_queue(), ^{
            [player performSelector:@selector(playWithFade) withObject:nil afterDelay:fadeDelay.floatValue];
        });
    }
    else
    {
        if(player.volume < initialVolume.floatValue)
        {
            player.volume += FADE_STEP;
            dispatch_async(dispatch_get_main_queue(), ^{
                [player performSelector:@selector(playWithFade) withObject:nil afterDelay:fadeDelay.floatValue];
            });
        }
    }
}

- (void) stop
{
        [player stop];
  
}

// The volume is decreased repeatedly by the fade step amount until the volume reaches the configured level.
// The delay determines how fast the increase happens
- (void)stopWithFade
{
    if (player.isPlaying && player.volume > FADE_STEP) {
        player.volume -= FADE_STEP;
        
        [player performSelector:@selector(stopWithFade) withObject:nil afterDelay:fadeDelay.floatValue];
    } else {
        // Stop and get the sound ready for playing again
        [player stop];
        player.volume = initialVolume.floatValue;
    }
}

- (void) loop
{
    if (player.isPlaying) {
        [player stop];
    }
    [player scheduleBuffer:PCMBuffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:^{[self audioPlayerDidFinishPlaying:self successfully:YES];}];
    [player play];
}

- (void) unload 
{
    [self stop];
    player = nil;
}

- (void) setVolume:(NSNumber*) volume;
{
    [player setVolume:volume.floatValue];
}


bool rateInitialized = NO;
- (void) setRate:(NSNumber*) rate;
{
    if (!rateInitialized) {
        pitcher = [[AVAudioUnitTimePitch alloc] init];
        [engine attachNode:pitcher];
        [engine connect:pitcher to:mixer format:PCMBuffer.format];
        [engine connect:player to:pitcher format:PCMBuffer.format];
        rateInitialized = YES;
    }
    pitcher.rate = rate.floatValue;
    pitcher.pitch = 1000 * rate.floatValue;
}

- (void) setCallbackAndId:(CompleteCallback)cb audioId:(NSString*)aID
{
    self->audioId = aID;
    self->finished = cb;
}

- (void) audioPlayerDidFinishPlaying:(NativeAudioAsset *)ap successfully:(BOOL)flag
{
    if (self->finished) {
        self->finished(self->audioId);
    }
}

- (void) audioPlayerDecodeErrorDidOccur:(NativeAudioAsset *)ap error:(NSError *)error
{
    if (self->finished) {
        self->finished(self->audioId);
    }
}

@end
