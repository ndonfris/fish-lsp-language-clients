" TextEdit might fail if hidden is not set.
" set hidden

" Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

" Give more space for displaying messages.
"set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
" set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=yes
else
  set signcolumn=yes
endif

" let g:coc_node_path='/home/ndonfris/.n/bin/node'
let g:coc_config_home = '~/.config/nvim-fish-lsp'

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.

"vmap <> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
"let g:coc_snippet_next = ''

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_next = "<Tab>"
let g:coc_snippet_prev = "<S-Tab>"

" Use <C-l> for both expand and jump (make expand higher priority.)
imap <c-l> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <A-s>  <Plug>(coc-convert-snippet)
xmap <silent> <leader>cs  <Plug>(coc-convert-snippet)
xmap <silent> <leader><c-s>  <Plug>(coc-convert-snippet)

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s' || getline('.')[col-1] =~# '{'
"endfunction

"Use <C-j> and <C-k> to navigate the completion list:
" also works for copilot acceptions
function! Insert_Coc_CJ()
    if coc#pum#visible() 
        silent! call feedkeys("\<Down>")
    elseif coc#jumpable()
        silent! call feedkeys("\<c-r>=coc#rpc#request('snippetNext', [])\<CR>")
    elseif col('.') == col("$") - 1 || col('.') == col('$') - 2
        silent! call feedkeys("\<C-o>$")
    else
        silent! call feedkeys("\<C-o>w\<Right>")
    endif
endfunction

function! Insert_Coc_CK()
    if coc#pum#visible() 
        silent! call feedkeys("\<Up>")
    elseif coc#jumpable()
        silent! call feedkeys("\<c-r>=coc#rpc#request('snippetPrev', [])\<CR>")
    else
        silent! call feedkeys("\<C-o>b")
    endif
endfunction

imap <silent> <c-j> <cmd>call Insert_Coc_CJ()<CR>
imap <silent> <c-k> <cmd>call Insert_Coc_CK()<CR>


function! Insert_Coc_CD()
    if coc#pum#visible() 
        silent! call feedkeys("\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>\<Down>")
    elseif coc#float#has_scroll()
        silent! call coc#float#scroll(-1)
    else 
        silent! call feedkeys("\<C-d>", "n")
        "silent! exe "normal! <cmd>lua require('specs').show_specs()<cr>"
    endif
endfunction

function! Insert_Coc_CU()
    if coc#pum#visible() 
        silent! call feedkeys("\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>\<Up>")
    elseif coc#float#has_scroll()
        silent! call coc#float#scroll(0)
    else 
        silent! call feedkeys("\<C-t>", "n")
    endif
endfunction

function! Normal_Coc_CD()
    if &filetype ==# "coctree" || !coc#float#has_scroll() 
        silent! call feedkeys("\<C-d>", "n")
    else 
        silent! call coc#float#scroll(1)
    endif
endfunction

function! Normal_Coc_CU()
    if &filetype ==# "coctree" || !coc#float#has_scroll() 
        silent! call feedkeys("\<C-u>", "n")
    else
        silent! call coc#float#scroll(0)
    endif
endfunction



inoremap <silent><nowait> <C-d> <cmd>call Insert_Coc_CD()<cr>
inoremap <silent><nowait> <C-u> <cmd>call Insert_Coc_CU()<cr>
nnoremap <silent><nowait> <C-d> <cmd>call Normal_Coc_CD()<cr>
nnoremap <silent><nowait> <C-u> <cmd>call Normal_Coc_CU()<cr>


function! ICSpace()
    silent! call coc#refresh() 
    if coc#pum#visible()
        " silent! lua require("copilot.suggestion").dismiss()
        " let b:copilot_suggestion_hidden=1
        silent! call coc#pum#confirm()
    else
        silent! call coc#refresh()
    endif
    silent! call coc#refresh()

endfunction

imap <silent><nowait> <c-a> <cmd>silent! call CocAction('showSignatureHelp')<cr>









" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

 

" inoremap <silent><nowait> <C-Space> <cmd>silent! call ICSpace()<cr>




" if has('nvim')
"   "g:coc_trim_final_
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" Command mode 
function s:wildchar()
    call feedkeys("\<Tab>", 'nt')
    return ''
endfunction

" paste
cnoremap <C-v> <C-r>+
cnoremap <C-Space> <C-r>=<SID>wildchar()<CR>

" confirms selection if any or just break line if none
function! EnterSelect()
    " if the popup is visible and an option is not selected
    if pumvisible() && complete_info()["selected"] == -1
        return "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    " if the pum is visible and an option is selected
    elseif pumvisible()
        return coc#_select_confirm()
    " if the pum is not visible
    else
        return "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    endif
endfunction

function! Insert_Coc_CC()
    if coc#pum#visible()
       silent! call coc#pum#cancel() 
       silent! call feedkeys("\<ESC>")
    else
        silent! call feedkeys("\<ESC>\<ESC>\<ESC>", "t")
    endif
endfunction

inoremap <silent><nowait> <C-c> <cmd>call Insert_Coc_CC()<CR>
nnoremap <silent><nowait><expr> <C-c> coc#float#has_float() ? coc#float#close_all(1) : feedkeys("\<ESC>\<ESC>\<ESC>", "t")

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()


" makes <CR> confirm selection if any or just break line if none
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gd <Plug>(coc-diagnostic-info)

nmap <silent>ccf <cmd>call coc#float#close_all()<cr>

" GoTo code navigation.
nmap <silent> gD <cmd>Telescope coc diagnostics<cr>
"nmap <silent> gd <cmd>Telescope coc definitions<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <cmd>Telescope coc type_definitions<cr> 
nmap <silent> <leader>e <Plug>(coc-diagnostic-next-error)   " next error
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent><leader>ca <Plug>(coc-codeaction)
"nmap <silent> gca <Plug>(coc-codeaction-line)          " code lens
"nmap <silent> gca <Plug>(coc-codelens-action)         " code lens
nmap <silent> gf <C-w>f
"nmap <silent> gF <Plug>(coc-fix-current)             " quickfix
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ga <cmd>Gitsigns setqflist<cr>
nmap <silent> gF <cmd>call CocAction('fold')<cr>

" Use <C-k> to show documentation in preview window.
"nnoremap <silent>gh :call <SID>show_documentation()<CR>
"nnoremap <silent>gs :call ShowDocumentation()<CR>

" Symbol renaming.
nmap <silent> <leader>rn <Plug>(coc-rename)
" open refactor window
nmap <silent> <leader>rf <Plug>(coc-refactor)

"
" Remap keys for applying codeAction to the current buffer.
nmap <silent><leader>ca  <Plug>(coc-codeaction)
nmap <silent>gca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>

" Formatting selected code.
"nmap <leader>f  <Plug>(coc-format-selected)
"vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <cmd>call CocActionAsync('format')<cr>
vmap <leader>f  <Plug>(coc-format-selected)
xmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

function! ShowDocumentation()
    let current_word = expand('<cword>')
    "if coc#float#has_float()
    "  call feedkeys("\<C-w>w")
    "elseif
    if CocAction('hasProvider', 'hover') 
        call CocActionAsync('definitionHover')
        echo 'Hover found for "'.current_word.'"'
    else
        echo 'Hover not found for "' current_word '" in filetype: ' . &filetype 
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent! call CocActionAsync('highlight')
nnoremap <silent>gs <cmd>silent! call ShowDocumentation()<cr>

" ┌───────────────────┐
" │┏━┓╻ ╻╺┳╸╻  ╻┏┓╻┏━╸│
" │┃ ┃┃ ┃ ┃ ┃  ┃┃┗┫┣╸ │
" │┗━┛┗━┛ ╹ ┗━╸╹╹ ╹┗━╸│
" └───────────────────┘
": h coc-callHierarchy
" autocmd for cocOutline showOutline  !currently disabled auto-open!
"autocmd VimEnter,Tabnew *
"      \ if empty(&buftype) | call CocActionAsync('showOutline', 1) | endif
" close outline automatically if its the last tab
autocmd BufEnter * call CheckOutline()
function! CheckOutline() abort
    if &filetype ==# 'coctree' && winnr('$') == 1
        if tabpagenr('$') != 1
            close
        else
            bdelete
        endif
    endif
endfunction
"
" toggle normal outline
nnoremap <silent><nowait> <leader>o  <cmd>call ToggleOutline()<CR>
function! ToggleOutline() abort
    let winid = coc#window#find('cocViewId', 'OUTLINE')
    if winid == -1
        call CocActionAsync('showOutline', 0)
        call coc#float#close_all()
    else
        call coc#window#close(winid)
        call coc#float#close_all()
    endif
endfunction
"
" jump back to current outline
nnoremap <silent><nowait> <leader>O <cmd>call FindOutline()<CR>
function! FindOutline() abort
    let winid = coc#window#find('cocViewId', 'OUTLINE')
    if winid == -1
        call CocActionAsync('showOutline', 0)
    else
        call coc#window#close(winid)
        call CocActionAsync('showOutline', 0)
        call coc#float#close_all()
    endif
endfunction
" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup_coc
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  "autocmd User CocNvimInit call CocAction('runCommand',
  "            \ 'coc-nav')
  autocmd User CocNvimInit call CocAction('ensureDocument')
  "autocmd CursorHold * silent! call ShowDocumentation()
augroup end

"autocmd CursorMoved * silent call CocCommand('coc-nav.runCommand')

" Add :Format command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

let g:coc_borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let g:coc_border_joinchars = ['┬', '┤', '┴', '├']
let g:coc_prompt_win_width = 45
"let g:coc_filetype_map = {'tex': 'latex', 'javascript': 'javascriptreact', 'typescript': 'typescriptreact'}
let g:vim_markdown_fenced_languages = [
        \ 'vim',
        \ 'help',
        \ ]

let g:tmuxcomplete#trigger = ''

"let g:coc_start_at_startup = v:true
let b:coc_is_active = 1
let g:coc_disable_startup_warning = 1
let g:coc_disable_uncaught_error = 1
let g:coc_trim_final_newlines = 1
let g:coc_trim_trailing_whitespace = 0

function EchoCocStart() abort
    :CocStart
    echo "Coc Starting..."
endfunction

nnoremap <leader>00 <cmd>call EchoCocStart()<cr>
nnoremap <leader>99 <cmd>TSBufDisable highlight<cr>

let g:coc_global_extensions = ['coc-copilot']

nnoremap <leader>qf <Plug>(coc-fix-current)
nnoremap <leader>gcr <Plug>(coc-codeaction-refactor)

nnoremap <leader>oc <cmd>CocCommand workspace.showOutgoingCalls<cr> 
nnoremap <leader>ic <cmd>CocCommand workspace.showIncomingCalls<cr> 
nnoremap <leader><leader>co <Plug>(coc-openlink)
nnoremap <leader><leader>ca <Plug>(coc-codelens-action)
"CocAction('openlink')|
"CocCommand document.showOutgoingCalls

"autocmd VimEnter *.* call EchoCocStart()
autocmd CursorHold *.fish,*.ts,*.tsx if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif
autocmd! BufEnter,BufWinEnter,VimEnter *.*,!term://* call EchoCocStart()
"let g:coc_start_at_startup = 1
