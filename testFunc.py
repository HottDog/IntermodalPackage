# coding=utf-8
import func
import constant
import os
import sys
# f= func.getFileWriteObj(constant.TEST_PATH_HOME+"1.txt")
# func.writeFileInTheEndByLine(f,"hello world!")
# func.writeFileInTheEndByLine(f,"i love you")
# content = ["ji","das","dssd"]     #[]这样的才是列表
# func.writeFileInTheEndByLines(f,content)
# print(content[0])
# func.writeFileInTheEndByLine(f,None)
# func.writeFileInTheEndByLine(f,"hah")

# f =func.getFileReadObj(constant.TEST_PATH_HOME+"1.txt")
# m1 = func.readLineWithoutLineBreak(f)
# m2 = func.readLineWithoutLineBreak(f)
# print(f.readline())
# print(f.readline())
#
# f1= func.getFileWriteObj(constant.TEST_PATH_HOME+"2.txt")
# func.writeFileInTheEndByLine(f1,m1)
# func.writeFileInTheEndByLine(f1,m2)

# a["name"] = 1
# a["name"] = "bn "
# print(a["name"])
# a["first"] = ["hah","hahsd","sdasd"]
# for s in a["first"]:
#     print(s)
# a={"in":1,"sda":2}
# if not 'sss' in a.keys():
#     print("孔")
# func.copyFile(constant.TEST_RESOURCE_PATH+"aa",constant.TEST_COMBINED_PATH+"aa")
# func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,"E:\\test_workspace\\IntermodalPackage\\resource\\script")
path = "E:\\test_workspace\\IntermodalPackage\\resource\\script\\error.lua"
name= os.path.basename("E:\\test_workspace\\IntermodalPackage\\resource\\script\\error.lua")
etc = os.path.splitext("E:\\test_workspace\\IntermodalPackage\\resource\\script\\error.lua")
# print(func.getFileSuffixName(path))
# print(name)
# print(etc[1])
print(os.path.dirname(path))
# top_path = func.getThePreviousLevelPath(path)
# print(top_path)
top_path = "E:\\test_workspace\\IntermodalPackage\\resource"
tt_path = sys.path.append(os.path.abspath(os.path.dirname(top_path) + '/' + '../../'))
print(tt_path)
if func.isLuaFile(path) :
    print ("是lua文件")