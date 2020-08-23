data segment
data ends

code segment public

assume cs:code,ds:data

public modo13h
modo13h proc pascal
 mov ax,13h
 int 10h
 ret
modo13h endp

public modo3
modo3 proc pascal
 mov ax,3
 int 10h
 ret
modo3 endp


public pinta_bloque
pinta_bloque proc pascal x,y,segm_or,offs_or,segm_dest,offs_dest:word

 ; AL    --> memoria de CX
 ; BX    --> skip
 ; CX    --> puntos por l¡nea
 ; DX    --> n§ de l¡neas
 ; DS:SI --> ES:DI

 push ds
 ; DS:SI --> ES:DI
 mov es,segm_dest
 mov ax,320
 mul y       ; AX = 320 * y
 add ax,x    ; AX = 320 * y + x
 mov di,ax   ; DI = 320 * y + x
 add di,offs_dest
 ; con esto ya est  listo el destino

 mov ds,segm_or
 mov si,offs_or
 ;con esto ya est  listo el origen

 ; CX ser  el ancho y DX el alto
 mov dx,word ptr [si]
 mov cx,word ptr [si+2]
 mov ax,cx
 add si,4

 ;usaremos BX como variable de skip
 mov bx,320
 sub bx,cx   ; restar el ancho del bloque

 ;
 pinta_linea:
 situar_puntos:
 cmp byte ptr ds:[si],0 ; ¨transparente?
 jz transparente
 movsb               ; pintar el punto
 dec cx              ; uno menos :-)
 jnz situar_puntos   ; seguir hasta el final de la l¡nea
 jmp linea_pintada   ; uffffff...por fin acabamos con esa l¡nea­
 transparente:
 inc si
 inc di
 dec cx
 jnz situar_puntos

 linea_pintada:
 mov cx,ax         ; reponer
 add di,bx         ; a¤adir el skip
 dec dx            ; una l¡nea menos :-)
 jnz pinta_linea   ; si a£n quedan,seguir

 ; y llegados a este punto...tach n...tach n...­se acab¢­ :-)))


 pop ds
 ret
pinta_bloque endp

public visualiza
visualiza proc pascal segm,offs : word
 ;ds:si --> es:di (0a000h:0)

 push ds
 mov di,0a000h
 mov es,di
 xor di,di
 mov ds,segm
 mov si,offs
 mov cx,16000
       ; esperar retrazado
       mov dx,03dah
       esperar_v:
       in al,dx ;leer Input Status Register 1
       test al,8
       jnz esperar_v
       esp_v:
       in al,dx ;leer I.S.R. 1
       test al,8
       jz esp_v
 db 066h
 rep movsw
 pop ds
 ret
visualiza endp

public copia
copia proc pascal segm_or,offs_or,segm_dest,offs_dest : word
 ;ds:si --> es:di (0a000h:0)
 push ds
 mov es,segm_dest
 mov di,offs_dest
 mov ds,segm_or
 mov si,offs_or
 mov cx,16000
 db 066h
 rep movsw
 pop ds
 ret
copia endp

