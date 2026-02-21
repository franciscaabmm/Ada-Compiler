-- =============================================================================
-- TESTE 7: Fibonacci
-- =============================================================================
-- test_fibonacci.ada
procedure main is
begin
  n := 10;
  a := 0;
  b := 1;
  counter := 0;
  
  put_line(a);
  put_line(b);
  
  while counter < n loop
    next := a + b;
    put_line(next);
    a := b;
    b := next;
    counter := counter + 1;
  end loop;
end main;