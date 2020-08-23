{ MODULO PRINCIPAL }

uses crt;
{$I vars.pas}
{$I graf.pas}
{$I pcx.pas}
{$I func.pas}
{$I fan.pas}

procedure ver_final;
begin
end;

procedure game_over;
begin
end;

procedure siguiente_nivel;
begin
 fan_normales_spr;
 carga_bloques(4);
 come_ani := 0;
 come_dir := 0;
 borra(puntero_ima);
 pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
 coloca_fantasmas;
 pon_fantasmas;
 pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
 pon_vidas;
 visualiza(puntero_ima);
 desfundido(63,@paleta,@paleta_luz);
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
  come_ani := come_ani + 1;
  if come_ani = 6 then come_ani := 0;
  come_dir := come_dir + 1;
  if come_dir = 4 then come_dir := 0;
  pon_vidas;
  visualiza(puntero_ima);
  apaga_luz_ciclo;
 end;
 x := guarda_x;
 y := guarda_y;
 come_ani := 0;
 come_dir := 0;
 borra(puntero_ima);
 pon_scroll(x-x_come_const,y-y_come_const,puntero_ima);
 coloca_fantasmas;
 pon_fantasmas;
 pinta_bloque(x_come_const,y_come_const,comecocos_ptr[come_dir,come_ani],puntero_ima);
 pon_vidas;
 visualiza(puntero_ima);
 desfundido(63,@paleta,@paleta_luz);
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
  come_ani := come_ani + 1;
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
  come_ani := come_ani + 1;
  if come_ani = 6 then come_ani := 0;
  pon_vidas;
  visualiza(puntero_ima);
  apaga_luz_ciclo;
 end;
end;

procedure juega_nivel;
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
 repeat
  mueve_comecocos_ciclo;
  mueve_fantasmas_ciclo;
  pon_fantasmas;
  come_ani := come_ani + 1;
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
         vidas := vidas - 1;
         escenifica_muerte;    { esto apaga la luz }
        end;
   5 :
       begin                 { vida }
        pon_bloque( trunc((x+4)/20),trunc((y+12)/25) , 0);
        vidas := vidas + 1;
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
{ carga_nivel(nivel,1);}
 guarda_x := x;
 guarda_y := y;
{ fantasmas := 5;  { *************** }
 coloca_fantasmas;
 vidas := 9;

 repeat
  juega_nivel;
  if (cocos = 0) then
   begin
    escenifica_conseguido;
    nivel := nivel + 1;
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

var mi_var : byte;
    bloq : byte;
    niv : byte;
    code : integer;

begin
 if paramcount = 2 then
 begin
 inicia_random;
 modo13h;
 if not obtiene_memoria then
 begin
  modo3;
  writeln('Memoria insuficiente');
  writeln;
  halt;
 end;
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

{ juega_juego;}
 val(paramstr(1),niv,code);
 val(paramstr(2),bloq,code);

 carga_nivel(niv);
 carga_bloques(bloq);

 for mi_var := 0 to 3 do
 begin
  coloca_fantasmas;
  vidas := 3;
  juega_nivel;
 end;


 libera_memoria;
 modo3;
 end
 else
 begin
  writeln('Juega <nivel> <bloques>');
 end;
end.
