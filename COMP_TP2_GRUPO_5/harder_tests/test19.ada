-- =============================================================================
-- TESTE 19: Sistema de Classificação (Grade System)
-- =============================================================================
-- test_grade_system.ada
procedure main is
begin
  score := 85;
  
  if score >= 90 then
    grade := 5;
  else
    if score >= 80 then
      grade := 4;
    else
      if score >= 70 then
        grade := 3;
      else
        if score >= 60 then
          grade := 2;
        else
          grade := 1;
        end if;
      end if;
    end if;
  end if;
  
  put_line(grade);
end main;
