uses crt;

{$I graf.pas}
{$I pcx.pas}

type Pbyte = ^byte;

var
 tamano_x,tamano_y           : byte;
 bloque_come_x,bloque_come_y : byte;
 numero_fantasmas            : byte;
 mapa_ptr : pointer;
 nombre_fichero : string;

 numero_string        : string;
 code                 : integer;
 integer1,integer2    : integer;
 f : file;
 offset_mapa,segmento_mapa : word;
 factor_separacion : byte;

procedure pon_punto (x,y : word ; valor : byte ; destino_ptr : pointer);
 var
   segm,offs : word;
begin
 segm := seg(destino_ptr^);
 offs := ofs(destino_ptr^);
 mem[segm : offs + 320*y+x] := valor;
end;

procedure encuadra (x,y : byte ; destino_ptr : pointer);
begin
 x := x * factor_separacion;
 y := y * factor_separacion;

 pon_punto(x,y-1,247,destino_ptr);
 pon_punto(x+1,y-1,247,destino_ptr);
 pon_punto(x+2,y,247,destino_ptr);
 pon_punto(x+2,y+1,247,destino_ptr);
 pon_punto(x+1,y+2,247,destino_ptr);
 pon_punto(x,y+2,247,destino_ptr);
 pon_punto(x-1,y+1,247,destino_ptr);
 pon_punto(x-1,y,247,destino_ptr);
end;

procedure desencuadra (x,y : byte ; destino_ptr : pointer);
begin
 x := x * factor_separacion;
 y := y * factor_separacion;

 pon_punto(x,y-1,0,destino_ptr);
 pon_punto(x+1,y-1,0,destino_ptr);
 pon_punto(x+2,y,0,destino_ptr);
 pon_punto(x+2,y+1,0,destino_ptr);
 pon_punto(x+1,y+2,0,destino_ptr);
 pon_punto(x,y+2,0,destino_ptr);
 pon_punto(x-1,y+1,0,destino_ptr);
 pon_punto(x-1,y,0,destino_ptr);
end;


procedure visualiza_bloque (x,y :integer ; valor : byte ; destino_ptr : pointer);
 var color : byte;
begin


 case valor of
  0 : color := 78;             { 0 = tierra    | verde      }
  1 : color := 93;             { 1 = coco      | rojo       }
  2 : color := 247;            { 2 = bloque    | blanco     }
  3 : color := 80;             { 3 = supercoco | azul claro }
  4 : color := 37;             { 4 = calavera  | rosa       }
  5 : color := 53;             { 5 = vida      | amarillo   }
  6 : color := 47;             { 6 = interrog. | lila       }
 end;

 pon_punto(x,y,color,destino_ptr);
 pon_punto(x+1,y,color,destino_ptr);
 pon_punto(x,y+1,color,destino_ptr);
 pon_punto(x+1,y+1,color,destino_ptr);
end;

procedure pon_bloque_mapa (x,y,bloque : byte);
begin
 mem[segmento_mapa : offset_mapa + tamano_x*y+x] := bloque;
end;

function bloque_mapa (x,y : byte) : byte;
begin
 bloque_mapa := mem[segmento_mapa : offset_mapa + tamano_x*y+x];
end;

procedure pon_tablero (destino_ptr : pointer);
 var x,y : byte;
     bloque : byte;
begin
 for x := 0 to tamano_x - 1 do
 begin
  for y := 0 to tamano_y -1 do
  begin
   bloque := bloque_mapa(x,y);
   visualiza_bloque(x*factor_separacion,y*factor_separacion,bloque,destino_ptr);
  end;
 end;
end;

procedure carga_fichero (nombre_local : string);
 var
  f : file;
  tamano_local : word;
  variable_local : integer;

begin
 assign(f,nombre_local);
 reset(f,1);
 blockread(f,tamano_x,1);
 blockread(f,tamano_y,1);
 blockread(f,bloque_come_x,1);
 blockread(f,bloque_come_y,1);
 blockread(f,numero_fantasmas,1);
 blockread(f,mapa_ptr^,tamano_x * tamano_y);
 close(f);
 if tamano_y < 40 then
 begin
  factor_separacion := 4;
  end
 else
  factor_separacion := 3;
end;

function fichero_existe(nombre_f: string): boolean;
var
 F: file;
begin
 {$I-}
 Assign(F, nombre_f);
 Reset(F);
 Close(F);
 {$I+}
 fichero_existe := (IOResult = 0) and (nombre_f <> '');
end;

procedure pon_seleccion (seleccion : byte);
 var
  mi_byte_x,mi_byte_y : byte;
