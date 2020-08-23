{$L graf_asm.obj}

procedure modo13h; external;

procedure modo3; external;

procedure pinta_bloque (x,y : integer ; origen,destino : pointer); external;

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

{procedure pon_scroll (x_total,y_total,bloques_x,bloques_y : integer ; mapa_ptr,dest_ptr : pointer ); external;}