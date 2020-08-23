var
 sb_base : word;
 canal_dma : byte;

procedure espera_100ms;
 var mi_var : word;
begin
 for mi_var := 0 to 50000 do;
end;

procedure escribe_DSP (b: byte);
begin
 while port[sb_base+$c] >= 128 do;
 port[sb_base+$c] := b;
end;

function lee_DSP : byte;
begin
 while port[sb_base+$a] = $aa do;
 lee_DSP := port[sb_base+$a];
end;

function version_sb : string;
 var mayor,menor : byte;
     may_str,men_str : string;
begin
 escribe_DSP($E1);
 mayor := lee_dsp;
 menor := lee_dsp;
 str(mayor,may_str);
 str(menor,men_str);
 version_sb := may_str+'.'+men_str;
end;

procedure reset_sb;
begin
end;

procedure reproduce_bloque(bloque_ptr : pointer ; tamano : word);
 var
  fispos  : longint;
  pagina : word;
  offset : word;
begin
 fispos := seg(bloque_ptr^);
 fispos := fispos * 16;
 fispos := fispos + ofs(bloque_ptr^);
 pagina := word ( (fispos and $ffff0000) shr 16);
 offset := word ( fispos and $0000ffff );
end;

procedure detecta_sb;
 var detectada : boolean;
begin
 detectada := False;
 sb_base := $200;
 repeat
  inc(sb_base,$10);
  port[sb_base + 6] := 1;
  espera_100ms;
  port[sb_base + 6] := 0;
  espera_100ms;
  detectada := ( port[sb_base + $e] = 0 );
  detectada := ( port[sb_base + $a] = $aa );
 until (sb_base > $280) or detectada;
 if not detectada then sb_base := 0;
end;

begin
 writeln;
 detecta_sb;
 writeln(sb_base);
 writeln(version_sb);

 reproduce_bloque(ptr($2234,$1678),1234);
end.