#%%
import os
import sys
import fileinput
import re

fileToSearch = 'inputfile.txt'
print('\n START...')


# trailing white signs
textToSearch = r'[\t\s]+\n'
textToReplace = r'\n'
tempFile = open(fileToSearch, 'r+', encoding='utf-8')
for line in fileinput.input(fileToSearch):
    tempFile.write(re.sub(textToSearch, textToReplace, line))
tempFile.close()

# # double commas near each other
# textToSearch = r',+([\t\s]*),+'
# textToReplace = r',\1'
# tempFile = open(fileToSearch, 'r+', encoding='utf-8')
# with open(fileToSearch, "r", encoding='utf-8') as myfile:
#     mydata = myfile.read()
#     tempFile.write(re.sub(textToSearch, textToReplace, mydata))
# tempFile.close()


# double commas in next lines
textToSearch = r',(\n*)([\t\s]*),'
textToReplace = r'\1\2,'
tempFile = open(fileToSearch, 'r+', encoding='utf-8')
with open(fileToSearch, "r", encoding='utf-8') as myfile:
    mydata = myfile.read()
    tempFile.write(re.sub(textToSearch, textToReplace, mydata))
tempFile.close()


print('\n ..END')
