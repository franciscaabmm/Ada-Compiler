-- =============================================================================
-- TESTE 11: Potência (x^y)
-- =============================================================================
-- test_power.ada
procedure main is
begin
  base := 2;
  exponent := 10;
  result := 1;
  counter := 0;
  
  while counter < exponent loop
    result := result * base;
    counter := counter + 1;
  end loop;
  
  put_line(result);
end main;