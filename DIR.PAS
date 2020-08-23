  if (hori < 0) then { va hacia la izquierda }
  begin
   if (
        ( bloque(x+hori+2,y+vert+1+3) <> 2 )    and
        ( bloque(x+hori+2,y+vert+20) <> 2 )      {0,22}
      )
   then x := x + hori;
  end;

  if (hori > 0) then { va hacia la derecha }
  begin
   if (
        ( bloque(x+hori+17,y+vert+1+3) <> 2 )   and
        ( bloque(x+hori+17,y+vert+20) <> 2 )
      )                                                {0,22}
   then x := x + hori;
  end;

  if (vert < 0) then { va hacia arriba }
  begin
   if (
        ( bloque(x+hori+2,y+vert-1+4)  <> 2 )    and
        ( bloque(x+hori+17,y+vert-1+4) <> 2)
      )
   then y := y + vert;
  end;

  if (vert > 0) then { va hacia abajo }
  begin
   if (
        ( bloque(x+hori+2,y+vert+22+1) <> 2 )   and
        ( bloque(x+hori+17,y+vert+22-1) <> 2 )
      )
   then y := y + vert;
  end;
