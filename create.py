# coding=utf-8
import xmlReader
import readLabel
import func
import constant
import recogniseLabel
import os
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

def directCopyFile(path):
    tPath = func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,path)
    func.copyFile(path,tPath)

def isFileNeedModify(path,package):
    fileName = func.getFileNameFromPath(path)
    if func.isInDict(fileName,package[xmlReader.SCRIPT]):
        # processFile(path,func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,path))
        return True
    else:
        return False

def processFile(path,package):
    if isFileNeedModify(path,package):
        modifyFile(path,func.getCopyDestination(constant.SCRIPT_RESOURCE_PATH,constant.SCRIPT_COMBINED_PATH,path),func.getFileNameFromPath(path),package)
    else:
        directCopyFile(path)

def traverse(path,package):
    #如果是单个文件，则直接处理
    if not os.path.isdir(path):
        processFile(path,package)
        return
    else:
        directCopyFile(path)
    #如果是文件夹则遍历处理
    files =os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            #不是文件夹
            processFile(path+"\\"+file,package)
        else:
            # print('文件夹:'+path+"\\"+file)
            directCopyFile(path+"\\"+file)
            traverse(path+"\\"+file,package)

if __name__ == '__main__':
    package = xmlReader.parseXML("uc.xml")
    traverse(constant.SCRIPT_RESOURCE_PATH,package)
    # processFile(constant.TEST_RESOURCE_PATH+"test.txt",constant.TEST_COMBINED_PATH+"test.txt","test.txt",package)