public pinta_bloque_clip
pinta_bloque_clip proc pascal x,y,segm_or,offs_or,segm_dest,offs_dest :word

 ; AX    --> memoria de CX
 ; BX    --> skip
 ; CX    --> puntos por l¡nea
 ; DX    --> n§ de l¡neas
 ; DS:SI --> ES:DI

 push ds
 mov ds,segm_or
 mov si,offs_or   ; aunque con esto no es suficiente,luego se acaba

 xor di,di
 mov cs:izquierda,di
 mov cs:arriba,di
 mov cs:derecha,di
 mov cs:abajo,di

 ; if x<0 then izquierda := - x;
 mov ax,x
 or ax,ax
 jnl no_menor_x
 sub di,ax    ;di = 0 - x = - x

 mov cs:izquierda,di
 no_menor_x:

 ; if y<0 then arriba := - y;
 xor di,di
 mov ax,y
 or ax,ax
 jnl no_menor_y
 sub di,ax    ;di = 0 - y = - y
 mov cs:arriba,di
 no_menor_y:

 ; DS:SI --> ES:DI
 mov es,segm_dest
 mov bx,y           ; BX = y
 add bx,cs:arriba   ; BX = y + arriba
 mov ax,320
 mul bx          ; AX = 320 * ( y + arriba )
 add ax,x        ; AX = 320 * ( y + arriba ) + x
 add ax,cs:izquierda
 mov di,ax       ; DI = 320 * ( y + arriba ) + x
 add di,offs_dest
 ; con esto ya est  listo el destino

 mov cx,word ptr [si+2]                ; CX ( AX su memoria) ser  el ancho
   ; (bx es a£n y+arriba)
 mov ax,cx
 mov bx,cs:arriba
 mul bx          ; AX = ancho * arriba
 mov dx,word ptr [si]                      ; DX ser  el alto
 add si,ax
 add si,4
 ;con esto ya est  listo el origen

 ; seguir con los c lculos.Ahora calcular derecha y abajo
 ; if x + ancho > 320 then derecha := x + ancho - 320
 cmp x,319
 jle no_mayor_319
 jmp fin_pinta_bloque     ; fin,porque x > 319
 no_mayor_319:
 mov ax,x
 add ax,cx     ; ax = x + ancho
 cmp ax,320
 jle no_mayor_x
 sub ax,320    ; ax = x + ancho - 320
 mov cs:derecha,ax
 no_mayor_x:


 cmp y,199
 jle no_mayor_199
 jmp fin_pinta_bloque     ; fin,porque y > 200
 no_mayor_199:

 ; if y + alto > 200 then abajo := y + alto - 200
 mov ax,y
 add ax,dx     ; ax = y + alto
 cmp ax,200
 jle no_mayor_y
 sub ax,200    ; ax = x + alto - 200
 mov cs:abajo,ax
 no_mayor_y:

 ; comprobar que las cantidades a quitar no sean..."exageradas" ;)
 cmp cs:arriba,dx
 jle ok_arriba
 jmp fin_pinta_bloque     ; fin,porque se quita m s de lo que se tiene­
 ok_arriba:
 cmp cs:abajo,dx
 jle ok_abajo
 jmp fin_pinta_bloque     ; fin,porque se quita m s de lo que se tiene­
 ok_abajo:
 cmp cs:izquierda,cx
 jle ok_izquierda
 jmp fin_pinta_bloque     ; fin,porque se quita m s de lo que se tiene­
 ok_izquierda:
 cmp cs:derecha,cx
 jle ok_derecha
 jmp fin_pinta_bloque     ; fin,porque se quita m s de lo que se tiene­
 ok_derecha:

 ;Ahora hay que adaptar el ancho y el alto a las dimensiones
 ;que realmente se ver n en la pantalla.
 ;La variable de skip requiere esas transformaciones,al contrario
 ;que todas las operaciones anteriores,que precisaban de las longitudes
 ;reales de los datos dentro del buffer.

 sub cx,cs:izquierda
 sub cx,cs:derecha
 or cx,cx
 jz fin_pinta_bloque

 mov ax,cx       ; AX memoria de CX
 sub dx,cs:arriba
 sub dx,cs:abajo

 ;usaremos BX como variable de skip
 mov bx,320
 sub bx,cx   ; restar el ancho del bloque
 ;
 pinta_linea_clip2:
 add si,cs:izquierda
 mov cx,ax

 situar_puntos_clip2:
 cmp byte ptr ds:[si],0      ; ¨transparente?
 jz transparente_clip2
 movsb            ; pintar el punto
 dec cx           ; uno menos :-)
 jnz situar_puntos_clip2   ; seguir hasta el final de la l¡nea
 jmp linea_pintada_clip2   ; uffffff...por fin acabamos con esa l¡nea­
 transparente_clip2:
 inc si
 inc di
 dec cx
 jnz situar_puntos_clip2

 linea_pintada_clip2:
 add si,cs:derecha
 add di,bx             ; a¤adir el skip
 dec dx                ; una l¡nea menos :-)
 jnz pinta_linea_clip2 ; si a£n quedan,seguir

 ; y llegados a este punto...tach n...tach n...­se acab¢­ :-)))

 fin_pinta_bloque:
 pop ds
 ret

 izquierda  dw 0
 derecha    dw 0
 arriba     dw 0
 abajo      dw 0
