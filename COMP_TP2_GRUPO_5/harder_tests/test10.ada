-- =============================================================================
-- TESTE 10: Soma de Dígitos
-- =============================================================================
-- test_digit_sum.ada
procedure main is
begin
  n := 12345;
  sum := 0;
  
  while n > 0 loop
    digit := n - (n / 10) * 10;
    sum := sum + digit;
    n := n / 10;
  end loop;
  
  put_line(sum);
end main;