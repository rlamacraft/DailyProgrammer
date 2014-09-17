#converts user input
#into html file
import os
from os.path import expanduser

beforePara = ["<!DOCTYPE html>\n","<html>\n","   <head>\n","      <title></title>\n",
              "   </head>\n","\n","   <body>\n","      <p>"]
afterPara = ["</p>\n","   </body>\n","</html>"]

#para input
print("Enter your paragraph:")
para = input()

#create/open file
home = expanduser("~")
try:
    with open(home + "dp_html.html","w") as file:

        #edit file
        file.writelines(beforePara)
        file.write(para)
        file.writelines(afterPara)

    file.close()
except IOError:
    pass
