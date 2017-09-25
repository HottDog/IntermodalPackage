package com.boyaa.chinesechess.chicken;

import com.boyaa.entity.core.HandMachine;
import com.boyaa.made.AppActivity;

import android.app.Service;
import android.content.Intent;
import android.media.AudioRecord;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;

public class VoiceService extends Service{
	
	private int voiceValue=0;
	private Handler handler=new Handler() {  
		@Override
        // 处理子线程给我们发送的消息。  
        public void handleMessage(Message msg) {  
			voiceValue =msg.what;
			Game.mActivity.runOnLuaThread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub 
					AppActivity.dict_set_int("voice", "voiceValue", voiceValue);
					AppActivity.call_lua("getVoiceValue");}
			});
        };  
    }; 
    private RecordThread thread;
	@Override
	public IBinder onBind(Intent intent) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override  
    public void onCreate() {  
        super.onCreate();  
        thread =new RecordThread();
        thread.setHandler(handler);
        thread.start();
    }  
  
    @Override  
    public int onStartCommand(Intent intent, int flags, int startId) {  
        
        return super.onStartCommand(intent, flags, startId);  
    }  
      
    @Override  
    public void onDestroy() {  
        super.onDestroy(); 
        if (thread!=null){
        	thread.pause();
        }
    }  
    
    private void getVoiceValue(){
    	
    }

}