begin
 for mi_byte_y := 0 to 5 do
 begin
  for mi_byte_x := 0 to 5 do
  begin
   visualiza_bloque (250+2*mi_byte_x,100+2*mi_byte_y,seleccion,ptr($a000,0));
  end;
 end;

end;

procedure editar_tablero;
 var
  tecla : char;
  x,y : byte;
  seleccion : byte;
  mover_x,mover_y : shortint;
begin
 seleccion := 2;
 x := 1;
 y := 1;
 mover_x := 1;
 mover_y := 0;

 encuadra(x,y,ptr($a000,0));
 pon_seleccion(seleccion);
 tecla := 'h';
 while tecla <> chr(13) do
 begin
  tecla := readkey;

  if tecla = 'p' then
  begin
    if x < tamano_x - 1 then
    begin
     desencuadra(x,y,ptr($a000,0));
     x := x + 1;
     encuadra(x,y,ptr($a000,0));
     mover_x := 1;
     mover_y := 0;
    end;
  end;

  if tecla = 'o' then
  begin
    if x > 0 then
    begin
     desencuadra(x,y,ptr($a000,0));
     x := x - 1;
     encuadra(x,y,ptr($a000,0));
     mover_x := -1;
     mover_y := 0;
    end;
  end;

  if tecla = 'q' then
  begin
    if y > 0 then
    begin
     desencuadra(x,y,ptr($a000,0));
     y := y - 1;
     encuadra(x,y,ptr($a000,0));
     mover_x := 0;
     mover_y := -1;
    end;
  end;

  if tecla = 'a' then
  begin
    if y < tamano_y - 1 then
    begin
     desencuadra(x,y,ptr($a000,0));
     y := y + 1;
     encuadra(x,y,ptr($a000,0));
     mover_x := 0;
     mover_y := 1;
    end;
  end;

  if tecla = '0' then
  begin
   seleccion := 0;
   pon_seleccion(0);
  end;

  if tecla = '1' then
  begin
   seleccion := 1;
   pon_seleccion(1);
  end;

  if tecla = '2' then
  begin
   seleccion := 2;
   pon_seleccion(2);
  end;

  if tecla = '3' then
  begin
   seleccion := 3;
   pon_seleccion(3);
  end;

  if tecla = '4' then
  begin
   seleccion := 4;
   pon_seleccion(4);
  end;

  if tecla = '5' then
  begin
   seleccion := 5;
   pon_seleccion(5);
  end;

  if tecla = '6' then
  begin
   seleccion := 6;
   pon_seleccion(6);
  end;

  if tecla = '9' then
  begin
   seleccion := 9;
   pon_seleccion(9);
  end;

  if tecla = ' ' then
  begin
   pon_bloque_mapa(x,y,seleccion);
   { visualizar el bloque }
   visualiza_bloque(x*factor_separacion,y*factor_separacion,seleccion,ptr($a000,0));
   { mover }
   desencuadra(x,y,ptr($a000,0));
   if  (x + mover_x > -1) and (x + mover_x < tamano_x - 0) then
   begin
    x := x + mover_x;
   end;
   if (y + mover_y > -1) and (y + mover_y < tamano_y - 0) then
   begin
    y := y + mover_y;
   end;
   encuadra(x,y,ptr($a000,0));
  end;
 end; { while }
desencuadra(x,y,ptr($a000,0));
end;

procedure beep; assembler;
asm
 mov ax,0e07h
 xor bx,bx
 int 10h
end;

procedure situa_comecocos(x_come,y_come : Pbyte);
 var
  tecla : char;
  x,y : byte;
  salir : boolean;
begin
 x := 1;
 y := 1;
 salir := False;

 encuadra(x,y,ptr($a000,0));
 tecla := 'h';
 while salir = False do
 begin
  tecla := readkey;

  if tecla = chr(13) then
  begin
   if bloque_mapa(x,y) <> 2 then salir := True;
  end;

  if tecla = 'p' then
  begin
    if x < tamano_x - 2 then
    begin
     desencuadra(x,y,ptr($a000,0));
     x := x + 1;
     encuadra(x,y,ptr($a000,0));
    end;
  end;

  if tecla = 'o' then
  begin
    if x > 1 then
    begin
     desencuadra(x,y,ptr($a000,0));
     x := x - 1;
     encuadra(x,y,ptr($a000,0));
    end;
  end;

  if tecla = 'q' then
  begin
    if y > 1 then
    begin
     desencuadra(x,y,ptr($a000,0));
     y := y - 1;
     encuadra(x,y,ptr($a000,0));
    end;
  end;

  if tecla = 'a' then
  begin
    if y < tamano_y - 2 then
    begin
     desencuadra(x,y,ptr($a000,0));
     y := y + 1;
     encuadra(x,y,ptr($a000,0));
    end;
  end;

 end; { while }

