-- =============================================================================
-- TESTE 20: Calculadora Interativa
-- =============================================================================
-- test_calculator.ada
procedure main is
begin
  x := get_line();
  y := get_line();
  
  sum := x + y;
  diff := x - y;
  prod := x * y;
  
  put_line(sum);
  put_line(diff);
  put_line(prod);
  
  if y /= 0 then
    quot := x / y;
    put_line(quot);
  else
    put_line(0);
  end if;
end main;