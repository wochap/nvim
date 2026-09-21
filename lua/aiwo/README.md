# aiwo

Prompt builder for AI agents. Turns a visual selection into a markdown snippet
block (`path:start-end` + fenced code) inside a scratch prompt file opened in a
vertical split. Prompts are per project (cwd) and live in
`$XDG_RUNTIME_DIR/aiwo` (tmpfs), so they vanish on reboot.

## API

```lua
require("aiwo").new(opts)     -- new prompt file, write snippet, open split
require("aiwo").append(opts)  -- append snippet to current prompt (or new)
require("aiwo").pick()        -- snacks picker over project prompts
require("aiwo").open()        -- open current prompt, or pick()
```

`opts` (merged over `setup` defaults):

| key     | default | meaning                                       |
| ------- | ------- | --------------------------------------------- |
| `copy`  | `false` | copy whole prompt to `+` register after write |
| `show`  | `true`  | open the split after write                    |
| `focus` | `true`  | move cursor to the split (needs `show`)       |
| `input` | `false` | ask free text via `vim.ui.input` first        |
| `width` | `0.5`   | split width, fraction of current window       |
| `dir`   | `nil`   | base dir override                             |

## Snippet format

Visual selection:

````
lua/custom/lazy.lua:1-5
```lua
...
```
````

Normal mode in a file buffer: `read <path>`. Normal mode in a scratch buffer:
whole buffer in a 4-backtick fence.

Split keys: `q` close, `<localleader>y` yank prompt to clipboard.
