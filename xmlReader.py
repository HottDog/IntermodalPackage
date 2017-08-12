#coding=utf-8
from xml.dom.minidom import parse
import string
import xml.dom.minidom
import func
import constant
SCRIPT = "script"
ANDROID = "android"
UPDATE = "update"
INSERT = "insert"
CONTENT = "content"
NAME = "name"
def parse_xml(file_path):
    """
    Handle xml file with invalid character
    [input] : path of the xml file
    [output] : xml.dom.minidom.Document instance
    """
    try:
        xmldoc = xml.dom.minidom.parse(file_path)
    except:
        f = func.getFileReadObj(file_path)
        s = f.read()
        f.close()

        ss = s.translate(string.printable)
        s = s.translate(ss)

        xmldoc = xml.dom.minidom.parseString(s)
    return xmldoc

def parseKeyNodeList(nodelist,dict):
    for node in nodelist:
        contentList = []
        name = node.getAttribute("name")
        contents = node.getElementsByTagName("content")
        for content in contents:
            contentList.append(content.childNodes[0].data)
        dict[name] = contentList

def parseNodeList(nodelist,dict):
    for node in nodelist:
        update = {}
        insert = {}
        name = node.getAttribute("name")
        dict[name] = {"update":update,"insert":insert}
        insertNodelist = node.getElementsByTagName("insert")
        parseKeyNodeList(insertNodelist,dict[name]["insert"])
        updateNodelist = node.getElementsByTagName("update")
        parseKeyNodeList(updateNodelist,dict[name]["update"])

# return package
# package的数据结构是
# package = {"name":"","packageName":"","script":{"name1":{"update":{"name1":["content1","content2",...],name2:[],...},"insert":{}},"name2":{},...},"android":{}}
def parseXML(file):
    script = {}
    android = {}
    package = {"name":"","packageName":"","script":script,"android":android}
    DOMTree = xml.dom.minidom.parse(file)
    # DOMTree = parse_xml(file)
    packageNode = DOMTree.documentElement
    package["name"] = packageNode.getAttribute("name")
    package["packageName"] = packageNode.getAttribute("packageName")
    androidNodeList = packageNode.getElementsByTagName("android")
    parseNodeList(androidNodeList,package["android"])
    scriptNodeList = packageNode.getElementsByTagName("script")
    parseNodeList(scriptNodeList,package["script"])
    return package

# DOMTree = xml.dom.minidom.parse("new.xml")
# package = DOMTree.documentElement
# print(package.nodeName)
# if package.hasAttribute("name"):
#     print("root element:" + package.getAttribute("desc"))
# file = package.getElementsByTagName("file")
# # if file.hasAttribute("name"):
# print(file)
# print("file name:"+file[0].getAttribute("name"))
# insert = file[0].getElementsByTagName("insert")
# contents = insert[0].getElementsByTagName("content")
# i=0
# for content in contents:
#     # print(content.childNodes[0].data)
#     print("content%d"%(i)+" : "+content.childNodes[0].data)
#     i=i+1
# package = parseXML("new.xml")
# print(package["name"])
# print(package["script"]["1ww.txt"]["insert"]["first"])
# try :
#     if package["script"]["1ww.txt"]:
#         print("有")
# except:
#     print("没有")
if __name__ == '__main__':
    print(parseXML("uc.xml"))