# coding=utf-8
import xmlReader
import readLabel
import func
import constant
import recogniseLabel
import os
import shutil
import PATH
import fileAction

def directCopyFile(path,resourcePath,aimPath):
    tPath = func.getCopyDestination(path,resourcePath,aimPath)
    func.copyFile(path,tPath)

def isFileNeedModify(path,dict):
    fileName = func.getFileNameFromPath(path)
    # if func.isInDict(fileName,package[xmlReader.SCRIPT]):
    if func.isInDict(fileName,dict):
        # processFile(path,func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,path))
        return True
    else:
        return False

# 处理文件
# dict script或者android的整个dict内容，eg.package[xmlReader.SCRIPT]
def processFile(path,resourcePath,aimPath,packageName,dict):
    if isFileNeedModify(path,dict):
        print("file:"+path+"   action:modify")
        fileAction.modifyFile(path,func.getCopyDestination(path,resourcePath,aimPath),packageName,dict[func.getFileNameFromPath(path)])
    else:
        print("file:"+path+"   action:copy")
        directCopyFile(path,resourcePath,aimPath)

# 处理其他资源的文件夹
# return 是否退出对该文件夹的遍历操作，如果是true，则表示不对该文件夹进行遍历，如果是false，则表示对该文件夹继续遍历
def processOtherResourceFiles():
    return False

# 处理lua和java代码内容文件夹
def processContentFiles(path,resourcePath,aimPath):
    directCopyFile(path,resourcePath,aimPath)
    return False

# 处理包名和文件夹名替换操作
def processAndroidOtherFile(path,androidPackageName):
    fileAction.modifyAndroidFile(path,androidPackageName)

# 遍历文件夹操作
# args说明
# processFiles 对文件夹的处理，返回结果如果是true，则表示不对该文件夹进行遍历，如果是false，则表示对该文件夹继续遍历
# dict script或者android的整个dict内容，eg.package[xmlReader.SCRIPT]
def traverse(processFile,processFiles,path,resourcePath,aimPath,packageName,dict):
    #如果是单个文件，则直接处理
    if not os.path.isdir(path):
        processFile(path,resourcePath,aimPath,packageName,dict)
        return
    if processFiles(path,resourcePath,aimPath):   #是否继续遍历该文件夹
        return
    #如果是文件夹则遍历处理
    files =os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            #不是文件夹
            processFile(path+"\\"+file,resourcePath,aimPath,packageName,dict)
        else:
            # print('文件夹:'+path+"\\"+file)
            # directCopyFile(path+"\\"+file,aimPath)
            traverse(processFile,processFiles,path+"\\"+file,resourcePath,aimPath,packageName,dict)

if __name__ == '__main__':
    package = xmlReader.parseXML(PATH.XML_CONFIG + "huawei.xml")
    # 处理lua脚本内容
    aim_path = PATH.GENERATE + package[constant.NAME] + PATH.SCRIPTS
    print(aim_path)
    func.createFile(aim_path)    #创建scripts文件夹
    traverse(processFile,processContentFiles,PATH.RESOURCE_SCRIPTS,PATH.RESOURCE_SCRIPTS,aim_path,package[constant.NAME],package[xmlReader.SCRIPT])

    # 处理android中java代码部分的内容
    aim_path_android = PATH.GENERATE + package[constant.NAME] + PATH.SRC
    print(aim_path_android)
    func.createFile(aim_path_android)      #创建res文件夹
    traverse(processFile,processContentFiles,PATH.RESOURCE_ANDROID_RES,PATH.RESOURCE_ANDROID_RES,aim_path_android,package[constant.NAME],package[xmlReader.ANDROID])
    # processFile(constant.TEST_RESOURCE_PATH+"test.txt",constant.TEST_COMBINED_PATH+"test.txt","test.txt",package)

    # 处理包名替换或者文件夹名替换等操作
