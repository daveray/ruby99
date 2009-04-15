##
# Ruby solutions to P-99: https://prof.ti.bfh.ch/hew1/informatik3/prolog/p-99/
#
# Just getting to know Ruby.
# Everything is 0-indexed as it should be.
# "Tests" are inline. I should be using rspec or something and testing more.
#
# (c) Dave Ray <daveray@gmail.com>

################################################################################
################################################################################
# Lists
################################################################################
################################################################################

################################################################################
# P01 (*) Find the last element of a list. 
def last(list)
  list[-1]
end

raise "P01 fail" unless last([1, 2, 3, 4]) == 4 

################################################################################
# P02 (*) Find the last but one element of a list. 
def penultimate(list)
  list[-2]
end

raise "P02 fail" unless penultimate([1, 2, 3, 4]) == 3

################################################################################
# P03 (*) Find the K'th element of a list. 
def kth(list, k)
  list[k]
end

raise "P03 fail" unless kth([1, 2, 3, 4], 2) == 3

################################################################################
# P04 (*) Find the number of elements of a list.
def count(list)
  list.length
end

raise "P04 fail" unless count([1, 2, 3, 4]) == 4

################################################################################
# P05 (*) Reverse a list.
def reverse(list)
  list.reverse
end

raise "P05 fail" unless reverse([1,2, 3, 4]) == [4, 3, 2, 1]

################################################################################
# P06 (*) Find out whether a list is a palindrome.
def palindrome?(list)
  list == reverse(list)
end

raise "P06 fail" unless palindrome?([1, 2, 3, 4, 3, 2, 1])
raise "P06 fail" if palindrome?([1, 2, 3, 4, 3, 2, 3])

################################################################################
# P07 (**) Flatten a nested list structure.
def flatten(list)
  list.flatten
end

raise "P07 fail" unless flatten([1, [2, [3, 4, 5], 6], [7]]) == (1..7).to_a

################################################################################
# P08 (**) Eliminate consecutive duplicates of list elements.
def compress(list)
  list.zip(list[1..-1] + [nil]).  # Zip with shifted list
       select {|a,b| a != b}.     # Filter dups
       map {|a,b| a}              # Unzip
end

raise "P08 fail" unless compress([1,1,1,2,3,3,4,4,1,1,5,6,6,6,7,7]) == [1,2,3,4,1,5,6,7]

################################################################################
# P09 (**) Pack consecutive duplicates of list elements into sublists.

# Similar to Scala's List.span method...
class Array
  def span
    remainder = self.dup
    result = []
    while !remainder.empty? && (yield remainder.first) do
      result << remainder.shift
    end
    return result, remainder
  end
end

def pack(list)
  if list.empty?
    [[]]
  else
    packed, rest = list.span { |i| i == list.first }
    if rest.empty?
      [packed]
    else
      [packed] + pack(rest)
    end
  end
end

raise "P09 fail" unless pack([1,1,1,2,3,3,4,4,1,4,5,6,6,6,7,7]) == [[1,1,1],[2],[3,3],[4,4],[1],[4],[5],[6,6,6],[7,7]]

################################################################################
# P10 (*) Run-length encoding of a list.

def encode(list)
  pack(list).map { |i| [i.length,i.first] }
end

raise "P10 fail" unless encode([1,1,1,2,3,3,4,4,1,5,5,6,6,6,7,7]) ==
                               [[3,1], [1,2], [2,3], [2,4], [1,1], [2,5], [3,6], [2,7]]

################################################################################
# P11 (*) Modified run-length encoding.
def encode_modified(list)
  pack(list).map { |i| i.length > 1 ? [i.length,i.first] : i.first }
end

raise "P11 fail" unless encode_modified([1,1,1,2,3,3,4,4,1,5,5,6,6,6,7,7]) ==
                               [[3,1], 2, [2,3], [2,4], 1, [2,5], [3,6], [2,7]]

################################################################################
# P12 (**) Decode a run-length encoded list.
def decode(encoded)
  encoded.map { |n, e| e.nil? ? n : [e] * n }.flatten
end

raise "P12 fail" unless decode([[3,1], 2, [2,3], [2,4], 1, [2,5], [3,6], [2,7]]) ==
                               [1,1,1,2,3,3,4,4,1,5,5,6,6,6,7,7]

