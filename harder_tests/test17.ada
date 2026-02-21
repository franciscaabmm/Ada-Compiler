-- =============================================================================
-- TESTE 17: Bubble Sort Parcial (3 números)
-- =============================================================================
-- test_sort_three.ada
procedure main is
begin
  a := 30;
  b := 10;
  c := 20;
  
  -- Ordenar a e b
  if a > b then
    temp := a;
    a := b;
    b := temp;
  end if;
  
  -- Ordenar b e c
  if b > c then
    temp := b;
    b := c;
    c := temp;
  end if;
  
  -- Ordenar a e b novamente
  if a > b then
    temp := a;
    a := b;
    b := temp;
  end if;
  
  put_line(a);
  put_line(b);
  put_line(c);
end main;