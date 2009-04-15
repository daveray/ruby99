
################################################################################
# P49 (**) Gray code.
def gray(n)
  if n == 1
    ['0', '1']
  else
    subs = gray(n-1)
    subs.map { |c| '0' + c } + subs.reverse.map { |c| '1' + c }
  end
end

raise "P49.1 fail" unless gray(1) == ['0', '1']
raise "P49.2 fail" unless gray(2) == ['00', '01', '11', '10']
raise "P49.3 fail" unless gray(3) == 
  ['000', '001', '011', '010', '110', '111', '101', '100']