################################################################################
# P13 (**) Run-length encoding of a list (direct solution).

def encode_direct(list, s = 0)
  if s >= list.length then return [] end

  i = s
  while i < list.length && (i == s || list[i] == list[i-1])
    i += 1
  end
  n = i - s

  [(n > 0 ? [n, list[s]] : list[s])] + encode_direct(list, i)
end

raise "P13 fail" unless encode_direct([1,1,1,2,3,3,4,4,1,5,5,6,6,6,7,7]) ==
                               [[3,1], [1,2], [2,3], [2,4], [1,1], [2,5], [3,6], [2,7]]

################################################################################
# P14 (*) Duplicate the elements of a list. 

def dupli(list)
  list.map { |i| [i, i] }.flatten
end
raise "P14 fail" unless dupli(%w(a b c c d)) == %w(a a b b c c c c d d)

################################################################################
# P15 (**) Duplicate the elements of a list a given number of times.
def duplin(list, n)
  list.map { |i| [i] * n }.flatten
end
raise "P15 fail" unless duplin(%w(a b c c d),3) == %w(a a a b b b c c c c c c d d d)

################################################################################
# P16 (**) Drop every N'th element from a list.
def drop(list, n)
  result = []
  list.each_index do |i| 
    if i % n != n - 1 
      result << list[i] 
    end 
  end
  result
end

raise "P16 fail" unless drop(%w(a b c d e f g h i k), 3) == %w(a b d e g h k)

################################################################################
# P17 (*) Split a list into two parts; the length of the first part is given.
def split(list, n)
  return list[0...n], list[n..-1]
end

raise "P17 fail" unless split(%w(a b c d e f g h i k), 3) == [%w(a b c), %w(d e f g h i k)]

################################################################################
# P18 (**) Extract a slice from a list.
def slice(list, s, e)
  list[s..e]
end

raise "P18 fail" unless slice(%w(a b c d e f g h i k), 2, 6) == %w(c d e f g)

################################################################################
# P19 (**) Rotate a list N places to the left.
def rotate(list, n)
  head, tail = split(list, n >= 0 ? n % list.length : list.length + n)
  return tail + head
end

raise "P19.1 fail" unless rotate(%w(a b c d e f g h), 3) == %w(d e f g h a b c)
raise "P19.2 fail" unless rotate(%w(a b c d e f g h), -2) == %w(g h a b c d e f)

################################################################################
# P20 (*) Remove the K'th element from a list.
def remove_at(list, k)
  list = list.dup
  return list.delete_at(k), list
end

raise "P20 fail" unless remove_at(%w(a b c d), 1)[1] == %w(a c d)

################################################################################
# P21 (*) Insert an element at a given position into a list.
def insert_at(v, list, n)
  list.dup.insert(n, v)
end
raise "P21 fail" unless insert_at("alfa", %w(a b c d), 1) == %w(a alfa b c d)

################################################################################
# P22 (*) Create a list containing all integers within a given range.
def range(s, e)
  (s...e).to_a
end
raise "P22 fail" unless range(4,9) != [4,5,6,7,8,9]

################################################################################
# P23 (**) Extract a given number of randomly selected elements from a list.
def rnd_select(list, n)
  if n > 0
    selected, rest = remove_at(list, rand(n))
    [selected] + rnd_select(rest, n - 1)
  else
    []
  end
end
selected = rnd_select(%w(a b c d e f g), 3)
raise "P23 fail" unless selected.length == 3 && selected.uniq.length == 3

################################################################################
# P24 (*) Lotto: Draw N different random numbers from the set 1..M.
def rnd_select_range(list, n, m)
  rnd_select(range(1, m), n)
end

# uhhh...

################################################################################
# P25 (*) Generate a random permutation of the elements of a list.
def rnd_permu(list)
  rnd_select(list, list.length)
end

input = %w(a b c d e f g)
result = rnd_permu(input)
raise "P25 fail" unless result.sort == input.sort

################################################################################
# P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
def combinations(list, k)
  if k == 0
    [[]]
  elsif k == list.length
    [list]
  else
    rest = list[1..-1]
    combinations(rest, k-1).map { |sub| [list.first] + sub } + combinations(rest, k)
  end
