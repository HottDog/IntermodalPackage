-- Data:2013-9-4
-- Description:程序入口 
-- Note:
require("core/system");
function event_load(width,height)

--    socket_close("hall",-1);
--	socket_close("room",-1);
    socket_close_all();
	res_delete_group(-1);
	anim_delete_group(-1);
	prop_delete_group(-1);
	drawing_delete_all();
    System.setLayoutWidth(720);
    System.setLayoutHeight(1280);

	Sound.pauseMusic();
	local str = System.getLuaError();
    sys_set_int("win32_console_color",0xff0000);
	print_string(" error str = "..str);
end 


function event_touch_raw ( finger_action, x, y, drawing_id)	  
 
end

function event_anim ( anim_type, anim_id, repeat_or_loop_num )
end

function event_pause()
end

function event_resume()
end

function event_backpressed()    
end

function dtor()
end