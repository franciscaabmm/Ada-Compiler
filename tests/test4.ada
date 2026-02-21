-- TEST 4: test_if_else.ada
-- If-then-else
-- ============================================
procedure main is
begin
  x := 5;
  if x > 10 then
    put_line(1);
  else
    put_line(0);
  end if;
end main;