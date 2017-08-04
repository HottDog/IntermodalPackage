# coding=utf-8
import xmlReader
import readLabel
import func
import constant
import recogniseLabel
import os
import shutil
import PATH
def excuteAction(w,s,isKey,action,name,dict):
    if action == constant.NORMAL_WRITE:
        if not isKey:
            func.writeFileInTheEndByLine(w,s)
    elif action == constant.UPDATE_WRITE:
        if action != constant.UPDATE_WRITE_END:
            if not isKey:
                func.writeFileInTheEndByLines(w,dict["update"][name])
                return constant.UPDATE_WRITE_END
    elif action == constant.INSERT_WRITE:
        func.writeFileInTheEndByLines(w,dict["insert"][name])
        return constant.NORMAL_WRITE
    return None

def modifyFile(rPath,wPath,fileName,package):
    f=func.getFileReadObj(rPath)
    w=func.getFileWriteObj(wPath)
    action = constant.NORMAL_WRITE
    packageName = package["name"]
    dealContent = package[xmlReader.SCRIPT][fileName]
    print(dealContent)
    s=func.readLineWithoutLineBreak(f)
    name = ""
    while(s):
        isKeySentence = False
        groupTemp = readLabel.getParseLabelResult(s)
        print(groupTemp)
        if groupTemp!= None:
            actiomTmp,nameTmp = recogniseLabel.getFileProcessAction(groupTemp,packageName)
            if actiomTmp != None:
                action = actiomTmp
                name = nameTmp
            isKeySentence=True
        actiomDealTmp = excuteAction(w,s,isKeySentence,action,name,dealContent)
        if actiomDealTmp!=None:
            action =actiomDealTmp
        s = func.readLineWithoutLineBreak(f)
    f.close()
    w.close()

def directCopyFile(path,aimPath):
    tPath = func.getCopyDestination(PATH.RESOURCE_SCRIPTS,aimPath,path)
    func.copyFile(path,tPath)

def isFileNeedModify(path,package):
    fileName = func.getFileNameFromPath(path)
    if func.isInDict(fileName,package[xmlReader.SCRIPT]):
        # processFile(path,func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,path))
        return True
    else:
        return False

def processFile(path,package,aimPath):
    if isFileNeedModify(path,package):
        modifyFile(path,func.getCopyDestination(PATH.RESOURCE_SCRIPTS,aimPath,path),func.getFileNameFromPath(path),package)
    else:
        directCopyFile(path,aimPath)

def traverse(package,aimPath):
    #如果是单个文件，则直接处理
    if not os.path.isdir(PATH.RESOURCE_SCRIPTS):
        processFile(PATH.RESOURCE_SCRIPTS,package,aimPath)
        return
    else:
        directCopyFile(PATH.RESOURCE_SCRIPTS,aimPath)
    #如果是文件夹则遍历处理
    files =os.listdir(PATH.RESOURCE_SCRIPTS)
    for file in files:
        if not os.path.isdir(PATH.RESOURCE_SCRIPTS+"\\"+file):
            #不是文件夹
            processFile(PATH.RESOURCE_SCRIPTS+"\\"+file,package,aimPath)
        else:
            # print('文件夹:'+path+"\\"+file)
            directCopyFile(PATH.RESOURCE_SCRIPTS+"\\"+file,aimPath)
            traverse(PATH.RESOURCE_SCRIPTS+"\\"+file,package)

if __name__ == '__main__':
    package = xmlReader.parseXML(PATH.XML_CONFIG + "baidu.xml")
    aim_path = PATH.GENERATE + package["name"] + PATH.SCRIPTS
    func.createFile(aim_path)
    traverse(package,aim_path)
    # processFile(constant.TEST_RESOURCE_PATH+"test.txt",constant.TEST_COMBINED_PATH+"test.txt","test.txt",package)