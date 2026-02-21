-- =============================================================================
-- TESTE 13: Inversão de Número
-- =============================================================================
-- test_reverse_number.ada
procedure main is
begin
  n := 12345;
  reversed := 0;
  
  while n > 0 loop
    digit := n - (n / 10) * 10;
    reversed := reversed * 10 + digit;
    n := n / 10;
  end loop;
  
  put_line(reversed);
end main;