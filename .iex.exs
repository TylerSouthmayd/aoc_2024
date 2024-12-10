AOC.Day9.Part2.solve()
# 0....1.222
# target = %FileStore{id: 0, capacity: 5, list: [0, 0]}
# source = %FileStore{id: 1, capacity: 6, list: [1, 1, 1, 1, 1]}

# {new_target, new_source} = AOC.Day9.append_until_capacity(target, source)

# IO.inspect(new_target)
# IO.inspect(new_source)

# [
#   %FileStore{id: 0, capacity: 5, list: [0, 0]},
#   %FileStore{id: 1, capacity: 6, list: [1, 1, 1]},
#   %FileStore{id: 2, capacity: 4, list: [2]},
#   %FileStore{id: 3, capacity: 4, list: [3, 3, 3]},
#   %FileStore{id: 4, capacity: 3, list: [4, 4]},
#   %FileStore{id: 5, capacity: 5, list: [5, 5, 5, 5]},
#   %FileStore{id: 6, capacity: 5, list: [6, 6, 6, 6]},
#   %FileStore{id: 7, capacity: 4, list: [7, 7, 7]},
#   %FileStore{id: 8, capacity: 4, list: [8, 8, 8, 8]},
#   %FileStore{id: 9, capacity: 2, list: [9, 9]}
# ]
