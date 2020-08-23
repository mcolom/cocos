uses crt;

{$I pcx.pas}
{$I graf.pas}

 var memo_ptr : pointer;
     f : file;
     x1,y1,x2,y2,tamano : integer;
     f2 : file;

procedure capturar (x1,y1,x2,y2 : word ; origen_ptr : pointer);
begin
 tamano := (x2-x1+1) * (y2-y1+1) + 4;
 get_sprite(x1,y1,x2,y2,ptr($a000,0),memo_ptr);
 pinta_bloque_clip(140,140,memo_ptr,ptr($a000,0));
end;

procedure mete_sprites;
 var foto : byte;
begin
 foto := 0;
 capturar(1+21*foto,1,21*foto+20,25,ptr($a000,0));
 blockwrite(f2,memo_ptr^,tamano);

 foto := 1;
 capturar(1+21*foto,1,21*foto+20,25,ptr($a000,0));
 blockwrite(f2,memo_ptr^,tamano);

 foto := 2;
 capturar(1+21*foto,1,21*foto+20,25,ptr($a000,0));
 blockwrite(f2,memo_ptr^,tamano);
end;

begin
 if (paramcount = 1) then
 begin
  modo13h;
  getmem(memo_ptr,20000);
  descomprime_pcx(paramstr(1),ptr($a000,0));

  assign(f2,'..\bloques.dat');
  reset(f2,1);
  seek(f2,filesize(f2)); { puntero al final }
  mete_sprites;
  close(f2);
  modo3;
 end
 else
 begin
  writeln;
  writeln('Haz <nombre_del_pcx>');
 end;

end.