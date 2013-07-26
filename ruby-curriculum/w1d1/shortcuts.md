# Keyboard Shortcuts

Developers like to stay on the keyboard as much as possible. You should
limit your use of the mouse. Keep this page open (or find/make your own
keyboard shortcut cheatsheet) and refer to it often. Get practice
with these commands.

## Textmate

### Navigation
* Show project drawer: `Ctl + Opt + Cmd + d`
  * Note: A project is a folder which contains multiple related files. 
    These shortcuts will be very useful when we get to Rails.
* Go to file: `Cmd + t`
* New tab: `Opt + Cmd + n`
* Close tab: `Cmd + w`
* Next tab: `Opt + Cmd + LArrow`
* Previous tab: `Opt + Cmd + RArrow`
* Go to line: `Cmd + l`

### Finding
* Find: `Cmd + f`
* Find in project: `Shift + Cmd + f`

### Editing
* Comment out selection: `Cmd + /`
* Indent selection: `Cmd + ]`
* Unindent selection: `Cmd + [`
* Select line: `Shift + Cmd + l`
* Delete current line: `Shift + Ctl + k`
* Duplicate current line: `Shift + Ctl + d`
* Undo: `Cmd + z`


Check out the [TextMate Manual][tm_man], which is great!

this [essential TextMate shortcuts tutorial][tm_tut] might be easier to follow.

And this quick pdf reference for [TextMate shortcuts][tm_cheatsheet]

Lastly, in case you don't know or forget what a ⌥ key is, [key reference][key_reference]

[tm_tut]: http://net.tutsplus.com/tutorials/tools-and-tips/essential-textmate-shortcuts-tips-and-techniques/

[tm_man]: http://manual.macromates.com/en/all_pages.html

[tm_cheatsheet]: https://sites.google.com/a/grayskies.net/www/textmate

[key_reference]: http://myfirstmac.com/images/uploads/articleImages/key-symbols.gif



## Bash

Bash is the process running in your terminal. Get to know it.

Here are some keyboard shortcuts for editing a line that may help:

```
         beg-of-line: ctr-a
         end-of-line: ctr-e
   move-to-prev-word: alt-left
   move-to-next-word: alt-right
  kill previous word: alt-backspace
         kill-to-end: ctr-k
         kill-to-beg: ctr-u
```

You will have to go into `Terminal > Preferences Keyboard` and check
`Use option as meta key`.

You can also scroll back in the history intelligently using up and
down. Normally, up and down just scroll through previous commands. But
if you copy my [.inputrc][inputrc], you'll be able to scroll through
only commands which start with a prefix.

On any of the school machines, type `git ` into the terminal. If you
hit up and down now, you'll only scroll through previous git
commands. This is often a lot more useful for scrolling back to
commands from long ago.

That's what my [.inputrc][inputrc] enables. This is installed on our
machines. For yours, download the file (click "raw") and save it to
`~/.inputrc`. The `.` prefix means it is a hidden file; this is
important.

[inputrc]: https://github.com/appacademy/dotfiles/blob/master/inputrc

If you're on a mac laptop, it may be nice to switch `caps-lock` with
`ctrl` key. You can do that in your keyboard preferences. Makes
hitting things like `ctrl-a` and `ctrl-e` a little bit easier. Who
uses caps-lock anyway?
**Warning:** This may enrage anyone who uses your computer.
