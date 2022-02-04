;Remover itens após ou antes de um determinado caracter
string := 7650.0000
msgbox % SubStr(String, 1, InStr(string, ".") - 1) 
msgbox % SubStr(String, InStr(string, ".") + 1)



;Pegar do início até um caracter específico:
string := "0x100C32\4.1.1.1.1.2.2.2.2"
LastDotPos := InStr(string,"\",0,0)  ; get position of last occurrence of "."
result := SubStr(string,1,LastDotPos-1)  ; get substring from start to last dot
MsgBox %result%  ; display result 0x100C32

;Pode ser assim também
string := "0x100C32\4.1.1.1.1.2.2.2.2"
result := SubStr(string,1,InStr(string,"\",0,0)-1)  ; get substring from start to last dot

