{$I pcx.pas}
{$I graf.pas}

 var memo_ptr : pointer;
     f : file;
     x1,y1,x2,y2,tamano : integer;

begin
 x1 := 43;
 y1 := 100;
 x2 := 78;
 y2 := 120;

 tamano := (x2-x1+1) * (y2-y1+1) + 4;

 modo13h;
 getmem(memo_ptr,20000);
 descomprime_pcx('editor.pcx',ptr($a000,0));

 assign(f,'coco.gra');
 rewrite(f,1);  { abrir }

 get_sprite(x1,y1,x2,y2,ptr($a000,0),memo_ptr);
 blockwrite(f,memo_ptr^,tamano);
 pinta_bloque_clip(140,140,memo_ptr,ptr($a000,0));

 close(f);

end.