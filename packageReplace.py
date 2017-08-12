#coding=utf-8
import re
import constant
# android那边java代码的包名替换
IS_PACKAGE_SENTENCE = ""
MATCH_IMPORT_PACKAGE = "\s*import\s+" + constant.ANDROID_PACKAGE_NAME_RESOURCE   #原包名
MATCH_PACKAGE_PACKAGE = "\s*package\s+" + constant.ANDROID_PACKAGE_NAME_RESOURCE
def isPackageSentence(s):
    re_word = re.compile(IS_PACKAGE_SENTENCE)
    # print (re_word.match(s))
    if re_word.match(s)!=None:
        return True
    else:
        return False

def rrr(m,s="com.yjc"):
    print (m.group)
    if m.group(0)!=None:
        return s

def replaceImortPackage(str,package):
    re_word = re.compile(MATCH_IMPORT_PACKAGE)
    replaceStr = constant.IMPORT + package
    process_str = re_word.sub(replaceStr,str,0)
    # print(process_str)
    return process_str

def replacePackagePackage(str,package):
    re_word = re.compile(MATCH_PACKAGE_PACKAGE)
    replaceStr = constant.PACKAGE + package
    process_str = re_word.sub(replaceStr,str,0)
    return process_str

def replacePackage(str,package):
    str_temp = replacePackagePackage(str,package)
    return replaceImortPackage(str_temp,package)

if __name__ == '__main__':
    str = "package   com.boyaa.chinesechess.platform91.data.bean.Case;\n"
    str1 = "import com.boyaa.chinesechess.platform91.data.bean.Case;"
    package = "com.yjc"
    print(replacePackage(str+str1,package))