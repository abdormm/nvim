" Vim syntax file
" Language: jbc (tafj)

syntax clear 

syntax keyword jbcKeyword
            \ ABORT
            \ CALL
            \ CASE
            \ CRT
            \ DO
            \ ELSE
            \ END
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

syntax match jbcInclude /\v\$(INSERT|USING|PACKAGE)/
syntax match jbcLabel /\v^\s*(\w|_|\.)+:/
syntax match jbcOperator /\v(:|\+|\*|\-)/ 
syntax match jbcFunction /\v(CALL\s*)@<=\k+(\(.*\))@=/

syntax region jbcString start=/'/ end=/\v'|$/
syntax region jbcString start=/"/ end=/\v"|$/
syntax region jbcString start=/\\/ end=/\v\\|$/

syntax match jbcComment /\v(^|;)\s*(!|REM\s+|\*).*/

highlight default link jbcKeyword Keyword
highlight default link jbcInclude PreProc
highlight default link jbcLabel Label
highlight default link jbcOperator Operator
highlight default link jbcFunction Function
highlight default link jbcComment Comment
highlight default link jbcString String
