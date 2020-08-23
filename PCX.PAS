{$L pcx_asm.obj}

type
 cab_type = record
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

 var paleta_pcx : array [0..768] of byte;

procedure descomprime_asm(tamano : word ; origen,destino : pointer); external;

function descomprime_pcx (nombre : string ; destino : pointer) : byte;

 var tamano         : word;
     origen         : pointer;
     F              : FILE;
     cabecera       : cab_type;
     colores        : word;

begin
 { abrir el fichero }
 assign(F,nombre);
 reset(F,1);

 { cargar fichero }
 tamano := filesize(F);
 origen := nil;
 getmem( origen , tamano+500 );  { memoria para el fichero }
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
 descomprime_asm(64000,origen,destino); { descomprimir }
 FreeMem(origen,tamano+500);

 descomprime_pcx := 0;  { sin errores :-) }
end;
