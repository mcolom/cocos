{ MODULO PRINCIPAL }

uses crt;
{$I vars.pas}
{$I graf.pas}
{$I pcx.pas}
{$I func.pas}
{$I fan.pas}
{$I inicio.pas}

procedure ver_final;
begin
end;

procedure game_over;
 var i : byte;
begin
 copia_paleta(@paleta,@paleta_luz);
 for i := 0 to 32 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  inc(come_dir);
  if come_dir = 4 then come_dir := 0;
  visualiza(puntero_ima);
 end;
 for i := 0 to 32 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  inc(come_dir);
  if come_dir = 4 then come_dir := 0;
  pinta_letras(60,80,over_ptr,puntero_ima);
  visualiza(puntero_ima);
 end;
 for i := 0 to 32 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  inc(come_dir);
  if come_dir = 4 then come_dir := 0;
  pinta_letras(60,80,over_ptr,puntero_ima);
  visualiza(puntero_ima);
  apaga_luz_ciclo;
 end;
end;

procedure siguiente_nivel;
begin
 fan_normales_spr;
 carga_nivel(nivel);
 if (nivel mod 9) = 0 then
 begin
  carga_bloques(bloques_en_mem+1);
  inc(bloques_en_mem);
 end;

{carga_bloques(random(6));}
 come_ani := 0;
 come_dir := 0;
 borra(puntero_ima);
 pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
 coloca_fantasmas;
 pon_fantasmas;
 pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
 pon_vidas;
 visualiza(puntero_ima);
end;

procedure escenifica_muerte;
 var i : byte;
begin
 copia_paleta(@paleta,@paleta_luz);
 for i := 0 to 32 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  inc(come_dir);
  if come_dir = 4 then come_dir := 0;
  pon_vidas;
  visualiza(puntero_ima);
  apaga_luz_ciclo;
 end;
{ x := guarda_x;
 y := guarda_y;
}
 x := round ( x/20 ) * 20;
 y := round ( y/25 ) * 25;
 if ( bloque(x,y) = 2 ) then
 begin
  if bloque( round ( x/20 ) * 20 , round ( (y-1)/25 ) * 25 ) <> 2 then dec(y,25);
  if bloque( round ( x/20 ) * 20 , round ( (y+1)/25 ) * 25 ) <> 2 then inc(y,25);
  if bloque( round ( (x+1)/20 ) * 20 , round ( y/25 ) * 25 ) <> 2 then inc(x,20);
  if bloque( round ( (x-1)/20 ) * 20 , round ( y/25 ) * 25 ) <> 2 then dec(x,20);
 end;

 come_ani := 0;
 come_dir := 0;
 hori := 0;
 vert := 0;
 desintoxica;
end;

procedure escenifica_conseguido;
 var i : byte;
begin
 copia_paleta(@paleta,@paleta_luz);
 for i := 0 to 10 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_comecocos_ciclo;
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  pon_vidas;
  visualiza(puntero_ima);
{  apaga_luz_ciclo;}
 end;
 for i := 0 to 32 do
 begin
  borra(puntero_ima);
  pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
  pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
  mueve_comecocos_ciclo;
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  pon_vidas;
  visualiza(puntero_ima);
  apaga_luz_ciclo;
 end;
end;

procedure juega_nivel;
label 1;
var mi_rand : byte;
begin
 hori := 0;
 vert := 0;
 come_ani := 0;
 come_dir := 0;
 fan_normales_spr;
 inmune := False;
 salir := False;
 timer_scoco := 0;
 desintoxica;
 borra(puntero_ima);
 pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
 coloca_fantasmas;
 pon_fantasmas;
 pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
 pon_vidas;
 visualiza(puntero_ima);
 desfundido(63,@paleta,@paleta_luz);
 repeat
  mueve_comecocos_ciclo;
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  pon_vidas;
  visualiza(puntero_ima);

  case bloque(x+4,y+12) of { acaba de pasar por ... }
   1 :
       begin                 { coco }
        pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
        cocos := cocos - 1;
       end;
   3 :
       begin                 { supercoco }
        pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
        inmune := True;
        timer_scoco := 600;
        fan_asustados_spr;
        desintoxica;
       end;
   4 :
       if not inmune then      { calavera }
        begin
         pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
         salir := True;
        end;
   5 :
       begin                 { vida }
        pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
        inc(vidas);
       end;
   6 :
       begin                 { interrogante }
        mi_rand := random(5);
        case mi_rand of
          0 :       { vida }
              begin
               pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 5);
              end;
          1 :       { muerte }
              begin
               pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 4);
              end;
          2 :       { intoxicaci¢n et¡lica }
              begin
               pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
               intoxica;
              end;
          3 :       { supercoco }
              begin
               pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 3);
              end;
        end;
       end;
  end;

  if timer_toxico <> 0 then  { intoxicado }
  begin
   timer_toxico := timer_toxico - 1;
   if timer_toxico = 0 then
   begin
    desintoxica;
   end;
  end;

  if timer_scoco <> 0 then   { en estado de inmunidad }
  begin
   timer_scoco := timer_scoco - 1;
   if timer_scoco < 80 then
   begin
    case (timer_scoco mod 2) of
     0 : fan_normales_spr;
     1 : fan_asustados_spr;
    end;
   end;
   if timer_scoco = 0 then
   begin
    inmune := False;
    fan_normales_spr;
   end;
  end;


  if comecocos_cazado then if not inmune then salir := True;
 until (cocos = 0) or (salir = True);
end;

procedure juega_juego;
{ var
  guarda_x,guarda_y : word;}
