-- =============================================================================
-- TESTE 5: Tabuada (Loop com Multiplicação)
-- =============================================================================
-- test_multiplication_table.ada
procedure main is
begin
  n := 7;
  i := 1;
  
  while i <= 10 loop
    result := n * i;
    put_line(result);
    i := i + 1;
  end loop;
end main;