pinta_bloque_clip endp

public borra
borra proc pascal segm,offs : word
 ; eax (0) --> es:di (segm,offs)
 mov es,segm
 mov di,offs
 mov cx,16000
 db 66h,33h,0c0h    ; xor eax,eax
 db 0f3h,66h,0abh   ; rep stosd
 ret
borra endp

public espera_rtc
espera_rtc proc pascal
                push dx
                push ax
                mov dx,3DAh
                esperar:
                in al,dx ;leer Input Status Register 1
                test al,00001000B
                jnz esperar
                esperar_retrz:
                in al,dx ;leer I.S.R. 1
                test al,1000B
                jz esperar_retrz
                pop ax
                pop dx
                ret
espera_rtc endp

public set_paleta
set_paleta proc pascal colores,segm,offs : word
                push ds
                mov cx,colores ;cargar n§ de colores
                mov si,cx
                shl cx,1       ; cx = colores * 2
                add cx,si      ; cx=n§ de componentes ( colores * 3 )
                ;
                mov ds,segm ;cargar segmento
                mov si,offs ;cargar offset
                mov dx,3c8h
                mov al,0
                out dx,al
                ;
                mov dx,3c9h

                ;esperar retrazado
                mov bx,dx   ; guardar en BX
                mov di,ax   ; guardar en DI
                mov dx,3DAh
                esperar_rtr:
                in al,dx ;leer Input Status Register 1
                test al,00001000B
                jnz esperar_rtr
                esperar_retrza:
                in al,dx ;leer I.S.R. 1
                test al,1000B
                jz esperar_retrza

                mov dx,bx
                mov ax,di

                db 0f3h,06eh ;rep outsb ;establecer la nueva paleta
                pop ds
                ret
set_paleta endp

public fundido
fundido proc pascal pasadas,segm,offs : word
                push ds
                ;
                mov cx,pasadas ;n§ de pasadas
                mov ds,segm    ;cargar segmento
                ;
                pasada:        ;procesar todos los colores
                mov bx,768     ;bx=componentes por procesar
                mov si,offs    ;leer offset
                proce_col:
                lodsb ;leer un color de la paleta en AL (desde DS:SI)
                or al,al
                jz saltar
                dec al ;decrementar
                db 88h,44h,0ffh ;     mov byte [si-1],al

                saltar:
                dec bx
                jnz proce_col
                call fun_set_pal
                dec cx ;queda una pasada menos
                jnz pasada   ;fin de las pasadas:pantalla en negro
                pop ds
                ret
fundido endp

public fun_set_pal
fun_set_pal proc near
                push si
                push cx ;guardar la cuenta de pasadas
                push dx
                mov si,offs
                mov dx,3c8h
                mov al,0
                out dx,al
                mov dx,3c9h ;puerto de datos
                mov cx,768
                call espera_rtc
                db 0f3h,06eh ;rep outsb ;actualizar el DAC
                pop dx
                pop cx
                pop si
                ret
fun_set_pal endp

public desfundido
desfundido proc pascal pasadas,segm_or,offs_or,segm_dest,offs_dest : word
                int 3
                push ds
                ; ds:si --> origen
                ; es:di --> destino
                mov ds,segm_or    ; cargar segmento origen
                mov es,segm_dest  ; cargar segmento destino
                mov di,offs_dest  ; cargar offset destino
                mov cx,pasadas    ; n£mero de pasadas
                pasar_et1:
                mov bx,768        ; n§ de componentes
                mov si,offs_or    ; cargar offset origen
                mov di,offs_dest  ; cargar offset destino
                decrem:
                mov al,byte ptr [si]        ; cargar componente origen
                cmp al,byte ptr es:[di] ; comparar con byte destino
                jz iguales              ; son iguales:no hacer nada
                jb menor
                ;mayor: ;no igual ni menor --> mayor
                inc byte ptr es:[di]
                jmp iguales
                menor:
                dec byte ptr es:[di]
                iguales:
                inc si                 ; incrementar origen
                inc di                 ; incrementar destino
                dec bx
                jnz decrem             ; seguir con los dem s componentes
                call desfun_set_pal pascal,offs_dest
                dec cx                 ; una pasada menos
                jnz pasar_et1
                pop ds
                ret
