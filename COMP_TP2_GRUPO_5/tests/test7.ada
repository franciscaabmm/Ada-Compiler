-- TEST 7: test_boolean.ada
-- Operações booleanas
-- ============================================
procedure main is
begin
  x := 10;
  y := 20;
  b := x < y;
  if b then
    put_line(1);
  else
    put_line(0);
  end if;
end main;