{ Programa para quitar sprites de 20x25 }

var f : file;
    bloques : byte;
    code : integer;

begin
 if paramCount <> 2 then
  begin
   writeln('Quitar <fichero.ani> <n£mero de bloques desde el final>');
  end
  else
  begin
   val( ParamStr(2),bloques,code );
   assign( f,ParamStr(1) );
   reset (f,1);
   seek(f, FileSize(f)-bloques*(20*25+4) );
   truncate(f);
   close(f);
   writeln('Fichero ',ParamStr(1),' truncado');
   writeln;
  end;
end.