-- TEST 5: test_while.ada
-- While loop simples
-- ============================================
procedure main is
begin
  i := 0;
  while i < 3 loop
    put_line(i);
    i := i + 1;
  end loop;
end main;