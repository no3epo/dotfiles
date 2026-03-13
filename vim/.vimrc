" =======================================
" 基础设置
" =======================================

" 关闭与传统 vi 的兼容模式，启用 Vim 的所有特性
set nocompatible

" 开启语法高亮
syntax on

" 开启文件类型检测，并按文件类型加载对应的插件和缩进规则
filetype plugin indent on

" 设置 Vim 内部使用的字符编码为 UTF-8
set encoding=utf-8

" 设置新建文件时的默认编码格式为 UTF-8
set fileencoding=utf-8

" 设置读取文件时的备选解码格式，UTF-8 >> GBK
set fileencodings=utf-8,gbk,latin1

" 在左侧显示绝对行号
set number

" 在命令行模式下开启可视化的自动补全菜单（例如输入 :e 之后按 Tab）
set wildmenu

" 始终在窗口底部显示状态栏（即使只有一个窗口）
set laststatus=2

" 插入右括号时，短暂跳转到匹配的左括号以示提示
set showmatch

" 高亮显示所有的搜索匹配项
set hlsearch

" 在输入搜索词的过程中，实时跳转并显示匹配结果
set incsearch

" 搜索时默认忽略英文字母的大小写
set ignorecase

" 智能大小写探测：如果搜索词中包含大写字母，则自动切换为大小写敏感模式
set smartcase

" 将输入的 Tab 键自动展开为相应数量的空格
set expandtab

" 设置每次自动缩进（或使用 >> 和 << 缩进时）所使用的空格数量为 4
set shiftwidth=4

" 设置文件中一个 Tab 字符所占据的视觉宽度（空格数）为 4
set tabstop=4

" 开启智能缩进，在编写代码块时自动增加缩进级别
set smartindent

" 开启自动缩进，新行的缩进级别将自动继承上一行的缩进级别
set autoindent

" 开启自动补全菜单：始终显示弹窗菜单，并在输入时实时展示内容
set completeopt=menu,menuone,noselect

" 禁用交换文件和常规备份文件，避免隐藏文件污染工作目录
set noswapfile
set nobackup
set nowritebackup



" =======================================
" 快捷键映射
" =======================================

" 预留添加映射



" =======================================
" 自定义函数与命令
" =======================================

" 预留添加函数



" =======================================
" 自动命令
" =======================================

" 防止自动命令被重复加载拖慢速度：使用 augroup 包裹并清理旧规则
augroup CustomIndents
    autocmd!

    " 针对前端和通用文本 使用 2 个空格作为缩进
    autocmd FileType vue,javascript,typescript,html,css setlocal shiftwidth=2 tabstop=2

    " 针对配置文件格式 使用 2 个空格作为缩进
    autocmd FileType yaml,yml,json setlocal shiftwidth=2 tabstop=2

    " 针对Java 使用 4 个空格作为缩进
    autocmd FileType java setlocal shiftwidth=4 tabstop=4
augroup END