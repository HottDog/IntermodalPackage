-- �Ƿ�Ϊ���Ի���
kDebug = false;
kPlatform = System.getPlatform();
require("core/constants");
require("config/php_config");
require("config/chess_config");
require("config/php_config");
require("config/game_config");
require("config/path_config");
require("config/native_config");
require("config/anim_config");
require("config/server_config");
require(ACTIVITY_PATH .. "activityManager");
-- ResConfig is a global val to config res path and format for multi-platform.  
ResConfig = {} 
ResConfig.Path = nil 
ResConfig.Filter = kFilterLinear;
ResConfig.FormatFileMap = {} 
ResConfig.FormatFolderMap = {} 
-- LanguageConfig is a global val to config language for multi-platform.  
LanguageConfig = {}
LanguageConfig.isZhHant = false; 


-- �����
kActivityDebug = ((kDebug and 1) or 0);--����1������Է�������0������ʽ����������������ֵû���õ�Ŷ
ActivityManager.setMode(kActivityDebug == 1)
------------�ͻ��˰汾��--------------

kLuaVersion = "2.5.0";
kLuaVersionCode = 250;

VERSIONS = kLuaVersion;
VERSIONS_CODE = kLuaVersionCode;

------------�������汾��--------------
kServerVersion = 2;

kWin32Vesion = "2.5.0";
PhpConfig.developUrl = PhpConfig.developMainUrl;--��ʽ����

require("channelConfig");