# Ernestas Škudzinskas
# 3 kursas 4 grupė
# 2016049

# Užduoties numeris
# 17 - 12 = 5.
# 5. ar simbolių eilutė sudaryta iš nepasikartojančių simbolių

import unittest


def unique(symbol_string: str) -> bool:
    """
    This function checks if a give input does not have repeating symbols.
    >>> unique('abcd')
    True

    >>> unique('abcc')
    False

    >>> unique('1234')
    True
    
    >>> unique('112345') 
    False

    >>> unique('x² + y² = 1')
    False

    >>> unique('x²+y³=c⁴')
    True
    """
    symbol_map = {}
    for character in symbol_string:
        if character in symbol_map:
            symbol_map[character] += 1
        else:
            symbol_map[character] = 1

    return not max(symbol_map.values()) > 1


class TestUnique(unittest.TestCase):

    def test_simple_string_true(self):
        self.assertEqual(unique('abcd'), True)

    def test_simple_string_false(self):
        self.assertEqual(unique('abcc'), False)

    def test_simple_number_string_true(self):
        self.assertEqual(unique('1234'), True)
    
    def test_simple_number_string_false(self):
        self.assertEqual(unique('112345'), False)
    
    def test_unicode_false(self):
        self.assertEqual(unique('x² + y² = 1'), False)
    
    def test_unicode_true(self):
        self.assertEqual(unique('x²+y³=c⁴'), True)

if __name__ == "__main__":
    import doctest
    doctest.testmod()
    unittest.main()
