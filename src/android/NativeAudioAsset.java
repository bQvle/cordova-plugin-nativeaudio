//
//
//  NativeAudioAsset.java
//
//  Created by Sidney Bofah on 2014-06-26.
//

package com.rjfun.cordova.plugin.nativeaudio;

import java.io.IOException;
import java.util.ArrayList;
import java.util.concurrent.Callable;

import android.content.res.AssetFileDescriptor;

public class NativeAudioAsset
{

	private NativeAudioAssetComplex audio;
	
	public NativeAudioAsset(AssetFileDescriptor afd, float volume, float rate) throws IOException
	{
		audio = new NativeAudioAssetComplex(afd, volume, rate);
	}
	
	public void play(Callable<Void> completeCb) throws IOException
	{
		audio.play(completeCb);
	}

	public boolean pause()
	{
		boolean wasPlaying |= audio.pause();
		return wasPlaying;
	}

	public void resume()
	{
		// only resumes first instance, assume being used on a stream and not multiple sfx
	    audio.resume();

	}

    public void stop()
	{
		audio.stop();
	}
	
	public void loop() throws IOException
	{
		audio.loop();
	}
	
	public void unload() throws IOException
	{
		this.stop();
		audio.unload();
	}
	
	public void setVolume(float volume)
	{
		audio.setVolume(volume);
	}

	public void setRate(float rate)
	{
		audio.setRate(rate);
	}
}