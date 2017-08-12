# coding=utf-8
import func
import PATH
import constant
groups = ["func.py","PATH.py","constant.py","create.py","fileAction.py","packageReplace.py","xmlReader.py","readLabel.py","recogniseLabel.py","resourceIntegration.py"]
if __name__ == '__main__':
    for item in groups:
        func.copyFile(PATH.current_workspace+"\\"+item,constant.ORIGIN_SCRIPTS+"\\"+item)