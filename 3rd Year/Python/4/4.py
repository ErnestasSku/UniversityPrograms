# Ernestas Škudzinskas
# 3 kursas 4 grupė
# 2016049

import stringutils


print(stringutils.unique('abc'))
print(stringutils.unique('abcc'))
print(stringutils.unique('abc465'))
try:
    print(stringutils.unique('ų'))
except stringutils.error:
    print("Function error happened, as it does not support ascii")