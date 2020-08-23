{$I pcx.pas}
{$I graf.pas}

 var memo_ptr : pointer;
     f : file;
     x1,y1,x2,y2 : integer;
     tamano : array [0..34] of word;

begin
tamano[0] := 0;
tamano[1] := 484;
tamano[2] := 504;
tamano[3] := 504;
tamano[4] := 504;
tamano[5] := 504;
tamano[6] := 504;
tamano[7] := 504;
tamano[8] := 504;
tamano[9] := 164;
tamano[10] := 504;
tamano[11] := 504;
tamano[12] := 532;
tamano[13] := 642;
tamano[14] := 488;
tamano[15] := 484;
tamano[16] := 484;
tamano[17] := 529;
tamano[18] := 464;
tamano[19] := 464;
tamano[20] := 484;
tamano[21] := 464;
tamano[22] := 464;
tamano[23] := 704;
tamano[24] := 484;
tamano[25] := 524;
tamano[26] := 404;
tamano[27] := 284;
tamano[28] := 484;
tamano[29] := 484;
tamano[30] := 484;
tamano[31] := 464;
tamano[32] := 464;
tamano[33] := 484;
tamano[34] := 441;

 assign(f,'cab.dat');
 rewrite(f,1);  { abrir }

 blockwrite(f,tamano,sizeof(tamano));
 close(f);

end.
