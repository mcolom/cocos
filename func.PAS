procedure borra_pulsaciones;
begin
 while keypressed do readkey;
end;

procedure intoxica;
begin
 if intoxicado = False then
 begin
  timer_toxico := 333;
  tecla_aba := tecla_arr_ori;
  tecla_arr := tecla_aba_ori;
  tecla_izq := tecla_der_ori;
  tecla_der := tecla_izq_ori;
  intoxicado := True;
 end
 else
  timer_toxico := 333;
end;

procedure desintoxica;
begin
 if intoxicado = True then
 begin
  timer_toxico := 0;
  tecla_aba := tecla_aba_ori;
  tecla_arr := tecla_arr_ori;
  tecla_izq := tecla_izq_ori;
  tecla_der := tecla_der_ori;
  intoxicado := False;
 end;
end;

procedure fan_normales_spr;
 var i : byte;
begin
 for i := 0 to 5 do
 begin
  fan_ptr[i] := fan_nor_ptr[i];
 end;
end;

procedure fan_asustados_spr;
 var i : byte;
begin
 for i := 0 to 5 do
 begin
  fan_ptr[i] := fan_as_ptr[i];
 end;
end;


procedure pon_vidas;
 var i : byte;
begin
 i := vidas - 1;
 while i > 0 do
 begin
   pinta_bloque( (i-1)*20,0,vidas_ptr,puntero_ima );
   i := i - 1;
 end;
end;

procedure inicia_random;
 var word1,word2,bucle : word;
begin
 word1 := mem[$40 : $6c];
 word2 := mem[$40 : $6e];
 word1 := word1 + word2;
 for bucle := 0 to word1 do
 begin
  word2 := random(1000);
 end;
end;

procedure pon_puntos_ref(x,y: word ; destino_ptr : pointer);
begin
 pinta_bloque_clip(x+1,y+1,punto_ptr,destino_ptr);
 pinta_bloque_clip(x+19-1,y+1,punto_ptr,destino_ptr);
 pinta_bloque_clip(x+1,y+24-1,punto_ptr,destino_ptr);
 pinta_bloque_clip(x+19-1,y+24-1,punto_ptr,destino_ptr);
end;

procedure pon_bloque (bloque_x,bloque_y : word ; valor : byte);
begin
 mem[segm_mapa : offs_mapa + tamano_x*bloque_y+bloque_x] := valor;
end;

function bloque (x_local,y_local : word) : byte;
 var bloque_x,bloque_y : word;
     bloque_res : byte;
begin
  if x_local < 0 then
   begin
    bloque_x := trunc(x_local/20);
   end
   else
    asm
     mov ax,x_local
     mov bl,20
     idiv bl
     mov bx,ax
     mov ah,0
     mov bloque_x,ax
    end;

  if y_local < 0 then
   begin
    bloque_y := trunc(y_local/25);
   end
   else
    asm
     mov ax,y_local
     mov bl,25
     idiv bl
     mov bx,ax
     mov ah,0
     mov bloque_y,ax
    end;

{   bloque := mem[segm_mapa : offs_mapa + tamano_x*bloque_y+bloque_x];  }
   asm
    mov bx,offs_mapa
    mov ax,bloque_y
    mov si,bloque_x
    mov dl,tamano_x
    push ds
    mov cx,segm_mapa
    mov ds,cx
    mul dl
    add bx,ax
    add bx,si
    mov al,byte ptr [bx]
    pop ds
    mov bloque_res,al
   end;
 bloque := bloque_res;
end;

procedure cuenta_cocos;
 var var_x,var_y : integer;
begin
 cocos := 0;
 for var_x := 0 to tamano_x - 1 do
 begin
  for var_y := 0 to tamano_y - 1 do
  begin
   if bloque(var_x*20,var_y*25)=1 then cocos := cocos + 1;
  end;
 end;
end;

