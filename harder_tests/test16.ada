-- =============================================================================
-- TESTE 16: Sequência Collatz
-- =============================================================================
-- test_collatz.ada
procedure main is
begin
  n := 27;
  steps := 0;
  
  put_line(n);
  
  while n /= 1 loop
    remainder := n - (n / 2) * 2;
    if remainder = 0 then
      n := n / 2;
    else
      n := 3 * n + 1;
    end if;
    put_line(n);
    steps := steps + 1;
  end loop;
  
  put_line(steps);
end main;