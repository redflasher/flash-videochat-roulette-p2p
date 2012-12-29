package ru.redflasher.p2pvideo
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author Alex Burlakov (aka Redflasher);
	 */
	public class ChatUser extends Sprite implements IChatUser, IEventDispatcher
	{
		public static const BROADCASTER:String = 'broadcaster';
		public static const RECEIVER:String = 'receiver';
		public static const VIDEO_SUCCESS:String = 'video_success_and_work';
		public static const CONNECT_SUCCESS:String = 'connect_success';
		public static const CONNECT_GROUP_SUCCESS:String = 'connect_group_success';
		static public const VIDEO_CLOSE:String = "video_close";
		
		
		private const SERVER:String = "rtmfp://stratus.adobe.com/";
		private const DEVKEY:String = "138e7cbfdfd11b3028604351-fbbce7d3ed8e";
		
		private var _key:String = '';
		private var _status:String = '';
		private var netConnection:NetConnection;
		private var stream:NetStream;
		private var _video:Video;
		private var _isSoundUnmute:Boolean = false;
		
		/**
		 * 
		 * @param	key - is name of p2p-channel
		 * @param	status - is status of this screen. f - free(show "start" button", b - this user is broadcaster, r - this user is receiver.
		 */
		public function ChatUser(key:String,status:String):void
		{
			this._key = key;
			this._status = status;
		}
		
		/**
		 * init this screen
		 */
		public function init():void 
		{
			this.addEventListener(ChatUser.CONNECT_SUCCESS,connectToGroup);
			this.addEventListener(ChatUser.CONNECT_GROUP_SUCCESS,setupVideo);
			connect();
		}
		
		private function setupVideo(e:Event):void 
		{
			_video = new Video();
			switch(this._status)
			{
				case ChatUser.BROADCASTER:
				{
					if ( Camera.isSupported )
					{
						var camera:Camera = Camera.getCamera();
						camera.setMode(320, 240, 30);
						_video.attachCamera(camera);
						stream.attachCamera(camera);
					}
					if ( Microphone.isSupported )
					{
						stream.attachAudio(Microphone.getMicrophone());
					}

					stream.publish(this._key,'live');
					break;
				}
				case ChatUser.RECEIVER:
				{
					_video.attachNetStream(stream);
					stream.play(this._key);
					break;
				}
				default: 
				{
					throw new Error('wrong status parameter');
				}
			}
			this.dispatchEvent(new Event(ChatUser.VIDEO_SUCCESS,true));
		}
		
		
		private function connect():void
		{
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			netConnection.connect(SERVER+DEVKEY);
		}
		
		private function connectToGroup(e:Event):void
		{
			var groupspec:GroupSpecifier = new GroupSpecifier(this._key);
				groupspec.serverChannelEnabled = true;
				groupspec.multicastEnabled = true;
				stream = new NetStream(netConnection,groupspec.groupspecWithAuthorizations());
				stream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}

		private function netStatus(event:NetStatusEvent):void
		{			
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
				{
					dispatchEvent(new Event(ChatUser.CONNECT_SUCCESS));
					break;
				}
				case "NetStream.Connect.Success":
				{
					dispatchEvent(new Event(ChatUser.CONNECT_GROUP_SUCCESS));
					break;
				}
			}
		}
		

		//////////////////////////////////////////////////////////
		
		/* INTERFACE IChatUser */
		public function getVideoScreen():Video 
		{	
			return _video;
		}
		/*/////////////////////*/
		
		
		/**Remove Video Screen from stage*/
		/**
		 * TODO: отдебажить удаление экрана
		 */
		public function removeVideoScreen():void
		{
			try
			{
				_video.visible = false;
				_video.attachCamera(null);//ok
				stream.attachCamera(null);//good
				stream.attachAudio(null);//ok
				_video = null;
				
				stream.close();
				netConnection.close();
			}
			catch (e:Error)
			{
				trace('error in ChatUser.removeVideoScreen: ' + e.message);
			}			
				
			netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			dispatchEvent(new Event(ChatUser.VIDEO_CLOSE));
		}
		
		/**set volume level of this screen*/
		public function setVolume(vol:Number):void
		{
			stream.soundTransform = new SoundTransform(vol);
		}
		
		/**sound off*/
		public function muteSound():void
		{
			stream.attachAudio(null);
			_isSoundUnmute = false;
		}
		
		/**sound on*/
		public function unmuteSound():void
		{
			stream.attachAudio(Microphone.getMicrophone());
			_isSoundUnmute = true;
		}
		
		public function getSoundPlay():Boolean 
		{
			return _isSoundUnmute;
		}
	}
}