-- TEST 6: test_input.ada
-- Leitura de input
-- ============================================
procedure main is
begin
  x := get_line();
  y := get_line();
  z := x + y;
  put_line(z);
end main;