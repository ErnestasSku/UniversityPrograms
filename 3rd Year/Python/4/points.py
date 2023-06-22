
class Segment:
    def __init__(self, start, end):
        """Takes a start of coordinate of the segment and the end of it"""
        self.start = start
        self.end = end
    
    
    def length(self):
        """
        Computes the length of the segment.

        Returns: number
        """
        return self.end - self.start