Toggle terminal buffer or create new one if there is none.

![](example-toggle-terminal.gif)

You have to set your own mappings. For example:

```vim
nnoremap <silent> <C-z> :call nvim_toggle_terminal#ToggleTerminal()<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:call nvim_toggle_terminal#ToggleTerminal()<Enter>
```

It keeps the shell session between toggles.

Some extra setting that can be used in conjuction with this plugin for convenience:

```vim
" Use ESC key to exit Terminal mode, but don't override fzf ESC mapping
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
```

Use [nvr](https://github.com/mhinz/neovim-remote) to avoid nesting nvim in Terminal buffers. This should go in your `.bashrc` or similar.

```bash
nvim_wrapper() {
  if test -z $NVIM_LISTEN_ADDRESS; then
      nvim $argv
  else
    if test -z $argv; then
        nvr -l -c new
    else
        nvr -l $argv
    fi
  fi
}

alias nvim="nvim_wrapper"
```
