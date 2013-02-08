package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import ru.redflasher.p2pvideo.ChatUser;
	
	/**
	 * ...
	 * @author Alex Burlakov
	 */
	public class VideoScreen extends MovieClip implements IEventDispatcher
	{
		static public const CHANGE_STATUS:String = "videoScreenChangeStatus";
		private var _index:int = 0;
		private var _name:String = '';
		private var _type:String = '';
		private var _key:String = '';
		
		private var _user:ChatUser;
		private var _showSettings:Boolean = false;
		private var _soundOn:Boolean = false;
		private var video_place:Video;
		
		
		/**
		 * this is class for MovieClip in FLA-file
		 */
		public function VideoScreen() 
		{
			trace('video screen created');
			init();
		}
		
		private function init():void 
		{

			videoPlace.visible = false;//ok
			mouseChildren = true;//ok
			down.downBoard.soundScroll.mouseEnabled = false;
			down.downBoard.soundScroll.mouseChildren = false;
			down.downBoard.soundBar.mouseEnabled = true;
			
			//FIND BTN & START BTN
			findBtn.visible = false;
			startVideoBtn.visible = false;
			
			trace('video screen initialized');
		}
		
		private function freeBtnClick(e:Event):void 
		{
			this._type = 'b';
			this.dispatchEvent(new Event(VideoScreen.CHANGE_STATUS));
		}
				
		private function changeVolume(e:MouseEvent):void 
		{
			down.downBoard.soundScroll.width = e.localX;
			var vol:Number = down.downBoard.soundScroll.width / down.downBoard.soundBar.width;
			setVolume(vol);
		}
		
		private function setVolume(vol:Number):void 
		{
			//устанавливаем новое значение громкости
			write("set volume: " + vol);
			_user.setVolume(vol);
		}
		
		private function soundOff(e:MouseEvent):void 
		{
			trace('sound btn');
			
			if (_user != null)
			{
				if (_user.getSoundPlay())
				{
					_user.muteSound();
				}
				else
				{
					_user.unmuteSound();
				}
			}
		}
		
		private function videoOff(e:MouseEvent):void 
		{
			this.type = 'f';//TODO: test
			this.dispatchEvent(new Event(VideoScreen.CHANGE_STATUS));
			
			if (_user != null)
			{
				_user.removeVideoScreen();
				_user = null;
			}
		}
		
		private function showSettings(e:MouseEvent):void 
		{
			if (!_showSettings)
			{
				removeEventListener(MouseEvent.ROLL_OVER, showVideoMenu);
				removeEventListener(MouseEvent.ROLL_OUT, hideVideoMenu);
			}
			else
			{
				addEventListener(MouseEvent.ROLL_OVER, showVideoMenu);
				addEventListener(MouseEvent.ROLL_OUT, hideVideoMenu);
			}
			_showSettings = !_showSettings;
		}
		
		private function showVideoMenu(e:MouseEvent):void 
		{
			down.gotoAndPlay(2);
		}		
		
		private function hideVideoMenu(e:MouseEvent):void 
		{
			down.gotoAndPlay(11);
		}
		
		
		private function removeListeners():void
		{
			//write('remove listeners for ' + screenNum +' screen');
			down.downBoard.soundBar.removeEventListener(MouseEvent.CLICK, changeVolume);
			removeEventListener(MouseEvent.ROLL_OVER, showVideoMenu);
			removeEventListener(MouseEvent.ROLL_OUT, hideVideoMenu);
			
			videoPlace.visible = false;
			
			down.visible = false;
		}
		
		private function installListeners(type:String='r'):void
		{
			down.downBoard.soundBar.addEventListener(MouseEvent.CLICK, changeVolume);
			
			down.downBoard.sndIcon.visible = true;
			down.downBoard.soundBar.visible = true;
			down.downBoard.soundScroll.visible = true;
			
				
			if (type == 'b')
			{
				down.downBoard.sndIcon.visible = false;
				down.downBoard.soundBar.visible = false;
				down.downBoard.soundScroll.visible = false;
			}	
			
			addEventListener(MouseEvent.ROLL_OVER, showVideoMenu);
			addEventListener(MouseEvent.ROLL_OUT, hideVideoMenu);
			
			videoPlace.visible = true;
			
			down.visible = true;
		}
		
		
		private function write(val:String):void 
		{
			trace(this.index +': ' + val);
		}
		
		public function createFreeScreen():void
		{
			
			if (_user != null)
			{
				_user.removeVideoScreen();
				_user = null;
			}			
			
			removeListeners();
		}
		
		public function createBroadcaster(b_key:String):void
		{
			if (_user != null)_user = null;
			_user = new ChatUser(b_key, ChatUser.BROADCASTER);
			
			
			_user.addEventListener(ChatUser.VIDEO_SUCCESS, 
				function()
				{
					//когда видео подключилось к сетевой группе - добавляем видео на экран
					video_place = _user.getVideoScreen();
					videoPlace.addChild ( video_place );
					videoPlace.visible = true;
				});
			_user.addEventListener(ChatUser.VIDEO_CLOSE,
				function()
				{
					videoPlace.visible = false;
					videoPlace.removeChild( video_place );
					
					if (_user != null)
					{
						_user.removeVideoScreen();
						_user = null;
					}
				});
			
			_user.init();
			
			
			installListeners('b');
		}
		public function createReceiver(r_key:String):void
		{	
			if (_user != null)_user = null;
			_user = new ChatUser(r_key, ChatUser.RECEIVER);
			
			
			_user.addEventListener(ChatUser.VIDEO_SUCCESS, 
				function()
				{
					//когда видео подключилось к сетевой группе - добавляем видео на экран
					video_place = _user.getVideoScreen();
					videoPlace.addChild ( video_place );
					videoPlace.visible = true;
				});
			_user.addEventListener(ChatUser.VIDEO_CLOSE,
				function()
				{
					videoPlace.visible = false;
					videoPlace.removeChild( video_place );
					
					if (_user != null)
					{
						_user.removeVideoScreen();
						_user = null;
					}
				});
			
			_user.init();
			
			installListeners();
		}
		
		
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get username():String 
		{
			return _name;
		}
		
		public function set username(value:String):void 
		{
			_name = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function set key(value:String):void 
		{
			_key = value;
		}
		
	}

}