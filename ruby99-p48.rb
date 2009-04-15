
################################################################################
# P48 (**) Truth tables for logical expressions (3).

def truth_combinations(num_vars)
  if num_vars == 0
    [[]]
  else
    subs = truth_combinations(num_vars-1)
    subs.map { |c| [true] + c } + subs.map { |c| [false] + c }
  end
end
def table_n(num_vars, &predicate)
  truth_combinations(num_vars).map do |vars|
    vars + [predicate.call(*vars)] 
  end
end

raise "P48.1 fail" unless table_n(2) { |a,b| my_and(a, my_or(a, my_not(b))) } ==
  [[true,true,true],
   [true,false,true],
   [false,true,false],
   [false,false,false]]
# A and (B or C) equ A and B or A and C
raise "P48.2 fail" unless table_n(3) { |a,b,c| 
  my_equ(my_and(a, my_or(b,c)), my_or(my_and(a,b), my_and(a,c))) } ==
  [[true,  true,  true,  true], 
   [true,  true,  false, true], 
   [true,  false, true,  true], 
   [true,  false, false, true], 
   [false, true,  true,  true], 
   [false, true,  false, true], 
   [false, false, true,  true], 
   [false, false, false, true]]
