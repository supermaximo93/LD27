package  
{
	import com.newgrounds.*;
	import com.newgrounds.components.*;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Max Foster
	 */
	public class Preloader extends MovieClip 
	{
		public function Preloader() 
        {
			CONFIG::release
			{
				API.debugMode = API.RELEASE_MODE;
			}
			
            var apiConnector:APIConnector = new APIConnector();
            apiConnector.className = "Main";
            apiConnector.apiId = Keys.API_ID;
            apiConnector.encryptionKey = Keys.ENCRYPTION_KEY;
            addChild(apiConnector);
			
            if (stage)
            {
                apiConnector.x = (stage.stageWidth - apiConnector.width) / 2;
                apiConnector.y = (stage.stageHeight - apiConnector.height) / 2;
            }
        }
	}

}