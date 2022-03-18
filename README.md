# listed.nvim

_basic persistent listing support_


## Overview

Simple neovim lua plugin for persistent filesystem listing support


```lua
local list = require("listed.list").open("~/.vim/mylist.list")

list:add("~/somepath")

if list:contains_parent_of("~/somepath/somethingelse") then
    -- dothing
end

```




