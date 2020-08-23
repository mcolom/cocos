var paleta_pcx : array [0..768] of byte;

procedure descomprime(tamano : word ; origen,destino : pointer);
 var
  offset_origen,segmento_origen,
  offset_destino,segmento_destino : word;
  el_byte : byte;
  repetir : byte;
  ptr_origen : word;
  ptr_destino : word;
  mi_integer : integer;
begin
 ptr_origen := 0;
 ptr_destino := 0;
 offset_origen := ofs(origen^);
 offset_destino := ofs(destino^);
 segmento_origen := seg(origen^);
 segmento_destino := seg(destino^);

 while (tamano > 0) do
 begin
  { coger un byte }
  el_byte := mem[segmento_origen : offset_origen + ptr_origen];
  ptr_origen := ptr_origen + 1;
  if el_byte <= 192 then
   begin { byte directo }
    mem[segmento_destino : offset_destino + ptr_destino] := el_byte;
    ptr_destino := ptr_destino + 1;
    tamano := tamano - 1;
   end
   else
   begin { hay repetici¢n }
    repetir := el_byte and 63;
    el_byte := mem[segmento_origen : offset_origen + ptr_origen];
    ptr_origen := ptr_origen + 1;
    for mi_integer := 1 to repetir do
    begin
     mem[segmento_destino : offset_destino + ptr_destino] := el_byte;
     ptr_destino := ptr_destino + 1;
     tamano := tamano - 1;
    end;
   end;

 end;
end;

function descomprime_pcx (nombre : string ; destino : pointer) : byte;
 var
   tamano         : word;
   origen         : pointer;
   F              : FILE;
   colores        : word;

 cabecera : record
  id             : byte;
  ver            : byte;
  rle            : byte;
  bits_por_pixel : byte;
  x1,y1          : word;
  x2,y2          : word;
  ancho          : word;
  alto           : word;
  paleta         : array[0..47] of byte;
  reservado      : byte;
  planos         : byte;
  bytes_por_lin  : word;
  tipo_paleta    : word;
  reservado2     : array[0..57] of byte;
 end;



begin
 { abrir el fichero }
 assign(F,nombre);
 reset(F,1);

 { cargar fichero }
 tamano := filesize(F);
 origen := nil;
 getmem( origen , tamano+1500 );  { memoria para el fichero }
 if origen = nil then
                     begin
                     close(F);
                     descomprime_pcx := 1;  { error 1 : memoria insuf. }
                     exit;
                     end;

 blockread( F,cabecera,sizeof(cabecera) );           { leer la cabecera }
 blockread( F,origen^,tamano-sizeof(cabecera)-769 ); { leer datos RLE }
 blockread( F,paleta_pcx,1 );                        { leer byte indicador }
 blockread( F,paleta_pcx,768 );                      { leer la paleta }

 for colores := 0 to 767 do paleta_pcx[colores] := paleta_pcx[colores] shr 2;

 close(F); { cerrar el fichero }
 descomprime(64000,origen,destino); { descomprimir }
 FreeMem(origen,tamano+1500);

 descomprime_pcx := 0;  { sin errores :-) }
end;
