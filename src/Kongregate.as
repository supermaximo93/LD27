package  
{
	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Kongregate extends Sprite
	{
		private var _api:*;
		private var _onLoadCallback:Function;
		private var _onLoadErrorCallback:Function;
		
		public function get api():*
		{
			return _api;
		}
		
		public function get loaded():Boolean
		{
			return _api != null;
		}
		
		public function Kongregate() 
		{
			_api = null;
		}
		
		public function initialize(onLoadCallback:Function, onLoadErrorCallback:Function):void
		{
			_onLoadCallback = onLoadCallback;
			_onLoadErrorCallback = onLoadErrorCallback;
			var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
			var apiUrl:String = paramObj.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			var request:URLRequest = new URLRequest(apiUrl);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onApiLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onApiLoadError);
			loader.load(request);
			addChild(loader);
		}
		
		private function onApiLoaded(event:Event):void
		{
			_api = event.target.content;
		    _api.services.connect();
			if (_onLoadCallback != null)
				_onLoadCallback.call();
			_onLoadCallback = null;
			_onLoadErrorCallback = null;
		}
		
		private function onApiLoadError(error:IOError):void
		{
			if (_onLoadErrorCallback != null)
				_onLoadErrorCallback.call();
			_onLoadErrorCallback = null;
			_onLoadCallback = null;
		}
	}

}