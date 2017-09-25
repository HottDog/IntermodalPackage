win32.exe说明：

（1）用下面命令行方式可以设定win32.exe游戏窗口的高度和宽度
win32.exe -w1024 -h768

（2）用下面命令行启动UIEditor
win32.exe -editor

（3）已知一个问题：
在windowsXP下win32.exe游戏窗口的高度超过（或接近）当前屏幕分辨率，则游戏状况的纵坐标会出现偏差；
千万不要在此种情况下调坐标；

（4）快捷键（在UIEditor下可能无效）：
按B键（border），会把每一个绘制的图片和文字显示一个边框，便于调坐标或发现一些问题；
按C键（clear），会清空控制台；
按D键（dump），会将4类对象全部输出到控制台（红色文字）
按L键（lua），会执行当前目录下debug.lua
此外，T和R键供引擎内部调试使用。

（5）win32控制台输出gb2312字符串
win32.exe print=GB2312

（6）检测图片和lua文件名大小写
win32.exe -case-sensitive