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
 capturar(215,69,268,75,ptr($a000,0));
 blockwrite(f2,memo_ptr^,tamano);
end;

begin
  modo13h;
  getmem(memo_ptr,20000);
  descomprime_pcx('teclas.pcx',ptr($a000,0));

  assign(f2,'derecha.ani');
  rewrite(f2,1);
  mete_sprites;
  close(f2);
  modo3;
end.