end

raise "P26 fail" unless combinations(%w(a b c d), 2) == 
          [%w(a b), %w(a c), %w(a d), %w(b c), %w(b d), %w(c d)]

################################################################################
# P27 (**) Group the elements of a set into disjoint subsets.

def group(list, subgroups)
  if subgroups.empty?
    [[]]
  else
    result = []
    combinations(list, subgroups.first).each do |c| 
      group(list - c, subgroups[1..-1]).each do |g|
        result << [c] + g
      end
    end
    result
  end
end

raise "P27.1 fail" unless group(%w(a b), [1, 1]) == [[%w(a), %w(b)], [%w(b), %w(a)]]
raise "P27.2 fail" unless group(%w(a b c), [2, 1]) == 
  [[%w(a b), %w(c)], 
   [%w(a c), %w(b)],
   [%w(b c), %w(a)]]
raise "P27.3 fail" unless group(%w(a b c), [1, 2]) == 
  [[%w(a), %w(b c)], 
   [%w(b), %w(a c)],
   [%w(c), %w(a b)]]

################################################################################
# P28 (**) Sorting a list of lists according to length of sublists 

# Quick definition of merge sort. A stable sort makes results more predicable.
def merge(left, right, &predicate)
  result = []
  while !left.empty? && !right.empty?
    if predicate.call(left.first, right.first) <= 0
      result << left.shift
    else
      result << right.shift
    end
  end
  result.concat left.empty? ? right : left
end

def merge_sort(list, &predicate)
  if list.empty?
    []
  elsif list.length == 1
    list
  else
    left, right = split(list, list.length / 2)
    merge(merge_sort(left, &predicate), 
          merge_sort(right, &predicate), 
          &predicate)
  end
end

# Part a, sort by length
def lsort(list)
  merge_sort(list) {|a,b| a.length <=> b.length}
end

raise "P28.1 fail" unless lsort([%w(a b c),%w(d e),%w(f g h),%w(d e),%w(i j k l),%w(m n),%w(o)]) ==
      [%w(o), %w(d  e), %w(d  e), %w(m  n), %w(a b c), %w(f g h), %w(i j k l)]

# Part b, sort by length frequency
def lfsort(list)
  freqs = Hash.new(0) # map from length to frequency
  list.each { |v| freqs[v.length] += 1 }
  merge_sort(list) { |a,b| freqs[a.length] <=> freqs[b.length] }
end

raise "P28.2 fail" unless lfsort([%w(a b c),%w(d e),%w(f g h),%w(d e),%w(i j k l),%w(m n),%w(o)]) ==
      [%w(i j k l), %w(o), %w(a b c), %w(f g h), %w(d  e), %w(d  e), %w(m  n) ]

################################################################################
# No P29 or P30!

################################################################################
################################################################################
# Arithmetic
################################################################################
################################################################################

################################################################################
# P31 (**) Determine whether a given integer number is prime.
$prime_cache = {} # cache from n --> [ :prime | :composite ]
def is_prime(n)
  if (c =$prime_cache[n])
    c == :prime
  elsif n > 1 && (2..Math.sqrt(n)).all? { |f| n % f != 0 }
    $prime_cache[n] = :prime
    true
  else
    $prime_cache[n] = :composite
    false
  end
end

