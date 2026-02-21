-- TESTE 1: Operações Aritméticas Complexas
-- =============================================================================
-- test1.ada
procedure main is
begin
  x := 10;
  y := 20;
  z := (x + y) * 2 - 5;
  put_line(z);
  
  a := x * y / 2 + 3;
  put_line(a);
  
  b := -x + y - (-z);
  put_line(b);
  
  result := ((x + y) * (z - a)) / (b + 1);
  put_line(result);
end main;