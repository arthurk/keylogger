A keylogger for macOS.

I wrote this keylogger to analyze which keys are pressed the most. Below you'll find instructions on how to run the code and analyze the data.

**Note**: This keylogger will capture all keyboard input, including passwords and other sensitive information. Make sure to stop the keylogger before entering such data.

## Data Format

Keys are logged in CSV format to stdout. The first column is the key pressed. The second column is the modifier that was held while pressing the key:

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

For example `c,control` means that Ctrl+C was pressed. If no modified was pressed, the second column is empty (`a,`).

## Histogram in Visidata

To find out which keys have been pressed the most we can load the generated CSV file into [visidata](https://www.visidata.org/).

```
visidata keylog.csv
```

Then press `Shift+F` to get the histogram:

![visidata](/visidata.png?raw=true)

## Keyboard Layout Analyzer

The repo comes with a Python script that can parse the generated csv file and format the output for the [keyboard layout analyzer](https://stevep99.github.io/keyboard-layout-analyzer/). KLA will give you recommendations about the best keyboard layout based on how much finger moved and other factors. It can also generate a heatmap:

![heatmap](/kla-heatmap.png?raw=true)

Run the Python script and copy the output to your clipboard:

```
python3 kla_text_input.py keylog.csv | pbcopy
```

Then go to [keyboard layout analyzer](https://stevep99.github.io/keyboard-layout-analyzer/) and paste the text into the textbox and click "See which layout is the best".

The keyboard analyzer runs in client-side javascript, however to be sure that no senvitive information is leaked I recommend to disable your internet connection before submitting the text, or run it locally. Instructions can be found in [the github repo](https://github.com/patorjk/keyboard-layout-analyzer#how-to-install).

Note that the keyboard layout analyzer doesn't support virtual keys such as Shift/Cmd/Ctrl/Delete/Arrow-keys so they are excluded from the statistics.

## Installation

Since this is a keylogger it doesn't come with a pre-compiled binary.

You can compile it with:

```
clang -o keylogger keylogger.m -framework Cocoa -framework Carbon
```

Next we need to allow the keylogger to capture keyboard input. To do this we have to open `System Preferences -> Security and Privacy -> Accessibility` and add the `keylogger` binary to the list. Also make sure that your terminal app is in that list and allowed to capture input:

![capture-keyboard](/prefs-capture-keyboard.png?raw=true)

## Usage

To print the logged keys to stdout run:

```
./keylogger
```

If you see an error `ERROR: failed to create event tap` then you need to allow your computer to capture keyboard input (see `Installation` above).

If you want to output the contents to a file:

```
echo "key,mod" > keylog.csv
./keylogger >> keylog.csv
```

Code is taken from [sniffMK](https://github.com/objective-see/sniffMK/blob/master/sniffMK/sniffMK.m) and [NESEmulator](https://github.com/fredyshox/NESEmulator/blob/de0c574091a9c1f7e7713ea22f30dd0dd49b8dfb/Client/Cocoa/Sources/KeyCodeFormatter.m).
