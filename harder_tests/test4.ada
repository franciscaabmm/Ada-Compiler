-- =============================================================================
-- TESTE 4: While Loops Aninhados
-- =============================================================================
-- test_nested_loops.ada
procedure main is
begin
  i := 1;
  sum := 0;
  
  while i <= 5 loop
    j := 1;
    while j <= i loop
      sum := sum + j;
      j := j + 1;
    end loop;
    i := i + 1;
  end loop;
  
  put_line(sum);
end main;