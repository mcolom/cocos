assume cs:code,ds:data

data segment
 int9_ori_offs dw 0
 int9_ori_segm dw 0
 activado      db 0

 extrn x_sent : word
 extrn y_sent : word
data ends

code segment public

public guarda_int
guarda_int proc near
 mov ax,3509h
 int 21h
 ; vector devuelto en ES:BX
 mov int9_ori_offs,bx
 mov int9_ori_segm,es
guarda_int endp

public nueva_int9
nueva_int9 proc near
 pushf
 push ax
 push dx
 cmp activado,1
 jz funcionando
 jmp volver_int_ori
 funcionando:
 in al,60h ; leer teclado


 volver_interrupcion:
 mov dx,20h
 mov al,dl
 out dx,al ; mandar EOI
 pop dx
 pop ax
 popf
 iret

 volver_int_ori:
 pop dx
 pop ax
 ; popf , se dejan metidas las Flags
 call far [int9_ori_offs]


endp


 code ends
end