procedure carga_comecocos_anim;
 var
  come_offs,come_segm : word;
  f : file;
begin
 come_offs := ofs(comecocos_spr^);
 come_segm := seg(comecocos_spr^);

 assign(f,'come.ani');
 reset(f,1);
 { leer primero la paleta }
 blockread(f,paleta,768);
 blockread(f,comecocos_spr^,20160);
 close(f);

 assign(f,'msg.dat');
 reset(f,1);
 blockread(f,over_ptr^,3956+16774+1458);
 close(f);
 deno_ptr := ptr( seg(over_ptr^) , ofs(over_ptr^)+3956 );
 arriba_ptr := ptr( seg(over_ptr^) , ofs(over_ptr^)+3956+16774 );
 abajo_ptr := ptr( seg(over_ptr^) , ofs(over_ptr^)+3956+16774+326 );
 izq_ptr := ptr( seg(over_ptr^) , ofs(over_ptr^)+3956+16774+326+270 );
 derecha_ptr := ptr( seg(over_ptr^) , ofs(over_ptr^)+3956+16774+326+270+480 );


 comecocos_ptr[0,0] := ptr( come_segm , come_offs + 504*0);
 comecocos_ptr[0,1] := ptr( come_segm , come_offs + 504*1);
 comecocos_ptr[0,2] := ptr( come_segm , come_offs + 504*2);
 comecocos_ptr[0,3] := ptr( come_segm , come_offs + 504*3);
 comecocos_ptr[0,4] := ptr( come_segm , come_offs + 504*4);
 comecocos_ptr[0,5] := ptr( come_segm , come_offs + 504*5);

 comecocos_ptr[1,0] := ptr( come_segm , come_offs + 504*6);
 comecocos_ptr[1,1] := ptr( come_segm , come_offs + 504*7);
 comecocos_ptr[1,2] := ptr( come_segm , come_offs + 504*8);
 comecocos_ptr[1,3] := ptr( come_segm , come_offs + 504*9);
 comecocos_ptr[1,4] := ptr( come_segm , come_offs + 504*10);
 comecocos_ptr[1,5] := ptr( come_segm , come_offs + 504*11);

 comecocos_ptr[2,0] := ptr( come_segm , come_offs + 504*12);
 comecocos_ptr[2,1] := ptr( come_segm , come_offs + 504*13);
 comecocos_ptr[2,2] := ptr( come_segm , come_offs + 504*14);
 comecocos_ptr[2,3] := ptr( come_segm , come_offs + 504*15);
 comecocos_ptr[2,4] := ptr( come_segm , come_offs + 504*16);
 comecocos_ptr[2,5] := ptr( come_segm , come_offs + 504*17);

 comecocos_ptr[3,0] := ptr( come_segm , come_offs + 504*18);
 comecocos_ptr[3,1] := ptr( come_segm , come_offs + 504*19);
 comecocos_ptr[3,2] := ptr( come_segm , come_offs + 504*20);
 comecocos_ptr[3,3] := ptr( come_segm , come_offs + 504*21);
 comecocos_ptr[3,4] := ptr( come_segm , come_offs + 504*22);
 comecocos_ptr[3,5] := ptr( come_segm , come_offs + 504*23);

 fan_nor_ptr[0] := ptr( come_segm , come_offs + 504*24);
 fan_nor_ptr[1] := ptr( come_segm , come_offs + 504*25);
 fan_nor_ptr[2] := ptr( come_segm , come_offs + 504*26);
 fan_nor_ptr[3] := ptr( come_segm , come_offs + 504*27);
 fan_nor_ptr[4] := ptr( come_segm , come_offs + 504*28);
 fan_nor_ptr[5] := ptr( come_segm , come_offs + 504*29);

 fan_as_ptr[0] := ptr( come_segm , come_offs + 504*30);
 fan_as_ptr[1] := ptr( come_segm , come_offs + 504*31);
 fan_as_ptr[2] := ptr( come_segm , come_offs + 504*32);
 fan_as_ptr[3] := ptr( come_segm , come_offs + 504*33);
 fan_as_ptr[4] := ptr( come_segm , come_offs + 504*34);
 fan_as_ptr[5] := ptr( come_segm , come_offs + 504*35);

 superc_ptr := ptr( come_segm , come_offs + 504*36);
 interrog_ptr := ptr( come_segm , come_offs + 504*37);
 calav_ptr := ptr( come_segm , come_offs + 504*38);
 vida_ptr := ptr( come_segm , come_offs + 504*39);

 vidas_ptr := ptr( come_segm , come_offs + 504*39);
