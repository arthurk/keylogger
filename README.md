A keylogger for macOS.

Keys are logged in CSV format to stdout. The first column is the key and the second column is the modifier that was pressed:

```
UP_ARROW,
DOWN_ARROW,
a,
t,
ESC,
s,control shift 
s,alt 
ESC,
[,control shift 
c,control
```

For example `c,control` means that Ctrl+C was pressed.

To save the output you can redirect it to a file:

```
sudo ./keylogger >> keylog.csv 
```

## Histogram in Visidata

To find out which keys have been pressed the most we can load the generated CSV file into [visidata](https://www.visidata.org/).

```
visidata keylog.csv
```

Then press `Shift+F` to get the histogram:

![visidata](/visidata.png?raw=true)

## Keyboard Layout Analyzer

The repo comes with a Python script that can parse the csv file and generate output for the [keyboard layout analyzer](https://patorjk.com/keyboard-layout-analyzer/). This will give you recommendations about the best keyboard layout, finger usage and generate a heatmap:

![heatmap](/kla-heatmap.png?raw=true)

Run the Python script and copy the output to your clipboard:

```
python3 kla_text_input.py keylog.csv | pbcopy
```

Then go to [keyboard layout analyzer](https://patorjk.com/keyboard-layout-analyzer/) and paste the text into the textbox and click "See which layout is the best".

Note that the keyboard layout analyzer doesn't support virtual keys such as Shift/Cmd/Ctrl/Delete/Arrow-keys so they are excluded from the statistics.

## Installation

Since this is a keylogger it doesn't come with a pre-compiled binary.

You can compile it with:

```
clang -o keylogger keylogger.m -framework Cocoa -framework Carbon
```

Then launch with:

```
sudo ./keylogger

# or

echo "key,mod" > testrun-3.csv
sudo ./keylogger >> keylog.csv
```

Code is taken from [sniffMK](https://github.com/objective-see/sniffMK/blob/master/sniffMK/sniffMK.m) and [NESEmulator](https://github.com/fredyshox/NESEmulator/blob/de0c574091a9c1f7e7713ea22f30dd0dd49b8dfb/Client/Cocoa/Sources/KeyCodeFormatter.m).