begin
 juego_acabado := False;
 nivel := 0;
 carga_nivel(nivel);
 carga_bloques(0);
 guarda_x := x;
 guarda_y := y;
 coloca_fantasmas;
 vidas := 3;

 repeat
  juega_nivel;
  if (cocos = 0) then
   begin
    escenifica_conseguido;
    inc(nivel);
    if nivel = pantallas then
    begin
     juego_acabado := True;
     vidas := 0;
    end
    else
    begin
    siguiente_nivel;
    guarda_x := x;
    guarda_y := y;
    end;
   end
   else
   begin
    vidas := vidas - 1;
    if vidas <> 0 then
    begin
     escenifica_muerte;    { esto apaga la luz }
    end;
   end;
 until vidas = 0;
 if juego_acabado then
 begin
  ver_final;
 end
 else
 begin
  game_over;
 end;
end;

procedure redefine;
 label 1,2,3,4;
 var tecla : char;
     mi_var : shortint;
begin
 borra_pulsaciones;
 come_ani := 0;
 mi_var := -16;
 borra_pulsaciones;
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_bloque_clip(mi_var,150,comecocos_ptr[0,come_ani],puntero_ima);
  visualiza(puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  inc(mi_var,2);
 until (keypressed) or (mi_var = 10);

 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_letras(130,150,derecha_ptr,puntero_ima);
  pinta_bloque(10,150,comecocos_ptr[0,come_ani],puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  visualiza(puntero_ima);
 until keypressed;
 tecla_der := readkey;
 borra_pulsaciones;
 2:
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_letras(130,150,izq_ptr,puntero_ima);
  pinta_bloque(10,150,comecocos_ptr[1,come_ani],puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  visualiza(puntero_ima);
 until keypressed;
 tecla_izq := readkey;
 borra_pulsaciones;
 if tecla_izq=tecla_der then goto 2;
 3:
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_letras(130,150,arriba_ptr,puntero_ima);
  pinta_bloque(10,150,comecocos_ptr[3,come_ani],puntero_ima);
  visualiza(puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
 until keypressed;
 tecla_arr := readkey;
 borra_pulsaciones;
 if (tecla_arr=tecla_der) or (tecla_arr=tecla_izq) then goto 3;
 4:
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_letras(130,150,abajo_ptr,puntero_ima);
  pinta_bloque(10,150,comecocos_ptr[2,come_ani],puntero_ima);
  visualiza(puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
 until keypressed;
 tecla_aba := readkey;
 borra_pulsaciones;
 if (tecla_aba=tecla_der) or (tecla_aba=tecla_izq) or (tecla_aba=tecla_arr) or (tecla_arr=tecla_izq) then goto 4;
 mi_var := 10;
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  pinta_bloque_clip(mi_var,150,comecocos_ptr[1,come_ani],puntero_ima);
  visualiza(puntero_ima);
  inc(come_ani);
  if come_ani = 6 then come_ani := 0;
  dec(mi_var,2);
 until (keypressed) or (mi_var < -16);
 borra_pulsaciones;
 tecla_der_ori := tecla_der;
 tecla_izq_ori := tecla_izq;
 tecla_arr_ori := tecla_arr;
 tecla_aba_ori := tecla_aba;
end;


var
 tecla : char;
 salir_al_dos : boolean;

begin
 { desactivar CTRL-BREAK }
 asm
  mov ah,$33
  mov al,1
  mov dl,0
  int $21
 end;

 inicia_random;
 modo13h;
 if not obtiene_memoria then
 begin
  modo3;
  writeln('Memoria insuficiente');
  writeln;
  halt;
 end;
 salir_al_dos := False;

 tecla_der_ori := 'p';
 tecla_izq_ori := 'o';
 tecla_arr_ori := 'q';
 tecla_aba_ori := 'a';

 tecla_der := tecla_der_ori;
 tecla_izq := tecla_izq_ori;
 tecla_arr := tecla_arr_ori;
 tecla_aba := tecla_aba_ori;

 carga_comecocos_anim;

 set_paleta(256,@paleta);

 salir := False;
 inicia_menu;

 borra_pulsaciones;
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  visualiza(puntero_ima);
  if keypressed then
  begin
   tecla := readkey;
   borra_pulsaciones;
   case tecla of
    '1' :
         begin
          copia_paleta(@paleta,@paleta_luz);
          mi_integer := 0;
          repeat
           pon_casillas_ciclo;
           pinta_letras(60,30,deno_ptr,puntero_ima);
           visualiza(puntero_ima);
           apaga_luz_ciclo;
           inc(mi_integer,1);
          until (mi_integer=32);
          juega_juego;
          mi_integer := 0;
          carga_bloques(0);
          borra_pulsaciones;
          repeat
           pon_casillas_ciclo;
           pinta_letras(60,30,deno_ptr,puntero_ima);
           visualiza(puntero_ima);
           desfundido(2,@paleta,@paleta_luz);
           inc(mi_integer);
          until (mi_integer=31) or (keypressed);
          set_paleta(256,@paleta);
          borra_pulsaciones;
         end;
    '2' : redefine;
    '3' : salir_al_dos := True;
   end;
  end;
 until salir_al_dos;

 copia_paleta(@paleta,@paleta_luz);
 mi_integer := 0;
 repeat
  pon_casillas_ciclo;
  pinta_letras(60,30,deno_ptr,puntero_ima);
  visualiza(puntero_ima);
  apaga_luz_ciclo;
  inc(mi_integer,1);
 until (mi_integer=32);

 libera_memoria;
 modo3;
 writeln('"Almudeno,el gran devorador de cocos"');
 writeln('           -- freeware --');
 writeln;
 writeln('Dedicado a Almu ;)');
 writeln;
end.
