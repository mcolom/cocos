{$L graf_asm.obj}

procedure modo13h; external;

procedure modo3; external;

procedure pinta_bloque (x,y : integer ; origen,destino : pointer); external;

procedure pinta_letras (x,y : integer ; origen,destino : pointer); external;

procedure pinta_bloque_clip (x,y : integer;
                             origen,destino : pointer); external;

procedure visualiza (puntero : pointer); external;

procedure copia (origen,destino : pointer); external;

procedure borra (puntero : pointer); external;

procedure set_paleta (colores : word ; puntero : pointer); external;

procedure fundido (pasadas : word ; puntero : pointer); external;

procedure desfundido (pasadas : word ; origen,destino : pointer); external;

procedure get_sprite (x1,y1,x2,y2 : word ; ptr_or,ptr_dest : pointer); external;

procedure pon_letra (x1,y1 : word ; letra : char ; puntero_or,puntero_dest : pointer); external;

PROCEDURE PutColor (color,R,G,B:Byte);assembler;
Asm
  mov  dx,03C8h
  mov  al,[Color]
  out  dx,al
  inc  dx
  mov  al,[R]
  out  dx,al
  mov  al,[G]
  out  dx,al
  mov  al,[B]
  out  dx,al
End;

procedure GetColor(color : byte ; R_ptr,G_ptr,B_ptr : bytePtr);
Begin
  Port[$3C7]:=color;
  R_ptr^:=Port[$3C9];
  G_ptr^:=Port[$3C9];
  B_ptr^:=Port[$3C9];
End;
