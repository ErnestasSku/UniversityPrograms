
chance = 0.43
value = 41

cc = 39
cv = 34

def Ev(c, v):
    return 1-c * 1 + c*v

default = Ev(chance, value)

print(f'regular: {Ev(chance, value)}')
print(f'+3 val: {Ev(chance, value + 3)}. Cost to increase: {(Ev(chance, value + 3) - default) / cv}')
print(f'+chance: {Ev(chance+0.03, value)}. Cost to increase: {(Ev(chance+0.03, value) - default) / cc}')