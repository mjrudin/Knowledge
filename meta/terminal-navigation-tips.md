# Terminal Navigation Tips

Note: you'll be surprised at how these work in many other apps (like hipchat, textmate, or chrome).

## Preliminaries

All of these shortcuts involve holding down either `control` (`C`) or
`meta` (`M`) and pressing another key. For example `C-x` means hold
down `control` and press the `x` key. On a mac, `meta` is typically
bound to the `ESC` key by default, so `M-f` means hold down `ESC` and
press `f` (okay, so the `ESC` key is special in that you don't have to
hold it down when it's being used as a modifier, but don't worry about
this, it wont matter once you rebind the meta key). Save your fingers,
rebind the control and meta keys now:

* Rebind the meta-key.
  * Open the terminal settings.
  * Click on the keyboard settings pane.
  * At the bottom, find the checkbox labeled "Use
  option key as meta key", make sure it's checked.
  * **Note** that this setting is set on a per theme basis. Make sure
  you set it correctly for your default theme.

* Rebind the control key.
  * Open your system preferences.
  * Go to keyboard settings pane and move to the keyboard pane (not
    keyboard shortcuts).
  * click on the "Modifier keys" button.
  * I recommend setting both the Control and Caps Lock key to act as
    `^ Control`. No one uses caps lock anyway. Bonus: this will make
    you less rude on the internet.
  * **Note** this setting is set on a per keyboard setting, so you
    have to reset it for external keyboards.

## Basic Navigation

Read through all of these and try them in the command line before
moving on. They may seem weird at first, but they are awesome once you
get used to using them.

#### Replace the Arrow Keys

* `C-f` / `C-b` - move forward/back one character (like the arrow
  keys).
* `C-p` / `C-n` - move up/down one line (like the arrow keys).

#### Cooler Navigation

* `C-a` / `C-e` - move to the beginning/end of a line.
* `M-f` / `M-b` - move forward/back one WORD (THIS IS AWESOME).

#### Delete Stuff Like a Pro

* `C-d` - deletes the character under the cursor.
* `M-d` - deletes the next word.
* `M-backspace` - deletes the previous word.
* Killing and yanking are kind of like cutting and pasting. Very
  useful for moving stuff around, like when you prematurely type a
  command.
  * `C-k` - _kills_ the rest of the line after the cursor.
  * `C-y` - _yanks_ the last killed text.
