# coding=utf8
# the above tag defines encoding for this document and is for Python 2.x compatibility

import re
import sys
regex = ur"(([A-Fa-f0-9]{2}:){5}[A-Fa-f0-9]{2})"

test_file = open("earlyfile-winalliedmacs-20220125T114146-windows01.log")

test_string = test_file.read()

test_file.close()

matches = re.search(regex, test_string)

if matches:
    print matches.group(0)
    sys.exit(0)
print ("There were no matches")
