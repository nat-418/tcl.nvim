tcl.nvim
========

This is a Neovim plugin to aid Tcl/Tk development. It includes:

* Support for the [Nagelfar](https://nagelfar.sourceforge.net/) syntax checker

Installation
------------

Use you preferred method to place this repository on your runtime path.
I recommend putting it in the `opt/` plugins directory.
Then add this code to your `ftplugins/tcl.lua` file:

```lua
vim.cmd.packadd('tcl.nvim')
require('tcl').setup()
```

Usage
-----

This plugin provides a few user commands:

|      Command Name            |          Description                |
| ---------------------------- | ----------------------------------- |
| `:Nagelfar {path\|%}`        | Run the syntax checker on some file |


Thanks
------

* [Peter Spjuth](https://wiki.tcl-lang.org/page/Peter+Spjuth) for Nagelfar
* [flukus](https://github.com/flukus) for this
[write-up ](https://flukus.github.io/vim-errorformat-demystified.html)
on how to format Vim/Neovim's `set errorformat=$ARRAY` arrays.
