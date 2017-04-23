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
command F call Formatcheck()
nmap <F4> :call Addhead()<CR>:10<CR>o
nmap <F12> :call Funchead()<CR>:.+5<CR>o
func Formatcheck()
    let n = line('.')
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
func Removess()
    try
        execute '%s/\s\+$'
        execute '%s/^M$//g'
    catch
    endtry
endfunc
func Addhead()
    let n = 3
    let line = getline(n)
    let str = '^ \* Copyright @ $' 
        if line =~ str
            return
        endif
    call Setfilehead()
endfunc
func Setfilehead()
    call append(0, '<?php')
    call append(1, '/**')
    call append(2, g:Copyright)
    call append(3, g:User)
    call append(4, ' * Date: '.strftime("%Y-%m-%d %H:%M:%S"))
    call append(5, ' * Desc: ')
    call append(6, ' */')
endfunc
func Funchead()
    call append(line(".")+0, '    /**')
    call append(line(".")+1, '     * @param')
    call append(line(".")+2, '     * @return')
    call append(line(".")+3, '     * Desc')
    call append(line(".")+4, '     */')
endfunc
