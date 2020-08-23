data segment
data ends

assume cs:code,ds:data

code segment public

public descomprime_asm
descomprime_asm proc pascal tamano,segm_or,offs_or,segm_dest,offs_dest : word
 ; ds:si --> es:di
 ; bx --> tamano
 push ds
 mov ds,segm_or
 mov si,offs_or
 mov es,segm_dest
 mov di,offs_dest
 mov bx,tamano
 ;
 descomprimir:
 mov al,[si]   ; cargar byte
 cmp al,192
 jb byte_directo  ; salta si < 192
 ; se trata de un byte de longitud
 and al,00111111b  ; descodificar
 mov ah,al         ; cuenta de longitud en AH
 inc si            ; posicionar sobre el byte de color a repetir
 lodsb             ; cargar byte en AL y posicionar sobre los datos
 repetir_color:
 mov byte ptr es:[di],al
 inc di            ; colocar el puntero
 dec bx
 jz fin_descompresion
 dec ah
 jnz repetir_color
 jmp descomprimir  ; seguir con la descompresi¢n
 ;
 byte_directo:
 movsb             ; copiar de ds:si --> es:di , y reposicionar punteros
 jmp descomprimir  ; seguir con la descompresi¢n
 ;
 fin_descompresion:
 pop ds
 ret
descomprime_asm endp


code ends
end