vnoremap <C-c> "+y
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+
" Enable relative and absolute line numbers
set number
set relativenumber

" Smooth scrolling with Ctrl+u and Ctrl+d
set scrolloff=8  " Keeps cursor centered when scrolling

" Remove `~` from empty lines
set fillchars=eob:\ 