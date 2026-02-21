-- =============================================================================
-- TESTE 14: Palíndromo Numérico
-- =============================================================================
-- test_palindrome.ada
procedure main is
begin
  original := 12321;
  n := original;
  reversed := 0;
  
  while n > 0 loop
    digit := n - (n / 10) * 10;
    reversed := reversed * 10 + digit;
    n := n / 10;
  end loop;
  
  if original = reversed then
    put_line(1);
  else
    put_line(0);
  end if;
end main;