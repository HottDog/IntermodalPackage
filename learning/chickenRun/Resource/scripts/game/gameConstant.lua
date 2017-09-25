--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
game={G}
game.G=4   --重力加速度

--游戏地图
gameMap = {MAXHEIGHT,MAXWIDTH}
gameMap.MAXHEIGHT = 1000
gameMap.MAXWIDTH = 3200
--图片资源
gamePic = {chicken , map,flag}

gamePic.chicken = {CHICKEN1,CHICKEN2}
gamePic.chicken.CHICKEN1 = "1.png"
gamePic.chicken.CHICKEN2 = "2.png"


gamePic.map = {MAP0,MAP1,SKY}
gamePic.map.MAP0 = "map0.png"
gamePic.map.MAP1 = "map1.png"
gamePic.map.SKY = "sky.png"

gamePic.flag = {WIDTH,HEIGHT}
gamePic.flag.WIDTH = 60
gamePic.flag.HEIGHT = 60

--声音
gameVoice = {level}
gameVoice.level = {MAX,MIN}
gameVoice.level.MAX = 100
gameVoice.level.MIN = 0
--结果
gameResult = {WIN,GAMEOVER,CONTINUE}
gameResult.WIN =1
gameResult.GAMEOVER = 2
gameResult.CONTINUE = 3
--死亡
death = {ERROR}
death.ERROR = 30

--系统屏幕长宽
system = {WIDTH,HEIGHT}
system.WIDTH =1280
system.HEIGHT = 720
--endregion