end;

procedure presenta_sprites;
begin
 pinta_bloque_clip( 50,80,tierra_ptr,ptr($a000,0) );
 pinta_bloque_clip( 80,80,coco_ptr,ptr($a000,0) );
 pinta_bloque_clip( 110,80,bloque_ptr,ptr($a000,0) );
 pinta_bloque_clip( 10,10,punto_ptr,ptr($a000,0) );
end;

procedure carga_nivel(nivel:byte);
 var bloque_come_x,bloque_come_y : byte;
     f : file;
     fichero_local : string;
     numero : string;
     str_nivel : string;
begin
 { construir el nombre de fichero }
 str(nivel,str_nivel);
 if nivel < 1000 then numero := str_nivel;
 if nivel < 100 then numero := '0' + str_nivel;
 if nivel < 10 then numero := '00' + str_nivel;
 fichero_local := '.\niveles\nivel' + numero + '.dat';
 { cargar el nivel }
 assign(f,fichero_local);
 reset(f,1);
 blockread(f,tamano_x,1);
 blockread(f,tamano_y,1);
 bloque_x_max := tamano_x - 1;
 bloque_y_max := tamano_y - 1;
 blockread(f,bloque_come_x,1);
 blockread(f,bloque_come_y,1);
 blockread(f,fantasmas,1);
 blockread(f,mapa_ptr^,tamano_x * tamano_y);
 close(f);

 x := bloque_come_x * 20;
 y := bloque_come_y * 25;
 cuenta_cocos;
end;

procedure carga_bloques(bloques : byte);
 var f : file;
begin
 { cargar los gr ficos de los bloques }
 if bloques <> bloques_en_mem then
 begin
  assign(f,'bloques.dat');
  reset(f,1);
  seek( f,1512*bloques );
  blockread(f,tierra_ptr^,504);
  blockread(f,coco_ptr^,504);
  blockread(f,bloque_ptr^,504);
  close(f);
  bloques_en_mem := bloques;
 end;
end;

procedure pon_scroll (x_,y_ : integer ; destino_ptr : pointer);
 { x_,y_ coordenadas absolutas dentro del mapa }
 var
  mi_x,mi_y : shortint;
  resto_x,resto_y : integer;
  bloque_x,bloque_y : integer;
  bloque : byte;
  mi_x_por_20 , mi_y_por_25 : integer;
begin


 for mi_x := 0 to 16 do
 begin
  for mi_y := 0 to 8 do
  begin

  if x_ < 0 then
   begin
    bloque_x := mi_x + trunc(x_/20);
    resto_x := x_ mod 20;
   end
   else
    asm
     mov ax,x_
     mov bl,20
     idiv bl
     add al,mi_x
     mov bx,ax
     mov ah,0
     mov bloque_x,ax
     mov bl,0
     xchg bh,bl
     mov resto_x,bx
    end;

  if y_ < 0 then
   begin
    bloque_y := mi_y + trunc(y_/25);
    resto_y := y_ mod 25;
   end
   else
    asm
     mov ax,y_
     mov bl,25
     idiv bl
     add al,mi_y
     mov bx,ax
     mov ah,0
     mov bloque_y,ax
     mov bl,0
     xchg bh,bl
     mov resto_y,bx
    end;

