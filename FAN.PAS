const
 IZQUIERDA = 0;
 DERECHA = 1;
 ARRIBA = 2;
 ABAJO = 3;

type
 punto = record
 x,y : integer;
end;

procedure coloca_fantasmas;
 var
  mi_x,mi_y : integer;
  total_validas : integer;
  coord_xy_ok : array[0..3000] of punto;
  ultima_dir_local : array[0..3000] of byte;
  i : integer;
  seleccion : integer;
begin
 total_validas := 0;
 {
  calcular primero las coordenadas (casillas) v�lidas para colocar
  un fantasma
 }
 for mi_x := 1 to bloque_x_max - 1 do
 begin
  for mi_y := 1 to bloque_y_max - 1 do
  begin
   if ( (bloque(mi_x*20,mi_y*25)=0) or (bloque(mi_x*20,mi_y*25)=1) ) and
        (mi_x*20 <> x) and (mi_y*25 <> y)
   then  { �tierraaaa�� X-DDD }
   begin
    if (bloque((mi_x-1)*20,mi_y*25) = 0) or
       (bloque((mi_x-1)*20,mi_y*25) = 1)
    then { tierra a la izquierda }
    begin
     coord_xy_ok[total_validas].x := mi_x*20;
     coord_xy_ok[total_validas].y := mi_y*25;
     ultima_dir_local[total_validas] := IZQUIERDA;
     total_validas := total_validas + 1;
    end;
    if (bloque((mi_x+1)*20,mi_y*25) = 0) or
       (bloque((mi_x+1)*20,mi_y*25) = 1)
    then { tierra a la derecha }
    begin
     coord_xy_ok[total_validas].x := mi_x*20;
     coord_xy_ok[total_validas].y := mi_y*25;
     ultima_dir_local[total_validas] := DERECHA;
     total_validas := total_validas + 1;
    end;
    if (bloque(mi_x*20,(mi_y-1)*25) = 0) or
       (bloque(mi_x*20,(mi_y-1)*25) = 1)
    then { tierra arriba }
    begin
     coord_xy_ok[total_validas].x := mi_x*20;
     coord_xy_ok[total_validas].y := mi_y*25;
     ultima_dir_local[total_validas] := ARRIBA;
     total_validas := total_validas + 1;
    end;
    if (bloque(mi_x*20,(mi_y+1)*25) = 0) or
       (bloque(mi_x*20,(mi_y+1)*25) = 1)
    then { tierra abajo }
    begin
     coord_xy_ok[total_validas].x := mi_x*20;
     coord_xy_ok[total_validas].y := mi_y*25;
     ultima_dir_local[total_validas] := ABAJO;
     total_validas := total_validas + 1;
    end;
   end;
  end;
 end;

 if total_validas < fantasmas then
 begin
  libera_memoria;
  modo3;
  writeln('Whopsa�...no hay sitio donde meter los fantasmas���');
  halt;
 end;

 {
  ahora que ya tenemos las casillas v�lidas,hay que elegir
  tantas como fantasmas tengamos
 }
 for i := 0 to fantasmas - 1 do
 begin
  seleccion := random(total_validas);
  fan_x[i] := coord_xy_ok[seleccion].x;
  fan_y[i] := coord_xy_ok[seleccion].y;
  fan_dir[i] := ultima_dir_local[seleccion];
  if (fan_dir[i] = ARRIBA) or (fan_dir[i] = ABAJO) then
  begin
   fan_falta[i] := 25;
  end
  else
  begin
   fan_falta[i] := 20;
  end;
 end;
end;

function numero_posibles (i : byte) : byte;
 var
  posibles : byte;
begin
 posibles := 0;
 { probar hacia la izquierda }
 if bloque(fan_x[i]-10,fan_y[i]+10)<>2 then inc(posibles);
 { probar hacia la derecha }
 if bloque(fan_x[i]+25,fan_y[i]+10)<>2 then inc(posibles);
 { probar hacia abajo }
 if bloque(fan_x[i]+10,fan_y[i]+35)<>2 then inc(posibles);
 { probar hacia arriba }
 if bloque(fan_x[i]+10,fan_y[i]-10)<>2 then inc(posibles);

 numero_posibles := posibles;
end;

function en_bloque (dir,i : byte) : boolean;
 var
  resultado : boolean;
begin
 resultado := False;
 case dir of
  ARRIBA    : begin
   if bloque(fan_x[i]+10,fan_y[i]-10)=2 then resultado := True;
              end;
  ABAJO     : begin
   if bloque(fan_x[i]+10,fan_y[i]+35)=2 then resultado := True;
              end;
  DERECHA   : begin
   if bloque(fan_x[i]+25,fan_y[i]+10)=2 then resultado := True;
              end;
  IZQUIERDA : begin
   if bloque(fan_x[i]-10,fan_y[i]+10)=2 then resultado := True;
              end;
 end;
 en_bloque := resultado;
