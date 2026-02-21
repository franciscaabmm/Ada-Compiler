-- =============================================================================
-- TESTE 8: Número Primo
-- =============================================================================
-- test_prime.ada
procedure main is
begin
  n := 17;
  is_prime := true;
  divisor := 2;
  
  if n <= 1 then
    is_prime := false;
  else
    while divisor * divisor <= n loop
      remainder := n - (n / divisor) * divisor;
      if remainder = 0 then
        is_prime := false;
      end if;
      divisor := divisor + 1;
    end loop;
  end if;
  
  put_line(is_prime);
end main;