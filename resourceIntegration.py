# coding=utf-8
import func
import PATH
relativeFilters = ["BoyaaCustomerServiceLib\\bin",
                   "BoyaaCustomerServiceLib\\gen",
                   "PointWall_v1.0\\bin",
                   "PointWall_v1.0\\gen",
                   "xiangqi_android\\iOS",
                   "xiangqi_android\\Win32",
                   "xiangqi_android\\Resource\\dic",
                   "xiangqi_android\\Resource\\dict",
                   "xiangqi_android\\Resource\\log",
                   "xiangqi_android\\Resource\\tmp",
                   "xiangqi_android\\Resource\\update",
                   "xiangqi_android\\Resource\\user",
                   "xiangqi_android\\Android\\bin",
                   "xiangqi_android\\Android\\gen",
                   "xiangqi_android\\Android\\assets\\images",
                   "xiangqi_android\\Android\\assets\\scripts",
                   "xiangqi_android\\Resource\\audio",
                   "xiangqi_android\\Android\\src",
                   "xiangqi_android\\Resource\\scripts",
                   "xiangqi_android\\make\\batch\\lib\\tool_output",
                   "xiangqi_android\\make\\batch\\package2\\bin",
                   "xiangqi_android\\make\\batch\\package2\\gen"]
def getFilters(filters,package):
    result = []
    i = 0
    for item in filters:
        result.insert(i,PATH.GENERATE+package+"\\"+item)
        i=i+1
    return result

def isNeedCopy(path,filters):
    return not func.isInList(path,filters)

def filterCopyFile(path,resourcePath,aimPath,filters):

    tPath = func.getCopyDestination(path,resourcePath,aimPath)
    if filters ==None :
        func.copyFile(path,tPath)
        print("处理文件："+path+" 文件操作：copy覆盖")
        return False
    if isNeedCopy(tPath,filters):
        func.copyFile(path,tPath)
        print("处理文件："+path+" 文件操作：copy覆盖")
        return False
    else:
        print("处理文件："+path+" 文件操作：忽略")
        return True

if __name__ == '__main__':
    for item in getFilters(relativeFilters,"huawei"):
        print(item)