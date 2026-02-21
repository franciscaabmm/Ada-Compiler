-- =============================================================================
-- TESTE 15: Contagem de Números Pares até N
-- =============================================================================
-- test_count_evens.ada
procedure main is
begin
  n := 20;
  count := 0;
  i := 1;
  
  while i <= n loop
    remainder := i - (i / 2) * 2;
    if remainder = 0 then
      count := count + 1;
      put_line(i);
    end if;
    i := i + 1;
  end loop;
  
  put_line(count);
end main;