""php代码的检查与格式化工具
""实现以下功能:
""  1 :F
""      php代码的语法检查
""      格式化代码
""      去除行尾的空格,tab与^M
""      将文件中的tab改为4个空格
""  2 <F12> 生成方法注释
""  3 <F4> 生成作者信息
""2017/4/22
""author jingtianyou
let Copyright = ' * Copyright @ '
let str = nr2char(10)  " 不可打印字符  
let str = strtrans(str)
let User      = ' * User: ' . get(split(system('who'), ' '), 0)
if !exists('g:PHP_SYNTAX_CHECK_BIN')
    let g:PHP_SYNTAX_CHECK_BIN = 'php'
endif
command! F call Formatcheck()
nmap <F4> :call Addhead()<CR>:10<CR>o
nmap <F12> :call Funchead()<CR>:.+5<CR>o
nmap <F6> :call Funcdebug1()<CR>i
nmap <F7> :call Funcdebug2()<CR>i
nmap <F8> :call Funcdebug3()<CR>i
if !exists("*Funcmove")
func! Funcmove(line, clom)
    let pos = getpos(".")
    let pos[1] = pos[1] + a:line
    let pos[2] = pos[2] + a:clom
    call setpos('.', pos)
endfunc
endif
if !exists("*Formatcheck")
func! Formatcheck()
    let n = line('.')
    silent! w
    call Format()
    execute n
    echom "FCheck: Code Format Done!"
    if (expand('%:e') == 'php')
        let result = system(g:PHP_SYNTAX_CHECK_BIN.' -l -n '.expand('%'))
        if (stridx(result, 'No syntax errors detected') == -1)
            echohl WarningMsg | echo result | echohl None
        endif
    endif
endfunc
endif
if !exists("*Format")
function! Format()
    call Removess()
    try
        execute "normal gg=G \<Esc>"
        execute 'set ts=4'
        execute 'set expandtab'
        execute '%retab!'
    catch
    endtry
endfunction
endif
if !exists("*Removess")
func! Removess()
    try
        execute '%s/\s\+$'
        execute '%s/^M$//g'
    catch
    endtry
endfunc
endif
if !exists("*Addhead")
func! Addhead()
    let n = 3
    let line = getline(n)
    let str = '^ \* Copyright @ $' 
        if line =~ str
            return
        endif
    call Setfilehead()
endfunc
endif
if !exists("*Setfilehead")
func! Setfilehead()
    call append(0, '<?php')
    call append(1, '/**')
    call append(2, g:Copyright)
    call append(3, g:User)
    call append(4, ' * Date: '.strftime("%Y-%m-%d %H:%M:%S"))
    call append(5, ' * Desc: ')
    call append(6, ' */')
endfunc
endif
if !exists("*Funchead")
func! Funchead()
    call append(line(".")+0, '    /**')
    call append(line(".")+1, '     * @param')
    call append(line(".")+2, '     * @return')
    call append(line(".")+3, '     * Desc')
    call append(line(".")+4, '     */')
endfunc
endif
if !exists("*Funcdebug1")
func! Funcdebug1()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, '$var = var_export(, true);')
    call append(line(".")+4, "file_put_contents('/tmp/log', $var);")
    call append(line(".")+5, 'die;')
    call append(line(".")+6, '}')
    call append(line(".")+7, '//********debug 断点，后续请删除*********')
    call append(line(".")+8, '')
    call Funcmove(4, 18)
endfunc
endif
if !exists("*Funcdebug2")
func! Funcdebug2()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, 'var_dump();')
    call append(line(".")+4, 'die;')
    call append(line(".")+5, '}')
    call append(line(".")+6, '//********debug 断点，后续请删除*********')
    call append(line(".")+7, '')
    call Funcmove(4, 9)
endfunc
endif
if !exists("*Funcdebug3")
func! Funcdebug3()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, 'print_r();')
    call append(line(".")+4, 'die;')
    call append(line(".")+5, '}')
    call append(line(".")+6, '//********debug 断点，后续请删除*********')
    call append(line(".")+7, '')
    call Funcmove(4, 8)
endfunc
endif
