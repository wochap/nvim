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
require("aiwo").run(opts)     -- send prompt text to an agent CLI in a terminal
```

`opts` (merged over `setup` defaults):

| key     | default                                | meaning                                       |
| ------- | --------------------------------------- | --------------------------------------------- |
| `copy`  | `false`                                 | copy whole prompt to `+` register after write |
| `show`  | `true`                                  | open the split after write                    |
| `focus` | `true`                                  | move cursor to the split (needs `show`)       |
| `input` | `false`                                 | ask free text via `vim.ui.input` first        |
| `width` | `0.5`                                   | split width, fraction of current window       |
| `dir`   | `nil`                                   | base dir override                             |
| `cmd`   | `{ "agents", "run", "-a", "pi", "{prompt}" }` | agent command for `run()`, see below   |

## run()

Sends a prompt to an agent via a CLI, in a `Snacks.terminal` split. Target
prompt: focused buffer if it's an aiwo prompt of the current project, else
the project's current/last prompt. Saves the buffer first if modified.

`cmd` is a table or a `fun(path: string): string[]`. In the table form,
`"{prompt}"` is replaced by the prompt text, `"{file}"` by the prompt path.
The default passes the prompt as an argv item (not stdin), because piping
breaks `agents run`'s `ctrl+t` takeover, which requires `stdin.isTTY`.

Override to use a different agent:

```lua
require("aiwo").setup {
  cmd = { "agents", "run", "-a", "claude", "{prompt}" },
}
```

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
