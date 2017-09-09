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
import resourceIntegration

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
        if func.isLuaFile(path) or func.isJavaFile(path):
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

# 给文件夹换名字
# path 当前处理的文件夹路径
# lastPath 上一级文件夹的路径
def processAndroidOtherFiles(path,resourcePath,parentPaths,currentPaths):
    tempPath = func.getRelaPath(path,resourcePath)
    i =0
    length_parent = len(parentPaths)
    length_current = len(currentPaths)
    for item in parentPaths:
        if tempPath == item :
            newPath = resourcePath+"\\"+currentPaths[i]
            # 添加对于联运包包名的字段数多于父仓库包名时的特殊处理
            if i == (length_parent-1) and length_current>length_parent:
                n = i+1
                for m in range(length_current-length_parent):
                    newPath = resourcePath + "\\" + currentPaths[n]
                    n=n+1
                func.replaceByPath(path,newPath)
            else:
                os.rename(path,newPath)
            print("包名替换："+newPath)
            return newPath
        i=i+1
    return None
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

# 遍历处理android包名替换和文件夹重命名
def traverseAndroidOtherFile(path,resourcePath,androidPackageName,parentPaths,currentPaths):
    if not os.path.isdir(path):
        processAndroidOtherFile(path,androidPackageName)
        return
    newPath = processAndroidOtherFiles(path,resourcePath,parentPaths,currentPaths)
    if newPath!=None :
        path = newPath
    files = os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            processAndroidOtherFile(path+"\\"+file,androidPackageName)
        else:
            traverseAndroidOtherFile(path+"\\"+file,resourcePath,androidPackageName,parentPaths,currentPaths)

# 遍历文件进行资源整合
def traverseResourceIntegration(filterCopyFile,path,resourcePath,aimPath,filters):
    if not os.path.isdir(path):
        filterCopyFile(path,resourcePath,aimPath,filters)
        return
    if filterCopyFile(path,resourcePath,aimPath,filters):
        return
    files = os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            filterCopyFile(path+"\\"+file,resourcePath,aimPath,filters)
        else:
            traverseResourceIntegration(filterCopyFile,path+"\\"+file,resourcePath,aimPath,filters)

if __name__ == '__main__':
    package = xmlReader.parseXML(PATH.XML_CONFIG + "oppo.xml")
    # 处理lua脚本内容
    isDealWithLua = True
    isDealWithAndroid = True
    isDealWithPackage = True
    isDealWithResource = False
    if isDealWithLua:
        aim_path = PATH.GENERATE + package[constant.NAME] + PATH.RESOURCE + PATH.SCRIPTS
        print(aim_path)
        func.createFile(aim_path)    #创建scripts文件夹
        traverse(processFile,processContentFiles,PATH.RESOURCE_SCRIPTS,PATH.RESOURCE_SCRIPTS,aim_path,package[constant.NAME],package[xmlReader.SCRIPT])

    # 处理android中java代码部分的内容

    if isDealWithAndroid:
        aim_path_android = PATH.GENERATE + package[constant.NAME] + PATH.SRC
        print(aim_path_android)
        func.createFile(aim_path_android)      #创建res文件夹
        traverse(processFile,processContentFiles,PATH.RESOURCE_ANDROID_RES,PATH.RESOURCE_ANDROID_RES,aim_path_android,package[constant.NAME],package[xmlReader.ANDROID])
    # processFile(constant.TEST_RESOURCE_PATH+"test.txt",constant.TEST_COMBINED_PATH+"test.txt","test.txt",package)

    # 处理包名替换或者文件夹名替换等操作

    if isDealWithPackage :
        parent_rela_paths = readLabel.getChangedRelaPath(constant.ANDROID_PACKAGE_NAME_RESOURCE,package[constant.PACKAGE_NAME])
        current_rela_paths = readLabel.getRelaPathFromAndroidPackageName(package[constant.PACKAGE_NAME])
        traverseAndroidOtherFile(aim_path_android,aim_path_android,package[constant.PACKAGE_NAME],parent_rela_paths,current_rela_paths)

    # 资源整合
    # 获取所有过滤路径

    if isDealWithResource:
        filters = resourceIntegration.getFilters(resourceIntegration.relativeFilters,package[constant.NAME])
        aim_path_resource = PATH.GENERATE + package[constant.NAME]
        print("整合父类资源..")
        traverseResourceIntegration(resourceIntegration.filterCopyFile,PATH.RELEASE,PATH.RELEASE,aim_path_resource,filters)
        resource_path = PATH.current_workspace_top+"\\resource\\" + package[constant.NAME]
        print("整合联运包特有资源..")
        traverseResourceIntegration(resourceIntegration.filterCopyFile,resource_path,resource_path,aim_path_resource,None)