{   bloque := mem[segm_mapa : offs_mapa + tamano_x*bloque_y+bloque_x];  }
   asm
    mov bx,offs_mapa
    mov ax,bloque_y
    mov si,bloque_x
    mov dl,tamano_x
    push ds
    mov cx,segm_mapa
    mov ds,cx
    mul dl
    add bx,ax
    add bx,si
    mov al,byte ptr [bx]
    pop ds
    mov bloque,al
   end;

   if (bloque_x >= 0) and (bloque_x <= bloque_x_max) and
      (bloque_y >= 0) and (bloque_y <= bloque_y_max) then

    case bloque of
     0 : pinta_bloque_clip( mi_x*20-resto_x,mi_y*25-resto_y, tierra_ptr , destino_ptr );
     1 : pinta_bloque_clip( mi_x*20-resto_x,mi_y*25-resto_y, coco_ptr , destino_ptr );
     2 : pinta_bloque_clip( mi_x*20-resto_x,mi_y*25-resto_y, bloque_ptr , destino_ptr );
     3 : begin
          mi_x_por_20 := mi_x * 20;
          mi_y_por_25 := mi_y * 25;
          pinta_bloque_clip( mi_x_por_20-resto_x,mi_y_por_25-resto_y, tierra_ptr , destino_ptr );
          pinta_bloque_clip( mi_x_por_20-resto_x,mi_y_por_25-resto_y, superc_ptr , destino_ptr );
         end;
     4 : pinta_bloque_clip( mi_x*20-resto_x,mi_y*25-resto_y, calav_ptr , destino_ptr );
     5 : begin
          mi_x_por_20 := mi_x * 20;
          mi_y_por_25 := mi_y * 25;
          pinta_bloque_clip( mi_x_por_20-resto_x,mi_y_por_25-resto_y, tierra_ptr , destino_ptr );
          pinta_bloque_clip( mi_x_por_20-resto_x,mi_y_por_25-resto_y, vida_ptr , destino_ptr );
         end;
     6 : pinta_bloque_clip( mi_x*20-resto_x,mi_y*25-resto_y, interrog_ptr , destino_ptr );
    end;
  end;
 end;
end;


function obtiene_memoria : boolean;
 var casillas_segm,casillas_offs : word;
begin
 puntero_ima := nil;
 mapa_ptr := nil;
 casillas_spr := nil;
 comecocos_spr := nil;
 over_ptr := nil;

 getmem(comecocos_spr,30000);  { *************** }
 getmem(casillas_spr,504*8+200);
 getmem(over_ptr,30000); { ************* }
 casillas_segm := seg(casillas_spr^);
 casillas_offs := ofs(casillas_spr^);
 tierra_ptr := ptr(casillas_segm,casillas_offs+504*0);
 coco_ptr := ptr(casillas_segm,casillas_offs+504*1);
 bloque_ptr := ptr(casillas_segm,casillas_offs+504*2);
{ getmem(punto_ptr,20);}

 GetMem(puntero_ima,64000);
 GetMem(mapa_ptr,10000);
 segm_mapa := seg(mapa_ptr^);
 offs_mapa := ofs(mapa_ptr^);
 obtiene_memoria := (puntero_ima <> nil)  and
                    (mapa_ptr <> nil)     and
                    (casillas_spr <> nil) and
                    (comecocos_spr <> nil) and
                    (over_ptr <> nil);
end;

procedure libera_memoria;
begin
 if puntero_ima <> nil then FreeMem(puntero_ima,64000);
 if mapa_ptr <> nil then FreeMem(mapa_ptr,10000);
end;

procedure mueve_comecocos_ciclo;
 var
  tecla : char;
