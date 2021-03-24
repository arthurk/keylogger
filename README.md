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

## Statistics

To find out which keys have been pressed the most we can do the following:

Redirect the data to a file:

```
sudo ./keylogger >> testrun-2.csv 
```

and then open it in [visidata](https://www.visidata.org/) for stats (press shift+f):

![visidata](/visidata.png?raw=true)

## Installation

Compile with:

```
clang -o keylogger keylogger.m -framework Cocoa -framework Carbon
```

Then launch with:

```
sudo ./keylogger
```

Code is taken from [sniffMK](https://github.com/objective-see/sniffMK/blob/master/sniffMK/sniffMK.m) and [NESEmulator](https://github.com/fredyshox/NESEmulator/blob/de0c574091a9c1f7e7713ea22f30dd0dd49b8dfb/Client/Cocoa/Sources/KeyCodeFormatter.m).
