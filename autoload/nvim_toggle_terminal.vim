""
" @public
" Toggle terminal buffer or create new one if there is none.
"
" nnoremap <silent> <C-z> :call nvim-toggle-terminal#ToggleTerminal()<Enter>
" tnoremap <silent> <C-z> <C-\><C-n>:call nvim-toggle-terminal#ToggleTerminal()<Enter>
""

let g:toggle_terminal_tab_specific = get(g:, 'toggle_terminal_tab_specific', 0)

let s:default_terminal = {
  \ 'loaded': v:null,
  \ 'termbufferid': v:null
\ }

function! nvim_toggle_terminal#ToggleTerminal() abort
  if !has('nvim')
    return v:false
  endif

  if g:toggle_terminal_tab_specific
    call nvim_toggle_terminal#Toggle("t:terminal")
  else
    call nvim_toggle_terminal#Toggle("g:terminal")
  endif
endfunction

function! nvim_toggle_terminal#Toggle(terminal_ref) abort
  if !exists(a:terminal_ref)
    let {a:terminal_ref} = copy(s:default_terminal)
  endif

  function! {a:terminal_ref}.on_exit(jobid, data, event)
    silent execute 'buffer' w:originbufferid
    let {a:terminal_ref} = copy(s:default_terminal)
  endfunction

  " If Terminal not open
  if !get({a:terminal_ref}, "loaded")
    let s:originbufferid = exists("w:originbufferid") ? w:originbufferid : bufnr('')

    enew | call termopen(&shell, {a:terminal_ref})
    set bufhidden=hide
    set nobuflisted
    let {a:terminal_ref}.loaded = v:true
    let {a:terminal_ref}.termbufferid = bufnr('')
    let w:originbufferid = s:originbufferid

    return v:true
  endif

  if get({a:terminal_ref}, "termbufferid") ==# bufnr('')
    " Go back to origin buffer if current buffer is terminal.
    silent execute 'buffer' w:originbufferid
  else
    " Go to terminal buffer if is loaded but not current buffer
    let s:originbufferid = exists("w:originbufferid") ? w:originbufferid : bufnr('')
    let l:id = get({a:terminal_ref}, "termbufferid")
    silent execute 'buffer' l:id
    let w:originbufferid = s:originbufferid
  endif
endfunction

function! nvim_toggle_terminal#TerminalOptions()
  silent au BufEnter <buffer> startinsert!
  silent au BufLeave <buffer> stopinsert!
  setlocal listchars= nonumber norelativenumber
  startinsert!
endfunction