desfundido endp

public desfun_set_pal
desfun_set_pal proc pascal offset_dest : word
                push si
                push cx               ; guardar la cuenta de pasadas
                push dx
                mov si,offset_dest
                mov dx,3c8h
                mov al,0
                out dx,al
                mov dx,3c9h           ; puerto de datos
                mov cx,768
                call espera_rtc
                db 0f3h,06eh          ; rep outsb , actualizar el DAC
                pop dx
                pop cx
                pop si
                ret
desfun_set_pal endp

public get_sprite
get_sprite proc pascal x1,y1,x2,y2,segm_or,offs_or,segm_dest,offs_dest : word
                ; (x1,y1,x2,y2,@destino_ptr)
                push ds
                mov ds,segm_or       ;DS=A000h
                mov si,320           ;SI=320
                mov ax,y1            ;AX=Y1
                mul si               ;(DX:) AX=Y1*320
                add ax,x1            ;AX=Y1*320+X1
                mov si,offs_or
                add si,ax            ;SI=Y1*320+X1 + offset_origen
                ;
                mov es,segm_dest     ;esto es inmediato,
                mov di,offs_dest     ;al igual que DI
                ;
                ; ahora hay que calcular los puntos por l¡nea (CX)
                mov cx,x2            ;CX=X2
                sub cx,x1            ;CX=X2-X1
                inc cx               ;CX=puntos por l¡nea
                mov ax,cx            ;por si se nos pierde CX... ;)
                mov es:[di+2],cx
                ;
                ; y la altura (DX)
                mov dx,y2            ;DX=Y2
                sub dx,y1            ;DX=Y2-Y1
                inc dx               ;DX=n£mero de l¡neas
                mov es:[di],dx
                ; crear SKIP en BX y reposicionar DI
                mov bx,320
                sub bx,cx            ;SKIP=320-ancho
                add di,4
                ;
                ; ­vamos all !
                copiar_sprite_g:
                mov cx,ax
                rep movsb         ;copiar l¡nea
                add si,bx         ;recolocar mediante SKIP
                dec dx            ;una l¡nea menos
                jnz copiar_sprite_g
                ;
                pop ds
                ret
get_sprite endp

public pon_letra
pon_letra proc pascal x,y : word,letra : byte , segm_letras,offs_letras,segm_dest,offs_dest : word
 push ds
 ; convertir primero la letra a un n£mero
 ; cl = n£mero (para el bucle)
 xor cx,cx
 mov cl,letra
 cmp cl,'0'
 jz es_el_cero
 jc imposible     ; menor que el 0,imposible
 cmp cl,'9'
 ja es_una_letra
 ; '0' < letra ; '9' > letra ==> es un n£mero
 ;
 ; '1' = 49 ASCII  ,  '1' = 26 (n£mero)
 ;
 sub cl,23
 jmp numero_asignado
 es_una_letra:
 ;
 ; 'A' = 65 ASCII , 'A' = 0 (n£mero)
 ;
 sub cl,65
 jmp numero_asignado

 es_el_cero:
 mov cl,14   ; usar el n£mero de la O

 numero_asignado:
 cmp cl,0
 jc imposible ; n£mero < 0
 cmp cl,34
 ja imposible ; n£mero > 34
 mov ds,segm_letras
 ; ax = suma
 xor ax,ax
 shl cx,1

 sumar:
 or cx,cx
 jz hacer_ultima_suma
 mov si,offs_letras
 add si,cx ; sumar al puntero el numero
 add ax,word ptr [si]
 sub cx,2
 jmp sumar
 hacer_ultima_suma:
 mov si,offs_letras
 add ax,word ptr [si]

 mov si,offs_letras
 add si,ax
 add si,70 ; saltar sobre la cabecera
 ; SI apunta ahora al bloque de la letra

 push x
 push y
 push segm_letras
 push si ; offs_letras
 push segm_dest
 push offs_dest
 call pinta_bloque_clip pascal

 imposible:
 pop ds
 ret
pon_letra endp




code ends
end