end;

function comecocos_cazado : boolean;
var i : integer;
    resultado : boolean;
begin
 resultado := False;
 for i := 0 to fantasmas - 1 do
 begin
  if ( abs(fan_x[i]-x) < 15 ) and ( abs(fan_y[i]-y) < 20 ) then
    resultado := True;
 end;
 comecocos_cazado := resultado;
end;

procedure mueve_fantasmas_ciclo;
 var
  i : byte;
  nueva_dir : byte;
  sal : boolean;
  pos : byte;
begin
 for i := 0 to fantasmas - 1 do
 begin
  if fan_falta[i] > 0 then
  begin
   if fan_dir[i] = ARRIBA then
   begin
    fan_y[i] := fan_y[i] - velocidad_fan;
    fan_falta[i] := fan_falta[i] - velocidad_fan;
   end;
   if fan_dir[i] = ABAJO then
   begin
    fan_y[i] := fan_y[i] + velocidad_fan;
    fan_falta[i] := fan_falta[i] - velocidad_fan;
   end;
   if fan_dir[i] = DERECHA then
   begin
    fan_x[i] := fan_x[i] + velocidad_fan;
    fan_falta[i] := fan_falta[i] - velocidad_fan;
   end;
   if fan_dir[i] = IZQUIERDA then
   begin
    fan_x[i] := fan_x[i] - velocidad_fan;
    fan_falta[i] := fan_falta[i] - velocidad_fan;
   end;
 end
 else  { a uno de nuestros "bixos" se le acab� el...combustible X-DD }
  begin
  pos := numero_posibles(i);

  if (pos = 1) then   { callej�n sin salida,volver }
   begin
    case fan_dir[i] of
     ARRIBA    : begin fan_falta[i] := 25; fan_dir[i] := ABAJO; end;
     ABAJO     : begin fan_falta[i] := 25; fan_dir[i] := ARRIBA; end;
     DERECHA   : begin fan_falta[i] := 20; fan_dir[i] := IZQUIERDA; end;
     IZQUIERDA : begin fan_falta[i] := 20; fan_dir[i] := DERECHA; end;
   end;
  end
  else
   begin
    {
     asignarle cualquier sentido,siempre que no sea el contrario al que
     lleva o le conduzca hacia un bloque
    }
    repeat
     sal := True;
     nueva_dir := random(4);
     if ( en_bloque(nueva_dir,i) ) then
      begin sal := False; end
      else
       case fan_dir[i] of
        ARRIBA    : if nueva_dir = ABAJO then sal := False;
        ABAJO     : if nueva_dir = ARRIBA then sal := False;
        DERECHA   : if nueva_dir = IZQUIERDA then sal := False;
        IZQUIERDA : if nueva_dir = DERECHA then sal := False;
      end;
    until sal;

    { modo...inteligente X-D }

    if not inmune then
    case random(2) of
    0:
     begin
      if ( (fan_x[i] < x) and (not en_bloque(DERECHA,i)) ) then nueva_dir := DERECHA;
      if ( (fan_x[i] > x) and (not en_bloque(IZQUIERDA,i)) ) then nueva_dir := IZQUIERDA;
      if ( (fan_y[i] > y) and (not en_bloque(ARRIBA,i)) ) then nueva_dir := ARRIBA;
      if ( (fan_y[i] < y) and (not en_bloque(ABAJO,i)) ) then nueva_dir := ABAJO;
     end;
    1:
     begin
      if ( (fan_y[i] > y) and (not en_bloque(ARRIBA,i)) ) then nueva_dir := ARRIBA;
      if ( (fan_y[i] < y) and (not en_bloque(ABAJO,i)) ) then nueva_dir := ABAJO;
      if ( (fan_x[i] < x) and (not en_bloque(DERECHA,i)) ) then nueva_dir := DERECHA;
      if ( (fan_x[i] > x) and (not en_bloque(IZQUIERDA,i)) ) then nueva_dir := IZQUIERDA;
     end;
    end;




    fan_dir[i] := nueva_dir;
    case fan_dir[i] of
     ARRIBA    : fan_falta[i] := 25;
     ABAJO     : fan_falta[i] := 25;  { recargar }
     DERECHA   : fan_falta[i] := 20;
     IZQUIERDA : fan_falta[i] := 20;
    end;
   end;

  end; { if posibles }
  end; { if principal }
end;
