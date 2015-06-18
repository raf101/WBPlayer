﻿package {	import com.cognizant.google.video.components.controls.PlaybackController;	import com.cognizant.google.video.components.DefaultPlayer;	import com.cognizant.google.video.components.ExPlayer;	import com.cognizant.google.video.data.PlayerSettings;	import com.cognizant.google.video.data.ScheduledData;	import com.cognizant.google.video.data.VideoData;	import com.cognizant.google.video.events.CustomVideoEvent;	import com.cognizant.google.video.utils.dateSwap;	import com.cognizant.google.wb.components.WBPlayer;	import com.google.ads.studio.utils.Logger;	import com.google.ads.studio.video.VideoPlayerAdvanced;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.events.Event;	import flash.geom.Rectangle;		/**	 * ...	 * @author Rafael Nepomuceno	 */	public class Main extends MovieClip {		public var testVid:VideoPlayerAdvanced;		public var player:MovieClip;				private var _playbackCtrl:PlaybackController;				public function Main():void {			if (stage) init();			else addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(e:Event = null):void {			removeEventListener(Event.ADDED_TO_STAGE, init);			// entry point						Logger.setLoggingCallback(null);			dateSwapTest();			//testExPlayer();			//testController();			testWBPlayer();			//testDefaultPlayer();			ExPlayer.addAllEventListeners(videosEventHandler);					}				private function dateSwapTest ():void {			var testDate:Date = new Date(2015, 5, 7); // For testing						var schedPre:ScheduledData = new ScheduledData('pre', new Date(2015, 5, 6, 23), new Date(2015, 5, 7));			var schedNow:ScheduledData = new ScheduledData('now', new Date(2015, 5, 7), new Date(2015, 5, 9));			var schedPost:ScheduledData = new ScheduledData('post', new Date(2015, 5, 9), new Date(2015, 5, 10));						//trace(dateSwap([schedPre, schedNow, schedPost]));			trace(dateSwap([schedPre, schedNow, schedPost], testDate)); // Test using test date			// -- result 'now'					}				private function testExPlayer ():void {			var id:String = 'testVid';			var streamingData:Array = null;			var progressiveData:Array = [new VideoData('vid', 'video.flv'), new VideoData('vid2', 'video2.flv')];			var dimension:Rectangle = new Rectangle(0, 0, 536, 300);			var startMuted:Boolean = true;			var autoPlay:Boolean = true;			var previewTime:Number = 0;			var componentInstance:Object = null; // ExPlayerAdvanced instance			var autoAdvanceVideoOnComplete:Boolean = false;			var autoDestroy:Boolean = true;			var settings:PlayerSettings = new PlayerSettings(id, streamingData, progressiveData, dimension, startMuted, autoPlay, previewTime, componentInstance, autoAdvanceVideoOnComplete, autoDestroy);						var video:ExPlayer = new ExPlayer();			video.init(settings);						player.container.addChild(video);		}				private function videosEventHandler (e:CustomVideoEvent):void {			//if (e.type != 'playheadMove') 			trace('> CustomVideoEvent', e.type, '\t->\t' + e.data.toString());			switch (e.type) {				case CustomVideoEvent.BUFFERED:					break;				case CustomVideoEvent.DURATION:					break;				case CustomVideoEvent.PLAY:					break;				case CustomVideoEvent.PAUSE:					break;				case CustomVideoEvent.MUTE:					break;				case CustomVideoEvent.UNMUTE:					break;				case CustomVideoEvent.FIRST_QUARTILE:					break;				case CustomVideoEvent.MID_POINT:					break;				case CustomVideoEvent.THIRD_QUARTILE:					break;				case CustomVideoEvent.PLAYHEAD_MOVE:					break;				case CustomVideoEvent.COMPLETE:					break;				case CustomVideoEvent.REPLAY:					break;				case CustomVideoEvent.SKIP:					break;				case CustomVideoEvent.PREVIEW_COMPLETE:					break;				case CustomVideoEvent.COMPLETE_ALL:					break;				case CustomVideoEvent.VIDEO_VIEW_TIMER_START:					break;				case CustomVideoEvent.VIDEO_VIEW_TIMER_STOP:					break;				case CustomVideoEvent.USER_CLICK_TO_PLAY:					break;				case CustomVideoEvent.USER_SEEK:					break;				case CustomVideoEvent.USER_PLAY:					break;				case CustomVideoEvent.USER_PAUSE:					break;				case CustomVideoEvent.USER_STOP:					break;				case CustomVideoEvent.USER_MUTE:					break;				case CustomVideoEvent.USER_UNMUTE:					break;				case CustomVideoEvent.USER_REPLAY:					break;				case CustomVideoEvent.CONNECTION_ERROR:					break;				default:			}		}				private function testController ():void {			_playbackCtrl = new PlaybackController(ExPlayer.getCurrentVideo());						_playbackCtrl.setPlayToggle(player.togglePlay);			_playbackCtrl.setStopToggle(player.toggleStop);			_playbackCtrl.setMuteToggle(player.toggleMute);			_playbackCtrl.setSkipToToggle(player.toggleSkipTo0, 0);			_playbackCtrl.setSkipToToggle(player.toggleSkipTo1, 1);			_playbackCtrl.setReplayButton(player.btnReplay);			_playbackCtrl.setSeekBar(player.mcSeekbar.bar, player.mcSeekbar.hit, player.mcSeekbar.knob);		}				public function testDefaultPlayer ():DisplayObject {			var id:String = 'testVid';			var streamingData:Array = null;			var progressiveData:Array = [new VideoData('vid', 'video.flv'), new VideoData('vid2', 'video2.flv')];			var dimension:Rectangle = new Rectangle(0, 0, 536, 300);			var startMuted:Boolean = true;			var autoPlay:Boolean = true;			var previewTime:Number = 0;			var componentInstance:Object = null; // ExPlayerAdvanced instance			var autoAdvanceVideoOnComplete:Boolean = false;			var autoDestroy:Boolean = true;			var settings:PlayerSettings = new PlayerSettings(id, streamingData, progressiveData, dimension, startMuted, autoPlay, previewTime, componentInstance, autoAdvanceVideoOnComplete, autoDestroy);									var defaultPlayer:DefaultPlayer = new DefaultPlayer();			defaultPlayer.init(settings);						addChild(defaultPlayer);			return defaultPlayer;		}				public function testWBPlayer ():DisplayObject {			var id:String = 'testVid';			var streamingData:Array = null;			var progressiveData:Array = [new VideoData('vid', 'video.flv'), new VideoData('vid2', 'video2.flv')];			var dimension:Rectangle = new Rectangle(0, 0, 536, 300);			var startMuted:Boolean = true;			var autoPlay:Boolean = true;			var previewTime:Number = 0;			var componentInstance:Object = null; // ExPlayerAdvanced instance			var autoAdvanceVideoOnComplete:Boolean = false;			var autoDestroy:Boolean = true;			var settings:PlayerSettings = new PlayerSettings(id, streamingData, progressiveData, dimension, startMuted, autoPlay, previewTime, componentInstance, autoAdvanceVideoOnComplete, autoDestroy);						id = 'testVidHD';			streamingData = null;			progressiveData = [new VideoData('vidHD', 'video.flv'), new VideoData('vid2HD', 'video2.flv')];			var settings2:PlayerSettings = new PlayerSettings(id, streamingData, progressiveData, dimension, startMuted, autoPlay, previewTime, componentInstance, autoAdvanceVideoOnComplete, autoDestroy);									var wbPlayer:WBPlayer = new WBPlayer();			wbPlayer.init(settings);			wbPlayer.initFullscreen(settings2);						addChild(wbPlayer);			return wbPlayer;		}	}	}