-- =============================================================================
-- TESTE 18: Cálculo de Média com Loop
-- =============================================================================
-- test_average.ada
procedure main is
begin
  count := 5;
  sum := 0;
  i := 0;
  
  while i < count loop
    value := get_line();
    sum := sum + value;
    i := i + 1;
  end loop;
  
  average := sum / count;
  put_line(average);
end main;