x_come^ := x;
y_come^ := y;
end;

begin
 FileMode := 2;
 modo3;
 { asignar memoria }
 mapa_ptr := nil;
 getMem(mapa_ptr,40000);
 if mapa_ptr = nil then
  begin
   writeln('Memoria insuficiente');
   halt(1);
  end;

 offset_mapa := ofs(mapa_ptr^);
 segmento_mapa := seg(mapa_ptr^);

 { m ximo 80 x 60 }
 write('Nombre del fichero:');
 readln(nombre_fichero);
 if fichero_existe(nombre_fichero) then
 begin
  carga_fichero(nombre_fichero);
  { esto lo prepara para editar }
 end
 else { el fichero no existe,crear uno nuevo }
 begin
  assign(f,nombre_fichero);
  rewrite(f,1);
  writeln('Fichero ',nombre_fichero, ' creado');
  close(f);

  tamano_x := 100;
  while (tamano_x < 6) or (tamano_x > 80) do
  begin
   write('Tama¤o en X:');
   readln(numero_string);
   val(numero_string,tamano_x,code);
  end;

  tamano_y := 100;
  while (tamano_y < 6) or (tamano_y > 60) do
  begin
   write('Tama¤o en Y:');
   readln(numero_string);
   val(numero_string,tamano_y,code);
  end;
   if tamano_y < 40 then
   begin
    factor_separacion := 4;
   end
   else
    factor_separacion := 3;

  numero_fantasmas := 100;
  while (numero_fantasmas < 0) or (numero_fantasmas > 90) do
  begin
   write('N£mero de fantasmas:');
   readln(numero_string);
   val(numero_string,numero_fantasmas,code);
  end;
  { preparar ahora para editar }
  { primero rellenar el mapa de cocos }
  for integer1 := 0 to tamano_x - 1 do
  begin
   for integer2 := 0 to tamano_y - 1 do
   begin
   pon_bloque_mapa(integer1,integer2,1);
   end;
  end;

  { luego poner bloques en los bordes }
  { zona de arriba }
{  for integer1 := 0 to tamano_x - 1 do
  begin
   mem[segmento_mapa : offset_mapa+integer1] := 2;
  end;
}
  { zona de abajo }
{
  for integer1 := 0 to tamano_x - 1 do
  begin
   mem[segmento_mapa : offset_mapa+tamano_x*(tamano_y-1)+integer1] := 2;
  end;
}
  { izquierda }
{
  for integer2 := 0 to tamano_y - 1 do
  begin
   mem[segmento_mapa : offset_mapa+tamano_x*integer2] := 2;
  end;
}
  { derecha }
{
  for integer2 := 0 to tamano_y - 1 do
  begin
   mem[segmento_mapa : offset_mapa+tamano_x*integer2+tamano_x-1] := 2;
  end;
}
 end;


 modo13h;
 descomprime_pcx('editor.pcx',ptr($a000,0));
 set_paleta(256,@paleta_pcx);

 factor_separacion := 3;
 pon_tablero(ptr($a000,0));

 editar_tablero;
 { ahora hay que colocar el comecocos }
 beep;
 situa_comecocos(@bloque_come_x,@bloque_come_y);
 beep;
 { ya est ! }
 modo3;
 { guardar el fichero }
 assign(f,nombre_fichero);
 reset(f,1);
 blockwrite(f,tamano_x,1);
 blockwrite(f,tamano_y,1);
 blockwrite(f,bloque_come_x,1);
 blockwrite(f,bloque_come_y,1);
 blockwrite(f,numero_fantasmas,1);
 blockwrite(f,mapa_ptr^,tamano_x * tamano_y);
 close(f);

 FreeMem(mapa_ptr,40000);

 writeln('Fin de la coco-edici¢n de ',nombre_fichero);
 writeln;
 writeln('Estad¡stica:');
 writeln;
 writeln('Tama¤o del nivel : (',tamano_x,' x ',tamano_y,')');
 writeln('Localizaci¢n inicial del comecocos : (',bloque_come_x,',',bloque_come_y,')');
 writeln('N£mero de fantasmas : ',numero_fantasmas);
 writeln;
 writeln('Cocoeditor por Miguel Colom (miguelco@ctv.es)');
 writeln;
end.