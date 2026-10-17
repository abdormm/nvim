" Vim syntax file
" Language: jbc (tafj)

syntax clear

syntax keyword jbcKeyword
            \ ABORT
            \ BEGIN
            \ CALL
            \ CASE
            \ COMMON
            \ CRT
            \ DIM
            \ DO
            \ ELSE
            \ END
            \ EXECUTE
            \ FIND
            \ FINDSTR
            \ FOR
            \ FUNCTION
            \ GOSUB
            \ GOTO
            \ IF
            \ IN
            \ INS
            \ INSERT
            \ INT
            \ LOCATE
            \ LOOP
            \ NEXT
            \ NULL
            \ OFF
            \ ON
            \ OPEN
            \ OPENDEV
            \ OPENINDEX
            \ OPENSEQ
            \ OPENSER
            \ OR
            \ PAUSE
            \ PRINT
            \ PROGRAM
            \ READ
            \ READLIST
            \ READONLY
            \ READSEQ
            \ READT
            \ READTX
            \ READU
            \ READV
            \ READVU
            \ READX
            \ READXU
            \ REPEAT
            \ RETURN
            \ SETTING
            \ STEP
            \ STOP
            \ SUBROUTINE
            \ THEN
            \ TO
            \ UNASSIGNED
            \ UNTIL
            \ USING
            \ WAITING
            \ WHILE
            \ WRITE
            \ WRITEBLK
            \ WRITELIST
            \ WRITESEQ
            \ WRITEU
            \ WRITEVU
            \ WRITEX
            \ WRITEXU
" a variable must start with a character
" a label must start with a character or a digit
" both can contain _, $, . and digits
syntax match jbcInclude /\v\$(INSERT|USING|PACKAGE)/
syntax match jbcLabel /\v^\s*(\a|\d)(\w|\.|\$)*:/
syntax match jbcOperator /\v(:|\+|\*|\-)/
syntax match jbcFunction /\v\a(\w|\.|\$)*(\(.*\))@=/
syntax match jbcSubroutine /\v(CALL\s*)@<=\a(\w|\.|\$)*/
syntax match jbcSubroutine /\v(SUBROUTINE\s*)@<=\a(\w|\.|\$)*/

syntax region jbcString start=/'/ end=/\v'|$/
syntax region jbcString start=/"/ end=/\v"|$/
syntax region jbcString start=/\\/ end=/\v\\|$/

syntax match jbcComment /\v(^|;)\s*(!|REM\s+|\*).*/

highlight default link jbcKeyword Keyword
highlight default link jbcInclude PreProc
highlight default link jbcLabel Label
highlight default link jbcOperator Operator
highlight default link jbcFunction Function
highlight default link jbcSubroutine Function
highlight default link jbcComment Comment
highlight default link jbcString String
