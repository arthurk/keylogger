"""
Reads the generated csv file from the keylogger
and outputs text input that can be entered into 
https://patorjk.com/keyboard-layout-analyzer/

Since the KLA cannot process virtual keys such as Shift, Command
or Alt these are omitted from the output.
"""

import csv
import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('filename', type=str)
args = parser.parse_args()

with open(args.filename) as csvfile:
    r = csv.reader(csvfile)
    word = ""
    for key, row in r:
        if len(key) == 1:
            word += key
        elif key == "SPACE":
            word += " "
        # word is longer than 1 char; SPACE, LEFT_ARROW, etc.
        else:
            # print with newline
            if key == "ENTER":
                print(word)
            # print without newline
            else:
                print(word, end="")
            word = ""
