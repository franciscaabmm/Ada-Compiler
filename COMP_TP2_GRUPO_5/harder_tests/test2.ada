-- =============================================================================
-- TESTE 2: Expressões Booleanas Complexas
-- =============================================================================
-- test2.ada
procedure main is
begin
  x := 10;
  y := 20;
  z := 15;
  
  -- Comparações simples
  flag1 := x < y;
  put_line(flag1);
  
  flag2 := x >= z;
  put_line(flag2);
  
  -- Operadores lógicos compostos
  flag3 := (x < y) and (y > z);
  put_line(flag3);
  
  flag4 := (x = 10) or (y /= 20);
  put_line(flag4);
  
  flag5 := not (x > y);
  put_line(flag5);
  
  -- Expressão complexa
  complex := ((x < y) and (z <= y)) or not (x >= z);
  put_line(complex);
end main;
