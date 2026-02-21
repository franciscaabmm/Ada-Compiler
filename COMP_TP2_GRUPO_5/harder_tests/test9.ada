-- =============================================================================
-- TESTE 9: Máximo Divisor Comum (GCD/MDC)
-- =============================================================================
-- test_gcd.ada
procedure main is
begin
  a := 48;
  b := 18;
  
  while b /= 0 loop
    temp := b;
    b := a - (a / b) * b;
    a := temp;
  end loop;
  
  put_line(a);
end main;