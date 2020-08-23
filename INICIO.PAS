var
 restar : byte;

procedure pon_casillas_ciclo;
 var mi_x , mi_y : integer;
begin

 for mi_x := 0 to 16 do
 begin
  for mi_y := 0 to 8 do
  begin
   pinta_bloque_clip(mi_x*20-restar,mi_y*25,tierra_ptr,puntero_ima);
  end;
 end;
 inc(restar,1);
 if restar = 20 then restar := 0;
end;

procedure inicia_menu;
 var mi_int : integer;
begin
 restar := 0;
 bloques_en_mem := $f0;
 carga_bloques(0);
 pon_casillas_ciclo;
end;