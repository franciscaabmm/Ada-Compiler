-- =============================================================================
-- TESTE 12: Número Perfeito
-- =============================================================================
-- test_perfect_number.ada
procedure main is
begin
  n := 28;
  sum := 0;
  divisor := 1;
  
  while divisor < n loop
    remainder := n - (n / divisor) * divisor;
    if remainder = 0 then
      sum := sum + divisor;
    end if;
    divisor := divisor + 1;
  end loop;
  
  if sum = n then
    put_line(1);
  else
    put_line(0);
  end if;
end main;