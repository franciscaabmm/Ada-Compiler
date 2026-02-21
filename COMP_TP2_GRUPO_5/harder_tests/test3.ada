-- =============================================================================
-- TESTE 3: If-Then-Else Aninhados
-- =============================================================================
-- test3.ada
procedure main is
begin
  x := 15;
  y := 20;
  z := 25;
  
  if x < y then
    if y < z then
      max := z;
      put_line(max);
    else
      max := y;
      put_line(max);
    end if;
  else
    if x < z then
      max := z;
      put_line(max);
    else
      max := x;
      put_line(max);
    end if;
  end if;
  
  put_line(max);
end main;