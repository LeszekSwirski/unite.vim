"=============================================================================
" FILE: jump_list.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 22 Oct 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! unite#kinds#jump_list#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'jump_list',
      \ 'default_action' : 'open',
      \ 'action_table': {},
      \}

" Actions"{{{
let s:kind.action_table = deepcopy(unite#kinds#file#define().action_table)

let s:kind.action_table.open = {
      \ 'is_selectable' : 1, 
      \ }
function! s:kind.action_table.open.func(candidate)"{{{
  edit `=a:candidate.word`
  
  let l:linenr = (has_key(a:candidate, 'line') && a:candidate.line != '') ? a:candidate.line : 1

  if has_key(a:candidate, 'pattern') && a:candidate.pattern != ''
        \ && getline(l:linenr) !~ a:candidate.pattern
    " Search pattern.
    call search(escape(a:candidate.pattern, '~\.^$[]'), 'w')
  else
    " Jump to a:candidate.line.
    execute l:linenr
  endif
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate)"{{{
  execute 'pedit'
        \ (has_key(a:candidate, 'line') && a:candidate.line != '' ? '+'.a:candidate.line : '')
        \ (has_key(a:candidate, 'pattern') && a:candidate.pattern != '' ? '+/'.substitute(escape(a:candidate.pattern, '\. ', 'g'), '[\[\]~/^$]', '\\\\\0', 'g') : '')
        \ '`=a:candidate.word`'
endfunction"}}}
"}}}

" vim: foldmethod=marker