raise "P31 fail" unless (1..30).select { |n| is_prime(n) } == 
            [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

################################################################################
# P32 (**) Determine the greatest common divisor of two positive integer numbers.
def gcd(a, b)
  b == 0 ? a : gcd(b, a % b)
end

raise "P32 fail" unless [gcd(36,63), gcd(1, 1), gcd(2, 4), gcd(99, 15)] == [9, 1, 2, 3]

################################################################################
# P33 (*) Determine whether two positive integer numbers are coprime.
def coprime(a, b)
  gcd(a, b) == 1
end
raise "P33 fail" unless [coprime(35, 64), coprime(17, 9), coprime(15, 25)] == [true, true, false]

################################################################################
# P34 (**) Calculate Euler's totient function phi(m).
def totient_phi(n)
  n == 1 ? 1 : (1...n).select {|v| coprime(n, v) }.length
end

raise "P34.1 fail" unless (1..20).map {|n| totient_phi(n) } == 
      [1, 1, 2, 2, 4, 
       2, 6, 4, 6, 4,
       10, 4, 12, 6, 8,
       8, 16, 6, 18, 8]

# phi(prime) == prime - 1
primes = (1..100).select {|n| is_prime(n) }
raise "P34.2 fail" unless primes.map { |p| totient_phi(p) } == primes.map { |p| p - 1 }

################################################################################
# P35 (**) Determine the prime factors of a given positive integer.
def prime_factors_helper(f, n)
  if f > n
    []
  elsif is_prime(f) && n % f == 0
    [f] + prime_factors_helper(f, n / f)
  else
    prime_factors_helper(f == 2 ? f + 1 : f + 2, n)
  end
end

def prime_factors(n)
  n < 4 ? [n] : prime_factors_helper(2, n)
end
raise "P35.1 fail" unless prime_factors(315) == [3,3,5,7]
raise "P35.2 fail" unless prime_factors(101) == [101]
raise "P35.3 fail" unless prime_factors(1) == [1]
raise "P35.4 fail" unless prime_factors(2) == [2]
raise "P35.5 fail" unless prime_factors(3) == [3]
raise "P35.6 fail" unless prime_factors(4) == [2,2]

################################################################################
# P36 (**) Determine the prime factors of a given positive integer (2).
def prime_factors_multi(n)
  # Use vanilla run-length encoding and swap entries to conform to example given
  encode(prime_factors(n)).map { |a,b| [b,a] }
end

raise "P36 fail" unless prime_factors_multi(315) == [[3, 2],[5, 1],[7, 1]]

################################################################################
# P37 (**) Calculate Euler's totient function phi(m) (improved). 
def totient_phi_improved(n)
  if n > 1 then
    prime_factors_multi(n).inject(1) do |product, v| 
      p, m = v
      product * ((p - 1) * (p ** (m - 1)))
    end
  else
    1
  end
end

raise "P37.1 fail" unless (1..20).map {|n| totient_phi_improved(n) } == 
      [1, 1, 2, 2, 4, 
       2, 6, 4, 6, 4,
       10, 4, 12, 6, 8,
       8, 16, 6, 18, 8]

# phi(prime) == prime - 1
primes = (1..100).select {|n| is_prime(n) }
raise "P37.2 fail" unless primes.map { |p| totient_phi_improved(p) } == primes.map { |p| p - 1 }

################################################################################
# P38 (*) Compare the two methods of calculating Euler's totient function.
# Yes. totient_phi_improved is faster than totient_phi.

################################################################################
# P39 (*) A list of prime numbers.
class Range
  def primes
    self.select { |n| is_prime(n) }
  end
end

raise "P39 fail" unless (1..30).primes == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

################################################################################
# P40 (**) Goldbach's conjecture.
def goldbach(n)
  a = (2..n-1).primes.find { |a| is_prime(n - a) }
  [a, n - a]
end

raise "P40.1 fail" unless goldbach(28) == [5, 23]
raise "P40.2 fail" unless goldbach(40) == [3, 37]

################################################################################
# P41 (**) A list of Goldbach compositions.
def goldbach_list(range)
  range.select { |n| n % 2 == 0 }. map { |n| goldbach(n) }
end

raise "P41.1 fail" unless goldbach_list(9..20) == 
      [[3,7],[5,7],[3,11],[3,13],[5,13],[3,17]]
raise "P41.2 fail" unless goldbach_list(3..2000).select {|a,b| a > 50 && b > 50} ==
      [[73,919], [61,1321], [67,1789], [61,1867]]

################################################################################
################################################################################
# Logic and Codes
################################################################################
################################################################################

################################################################################
require 'ruby99-p46'
 
################################################################################
# P47 (*) Truth tables for logical expressions (2).

# Omitted. Can I define infix operators in Ruby?

################################################################################
require 'ruby99-p48'

################################################################################
require 'ruby99-p49'

################################################################################
require 'ruby99-p50'

################################################################################
################################################################################
# Binary Trees
################################################################################
################################################################################
