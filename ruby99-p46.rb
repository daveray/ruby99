
################################################################################
# P46 (**) Truth tables for logical expressions.
def my_and(a,b)
  case [a,b]
    when [true, true]: true
    else false
  end
end

raise "P46.1 fail" unless my_and(true,true) == true
raise "P46.2 fail" unless my_and(true,false) == false
raise "P46.3 fail" unless my_and(false,true) == false
raise "P46.4 fail" unless my_and(false,false) == false

def my_or(a,b)
  case [a,b]
    when [true, true]: true
    when [true, false]: true
    when [false, true]: true
    else false
  end
end

raise "P46.5 fail" unless my_or(true,true) == true
raise "P46.6 fail" unless my_or(true,false) == true
raise "P46.7 fail" unless my_or(false,true) == true
raise "P46.8 fail" unless my_or(false,false) == false

def my_not(a)
  case a
    when true : false
    else true
  end
end

raise "P46.9 fail" unless my_not(true) == false
raise "P46.10 fail" unless my_not(false) == true

def my_nand(a,b) my_not(my_and(a,b)) end
def my_nor(a,b) my_not(my_or(a,b))  end
def my_nor(a,b) my_not(my_or(a,b)) end
def my_impl(a,b) my_or(my_not(a), b) end
def my_equ(a,b) my_or(my_and(a,b), my_and(my_not(a), my_not(b))) end
def my_xor(a,b) my_not(my_equ(a,b)) end

def table(&predicate)
  result = []
  [true, false].each do |a|
    [true, false].each do |b|
      result << [a,b, predicate.call(a,b)]
    end
  end
  result
end

raise "P46.11 fail" unless table { |a,b| my_and(a, my_or(a, my_not(b))) } ==
  [[true,true,true],
   [true,false,true],
   [false,true,false],
   [false,false,false]]
