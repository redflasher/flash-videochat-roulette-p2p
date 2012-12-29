package  {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class Main2 extends Sprite {
		private var tf:TextField;
		private var videoScreen:Video;
		private var _showSettings:Boolean = false;
		private var _videoOn:Boolean = true;
		private var _soundOn:Boolean = true;
		private var _chatStarted:Boolean = false;
		
		public var videoScr1:VideoScreen;
		public var videoScr2:VideoScreen;
		
		//arrays for screns
		var _types:Array = [];
		var _names:Array = [];
		var _keys:Array = [];
		var _screens:Vector.<VideoScreen> = new Vector.<VideoScreen>;
		var _users:Array = [];
		
		//net
		private var findCompanionUrlRequest:URLRequest;
		private var findCompanionUrlLoader:URLLoader;
		private var updateUserStatusUrlRequest:URLRequest;
		private var updateUserStatusUrlLoader:URLLoader;
		

		const SERVER_PATH:String = 'server.php';
		
		public function Main2() {
			init();
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			tf = new TextField();
			tf.width = 280;
			tf.height = 300;
			tf.multiline = true;
			tf.textColor = 0xffffff;
			addChild(tf);
			setChildIndex(tf, 0);
			
			startBtn.addEventListener(MouseEvent.CLICK, startChat);
			
			
			findCompanionUrlRequest = new URLRequest(SERVER_PATH+'?find_companion');
			findCompanionUrlLoader = new URLLoader();
			updateUserStatusUrlRequest = new URLRequest(SERVER_PATH + '?update_user_status');
			updateUserStatusUrlLoader = new URLLoader();
			//add listeners
			findCompanionUrlLoader.addEventListener(Event.COMPLETE, companionFinded);
			findCompanionUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			updateUserStatusUrlLoader.addEventListener(Event.COMPLETE, userStatusUpdated);
			updateUserStatusUrlLoader.addEventListener(IOErrorEvent.IO_ERROR, userUpdateIOError);
		}
		
		private function startChat(e:MouseEvent):void 
		{
			startBtn.visible = false;
			
			videoScr1.startVideoBtn.visible = true;
			
			videoScr1.addEventListener(MouseEvent.CLICK, function()
			{	
				videoScr1.startVideoBtn.visible = false;
				
				var urlRequest:URLRequest = new URLRequest(SERVER_PATH+'?start');
				var urlLoader:URLLoader = new URLLoader();
				
				urlLoader.addEventListener(Event.COMPLETE, chatStartedComplete);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				urlLoader.load(urlRequest);
			});
		}
		
		//получили ключ для вещания в пиринговой сети
		private function chatStartedComplete(e:Event):void 
		{
			_chatStarted = true;//?
			trace("b_key: ", e.target.data);
			videoScr1.createBroadcaster(e.target.data);
			
			videoScr2.findBtn.visible = true;
			videoScr2.findBtn.addEventListener(MouseEvent.CLICK,
			function()
			{
				videoScr2.findBtn.visible = false;
				pingServer();//start find companion
			});
		}
		
		//посылаем запрос на сервер, когда перешли во 2-й режим работы - режим поиска
		private function pingServer():void 
		{
			trace('ping server');
			findCompanionUrlLoader.load(findCompanionUrlRequest);
		}
		
		//здесь получаем только ключ собеседника, в виде одной строки
		private function companionFinded(e:Event):void 
		{
			var data:Object = String(e.target.data);
			trace('you companion key: ' + data);
			updateUserStatus();
		}
		
		private function updateUserStatus():void
		{
			//trace("updateUserStatus");
			updateUserStatusUrlLoader.load(updateUserStatusUrlRequest);
			setTimeout(updateUserStatus, 1000);
		}
		
		//здесь получаем только статус юзера, в виде одной строки
		private function userStatusUpdated(e:Event):void 
		{
			trace("user status now: " + e.target.data);
			/**
			 * TODO: включать здесь собеседника
			 */
			videoScr2.createReceiver(e.target.data);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace("ioError: " +e.text);
			pingServer();
		}
		
		private function userUpdateIOError(e:IOErrorEvent):void 
		{
			trace('UserUpdateIOError',e.text);
			updateUserStatus();
		}
		
		////////////////////////////////////////////////
		private function write(val:String):void 
		{
			tf.text += '2 room: ' +  val + '\n';
			tf.scrollV = tf.maxScrollV;
		}
		
	}
	
}
