-- =============================================================================
-- TESTE 6: Fatorial
-- =============================================================================
-- test_factorial.ada
procedure main is
begin
  n := 5;
  result := 1;
  counter := n;
  
  while counter > 0 loop
    result := result * counter;
    counter := counter - 1;
  end loop;
  
  put_line(result);
end main;