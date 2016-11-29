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

	private NativeAudioAssetComplex voice;
	private int playIndex = 0;
	
	public NativeAudioAsset(AssetFileDescriptor afd, float volume) throws IOException
	{
		voice = new NativeAudioAssetComplex(afd, volume);
	}
	
	public void play(Callable<Void> completeCb) throws IOException
	{
		voice.play(completeCb);
	}

	public boolean pause()
	{
		boolean wasPlaying |= voice.pause();
		return wasPlaying;
	}

	public void resume()
	{
		// only resumes first instance, assume being used on a stream and not multiple sfx
	    voice.resume();

	}

    public void stop()
	{
		voice.stop();
	}
	
	public void loop() throws IOException
	{
		voice.loop();
	}
	
	public void unload() throws IOException
	{
		this.stop();
		voice.unload();
	}
	
	public void setVolume(float volume)
	{
		voice.setVolume(volume);
	}
}