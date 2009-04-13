##
# Ruby solutions to P-99: https://prof.ti.bfh.ch/hew1/informatik3/prolog/p-99/
#
# (c) Dave Ray <daveray@gmail.com>

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

def merge_sort_by(list, &predicate)
  if list.empty?
    []
  elsif list.length == 1
    list
  else
    left, right = split(list, list.length / 2)
    merge(merge_sort_by(left, &predicate), 
          merge_sort_by(right, &predicate), 
          &predicate)
  end
end

# Part a, sort by length
def lsort(list)
  merge_sort_by(list) {|a,b| a.length <=> b.length}
end

raise "P28.1 fail" unless lsort([%w(a b c),%w(d e),%w(f g h),%w(d e),%w(i j k l),%w(m n),%w(o)]) ==
      [%w(o), %w(d  e), %w(d  e), %w(m  n), %w(a b c), %w(f g h), %w(i j k l)]

# Part b, sort by length frequency
def lfsort(list)
  freqs = Hash.new(0) # map from length to frequency
  list.each { |v| freqs[v.length] += 1 }
  merge_sort_by(list) { |a,b| freqs[a.length] <=> freqs[b.length] }
end

raise "P28.2 fail" unless lfsort([%w(a b c),%w(d e),%w(f g h),%w(d e),%w(i j k l),%w(m n),%w(o)]) ==
      [%w(i j k l), %w(o), %w(a b c), %w(f g h), %w(d  e), %w(d  e), %w(m  n) ]