begin
  if keypressed then
   begin
    tecla := readkey;
     if tecla = tecla_arr then { q }
                       begin
                        vert := -velocidad;
                        hori := 0;
                        come_dir := 3;
                       end;

     if tecla = tecla_aba then { a }
                       begin
                        vert := velocidad;
                        hori := 0;
                        come_dir := 2;
                       end;

     if tecla = tecla_izq then { o }
                       begin
                        vert := 0;
                        hori := -velocidad;
                        come_dir := 1;
                       end;

     if tecla = tecla_der then { p }
                       begin
                        vert := 0;
                        hori := velocidad;
                        come_dir := 0;
                       end;

{     if tecla = ' ' then
                       begin
                        vert := 0;
                        hori := 0;
                       end;
}

     if tecla = chr(27) then salir := True;

  end;

  { ahora mover el comecocos,pero s¢lo si no se va a chocar contra
    una pared
  }

  if (hori < 0) then { va hacia la izquierda }
  begin
   if (
        ( bloque(x+hori+3,y+vert+5) <> 2 )    and
        ( bloque(x+hori+3,y+vert+20) <> 2 )      {0,22}
      )
   then x := x + hori;
  end;

  if (hori > 0) then { va hacia la derecha }
  begin
   if (
        ( bloque(x+hori+16,y+vert+5) <> 2 )   and
        ( bloque(x+hori+16,y+vert+20) <> 2 )
      )                                                {0,22}
   then x := x + hori;
  end;

  if (vert < 0) then { va hacia arriba }
  begin
   if (
        ( bloque(x+hori+4,y+vert+5)  <> 2 )    and
        ( bloque(x+hori+15,y+vert+5) <> 2)
      )
   then y := y + vert;
  end;

  if (vert > 0) then { va hacia abajo }
  begin
   if (
        ( bloque(x+hori+4,y+vert+23) <> 2 )   and
        ( bloque(x+hori+15,y+vert+23) <> 2 )
      )
   then y := y + vert;
  end;

{  if bloque(x+10,y+12)=1 then mem[segm_mapa : offs_mapa + tamano_x*(trunc(y/25))+(trunc(x/20))] := 92;}
{  mem[segm_mapa : offs_mapa + tamano_x*y+x] := 92;}
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  { pintar el comecocos y las vidas }
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
end;

procedure pon_fantasmas;
 var
  inicio_x,inicio_y : integer;
  i : byte;
begin
 inicio_x := x-x_come_const;
 inicio_y := y-y_come_const;
 for i := 0 to fantasmas -1 do
 begin
  if (fan_x[i] > inicio_x-20) and (fan_y[i] > inicio_y-25) and
     (fan_x[i] < inicio_x+320) and (fan_y[i] < inicio_y+200)
  then
  begin
   pinta_bloque_clip(fan_x[i]-inicio_x,fan_y[i]-inicio_y,fan_ptr[come_ani],puntero_ima);
  end;
 end;
end;

procedure copia_paleta(paleta_origen,paleta_destino : bytePtr);
 var
  origen_offs,origen_segm,destino_offs,destino_segm : word;
  i : integer;
begin
 origen_offs := ofs(paleta_origen^);
 origen_segm := seg(paleta_origen^);
 destino_offs := ofs(paleta_destino^);
 destino_segm := seg(paleta_destino^);
 for i := 0 to 768 do
 begin
  mem[destino_segm : destino_offs + i] := mem[origen_segm : origen_offs + i];
 end;
end;

procedure apaga_luz_ciclo;
 var
  i : integer;
  r,g,b : byte;
begin
 i := 0;
 repeat
  r := paleta_luz[i];
  g := paleta_luz[i+1];
  b := paleta_luz[i+2];
  if r > 2 then r := r - 2;
  if g > 2 then g := g - 2;
  if b > 2 then b := b - 2;
  paleta_luz[i] := r;
  paleta_luz[i+1] := g;
  paleta_luz[i+2] := b;
  i := i + 3;
 until i > 780;
 set_paleta(256,@paleta_luz);
end;
