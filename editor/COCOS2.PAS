uses crt;

{$I pcx.pas}
{$I graf.pas}

type wordPtr = ^word;

var puntero_ima   : pointer;
    cielo_ptr     : pointer;
    tierra_ptr    : pointer;
    fantasma_ptr  : pointer;              { punteros a los sprites }
    coco_ptr      : pointer;
    comecocos_ptr : pointer;
    bloque_ptr    : pointer;
    punto_ptr     : pointer;

    fondo_ptr     : pointer;

    puntero_letras : wordPtr;

    { variables del juego }
    x_sent,y_sent               : integer;  { sentido }
    cocos                       : word;     { n£mero de cocos en el mapa }

    mapa          : array [0..19,0..19] of byte;

    { deben ser definidas por el usuario }
    mapa_bloque_x_max,mapa_bloque_y_max : word;

         { 0 = tierra }
         { 1 = coco }
         { 2 = bloque }

const
  map_const   : array[0..19,0..19]  { matriz de 20 x 20 }
   of byte =
    (
     (2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),
     (2,0,1,2,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,2),
     (2,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2),
     (2,0,1,2,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,2),
     (2,0,1,2,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2),
     (2,0,1,2,0,0,0,0,0,0,0,0,0,0,0,2,0,1,0,2),
     (2,0,1,2,2,2,2,2,2,0,0,0,2,0,0,2,0,1,0,2),
     (2,0,1,0,0,0,0,0,0,0,0,0,2,0,0,2,0,1,0,2),
     (2,0,1,1,1,1,1,1,1,1,0,0,2,1,0,2,0,1,0,2),
     (2,0,0,0,0,0,0,0,0,0,0,0,2,1,0,2,0,1,0,2),
     (2,0,2,2,2,2,2,2,2,2,2,2,2,1,0,2,0,1,0,2),
     (2,0,2,0,0,0,0,0,1,1,1,1,0,1,0,2,0,1,0,2),
     (2,0,2,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,2),
     (2,0,2,0,1,0,0,0,2,2,0,0,0,1,0,0,0,0,0,2),
     (2,0,2,0,1,0,0,0,0,2,0,0,0,1,1,1,1,1,0,2),
     (2,0,2,0,1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2),
     (2,0,2,0,1,1,1,1,0,2,2,2,2,2,2,0,0,0,0,2),
     (2,0,2,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,2),
     (2,0,1,1,1,1,1,1,0,0,0,0,0,0,2,1,1,1,0,2),
     (2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
    );

 const velocidad : byte = 1;        { velocidad del comecocos (scroll) }



procedure llena_mapa;
 var x,y : byte;
     elemento : byte;
begin
 cocos := 0;
 for x := 0 to mapa_bloque_x_max do
  begin
   for y := 0 to mapa_bloque_y_max do
    begin
     elemento := map_const[y,x];
     if elemento = 1 then cocos := cocos + 1;
     mapa[x,y] := elemento;
    end;
  end;
end;

procedure captura_sprites;
begin

 getmem(fondo_ptr,64100);
 descomprime_pcx('fondo.pcx',fondo_ptr);

 descomprime_pcx('toni.pcx',puntero_ima);
 set_paleta(256,@paleta_pcx);

 getmem(cielo_ptr,700);
 getmem(tierra_ptr,700);
 getmem(fantasma_ptr,700);
 getmem(coco_ptr,700);
 getmem(bloque_ptr,700);
 getmem(comecocos_ptr,700);
 getmem(punto_ptr,20);

 get_sprite(1,1,20,25,puntero_ima,tierra_ptr);
 get_sprite(97,1,116,25,puntero_ima,coco_ptr);
 get_sprite(203,1,222,25,puntero_ima,bloque_ptr);
 get_sprite(250,53,269,77,puntero_ima,cielo_ptr);
 get_sprite(107,54,126,78,puntero_ima,comecocos_ptr);
 get_sprite(0,0,0,0,puntero_ima,punto_ptr);
end;

procedure presenta_sprites;
begin
 pinta_bloque_clip( 120,120,comecocos_ptr,ptr($a000,0));
 pinta_bloque_clip( 100,100,tierra_ptr,ptr($a000,0) );
 pinta_bloque_clip( 150,150,coco_ptr,ptr($a000,0) );
 pinta_bloque_clip( 200,100,bloque_ptr,ptr($a000,0) );
 pinta_bloque_clip( 30,100,cielo_ptr,ptr($a000,0) );
end;

procedure inicializa_letras (accion : boolean);
 var tamano : longint;
     f : file;
begin
 if accion = True then
 begin
  assign(f,'Akane.dat');
  reset(f,1);
  tamano := FileSize(f);
  getMem(puntero_letras,word(tamano+100));
  blockread(f,puntero_letras^,word(tamano));
  close(f);
 end
 else freemem(puntero_letras,tamano+100);
end;

procedure scroll (x,y : integer ; origen_ptr,dest_ptr : pointer);
 var
  contador_x : integer;
  contador_y : integer;
  resto_x    : integer;
  resto_y    : integer;
  bloque_x   : integer;
  bloque_y   : integer;
  puntero_bloque : pointer;

begin
 { calcular los restos }
 asm
  { IDIV --> DX:AX / op1  = AX (cociente) + DX (resto) }
  xor dx,dx
  mov bx,20
  mov ax,x
  cmp ax,0
  jl @x_negativa
  idiv bx
  jmp @fin_division_x
  @x_negativa:
  xor cx,cx
  sub cx,ax { CX = - AX }
  mov ax,cx { AX = - AX    ; el divisor es ahora positivo }
  idiv bx   { realizar la division con positivos }
  xor cx,cx
  sub cx,dx
  mov dx,cx { pasar el resto a positivo }

  @fin_division_x:
  mov bloque_x,ax
  mov resto_x,dx
  xor dx,dx
  mov bx,25
  mov ax,y
  cmp ax,0
  jl @y_negativa
  idiv bx
  jmp @fin_division_y
  @y_negativa:
  xor cx,cx
  sub cx,ax
  mov ax,cx
  idiv bx
  xor cx,cx
  sub cx,dx
  mov dx,cx

  @fin_division_y:
  mov bloque_y,ax
  mov resto_y,dx
 end;

 { empezar por la primera l¡nea }
 for contador_x := 0 to 17 do
 begin
  puntero_bloque := origen_ptr;
  pinta_bloque_clip(contador_x*20-resto_x,-resto_y-y,
                    puntero_bloque,dest_ptr);
 end;
end;


var prueba : integer;
    x,y : integer;
begin
 modo13h;
 mapa_bloque_x_max := 19;
 mapa_bloque_y_max := 19;
 x_sent := velocidad;
 y_sent := 0;
 GetMem(puntero_ima,64100);
{ puntero_ima := ptr($a000,0);}
 captura_sprites;
 llena_mapa;


 for prueba := -300 to 300 do
 begin
  borra(puntero_ima);
  scroll(prueba,0,comecocos_ptr,puntero_ima);
  copia(puntero_ima,ptr($a000,0));
 end;


 readkey;
{ FreeMem(puntero_ima,61000);}
end.
