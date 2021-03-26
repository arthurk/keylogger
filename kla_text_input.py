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

shift_map = {
    "/": "?",
    ".": ">",
    ",": "<",
    "[": "{",
    "]": "}",
    "\\": "|",
    "`": "~",
    "1": "!",
    "2": "@",
    "3": "#",
    "4": "$",
    "5": "%",
    "6": "^",
    "7": "&",
    "8": "*",
    "9": "(",
    "0": ")",
    "-": "_",
    "=": "+",
    ";": ":",
    "'": "\"",
}

# translates a key to it's value when shift mod is pressed
def get_shift_value(key):
    try:
        return shift_map[key]
    except KeyError:
        return key.upper()

with open(args.filename) as csvfile:
    r = csv.reader(csvfile)
    word = ""
    for key, mod in r:
        if len(key) == 1:
            if mod == "shift ":
                key = get_shift_value(key)
            word += key
        elif key == "SPACE":
            word += " "
        else:
            if key == "ENTER":
                print(word)
            else:
                # print without newline
                print(word, end="")
            word = ""
