import itertools

actions = [
    (3,0,-1),
    (-3,-2,3),
    (2,0,-2),
    (-2,2,0),
    (0,-3,2),
    (0,3,-2)
]

initial = (7, 7, 7)
ideal = (8, 8, 8)

sequences = list(itertools.product(actions, repeat=5)) 


closest = None
min_distance = float('inf')
for seq in sequences:
    current = initial
    for action in seq:\
        current = tuple(sum(x) for x in zip(current, action))
    distance = sum(abs(x - y) for x, y in zip(current, ideal))
    if distance < min_distance:
        min_distance = distance
        closest = seq


decoded = []
for seq in closest:
    decoded.append(actions.index(seq) + 1)

print("Closest sequence of actions:", closest)
print("Closest decoded", decoded)
print("Resulting tuple:", tuple(sum(x) for x in zip(initial, *closest)))
print("Distance to the ideal:", min_distance)

