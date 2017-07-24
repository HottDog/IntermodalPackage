# coding=utf-8
import func
import constant

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

a={}
a["name"] = 1
a["name"] = "bn "
print(a["name"])
a["first"] = ["hah","hahsd","sdasd"]
for s in a["first"]:
    print(s)