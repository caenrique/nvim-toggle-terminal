Toggle terminal buffer or create new one if there is none.
It keeps the shell session between toggles.

<p align="center">
   <img src="https://i.imgur.com/vL96PcL.gif">
<p>

You have to set your own key bindings. For example:

```vim
nnoremap <silent> <C-z> :call nvim_toggle_terminal#ToggleTerminal()<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:call nvim_toggle_terminal#ToggleTerminal()<Enter>
```

Use `g:toggle_terminal_tab_specific` to configure tab specific terminal instances:

```vim
let g:toggle_terminal_tab_specific = 1
```

This config variable only apply to the `nvim_toggle_terminal#ToggleTerminal` function. However, you could avoid that function and use `nvim_toggle_terminal#Toggle` directly.

Define a key binding for the global terminal instance, and another one for the tab-specific instance:

```vim
" Global terminal intances
nnoremap <silent> <C-z> :call nvim_toggle_terminal#Toggle("g:terminal")<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:call nvim_toggle_terminal#Toggle("g:terminal")<Enter>

" Tab-specific terminal instance
nnoremap <silent> <C-x> :call nvim_toggle_terminal#Toggle("t:terminal")<Enter>
tnoremap <silent> <C-x> <C-\><C-n>:call nvim_toggle_terminal#Toggle("t:terminal")<Enter>
```

or even a window-specific terminal using:

```vim
nvim_toggle_terminal#Toggle("w:terminal")
```

The name of the variable doesn't matter. It is the scope what is important.

## Useful nvim settings

Some extra setting that can be used in conjuction with this plugin for convenience:

Make your life easier by mapping ESC in terminal mode. And if you use fzf, this will not break the ESC behaviour:

```vim
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
```

Use this to switch back and forth between files and terminal without the anoying `No write since last change (add ! to override)` message with unsaved changes:

```vim
set autowriteall
```

Use [nvr](https://github.com/mhinz/neovim-remote) to avoid nesting nvim in Terminal buffers. This should go in your `.bashrc` or similar:

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

## Instalation

Use your favourite plugin manager. For example, using [Plug](https://github.com/junegunn/vim-plug):

```vim
call plug#begin()
Plug 'caenrique/nvim-toggle-terminal'
call plug#end()
```
