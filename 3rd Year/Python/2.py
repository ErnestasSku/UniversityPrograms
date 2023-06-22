# Ernestas Škudzinskas
# 3 kursas 4 grupė
# 2016049


from pymongo import MongoClient, ASCENDING, DESCENDING
import json
from pathlib import Path

# Actions for turn on specific action to see its output.
# Note: 1 is responsible for load_database() if  there is a need
# to load collection from file.
action = {
   1: False,
   2: False,
   3: False,
   4: False,
   5: False,
   6: False,
   7: False
}


def get_database():
    CONNECTION_STRING = 'mongodb://localhost:27017'
    
    client = MongoClient(CONNECTION_STRING)
    return client['restaurants']

# 1. Function to create/load json to db
# This method is turned off by default in actions dictionary
# As locally I created a collection from GUI
def load_database(db):
 with open('retaurants.json', 'r') as f:
    # The data is not a valid JSON. 
    # Need to split by lines and read each line as JSON 
    data = [json.loads(x) for x in f.readlines()]
    # Name can be changed to anything
    db.testcollection.insert_many(data)

print_cursor = lambda x : [print(y) for y in x]

if __name__ == "__main__":
    db = get_database()
    collection = db['restaurants']

    if action[1]:
       load_database(db)

    if action[2]:
        cursor = db.restaurants.find()
        print(*cursor)


    if action[3]:
        fields = {'restaurant_id': 1, 'name': 1, 'borough': 1, 'cuisine': 1}
        cursor = db.restaurants.find({}, fields)
        print(*cursor)



    if action[4]:
        fields = {'_id': 0,'restaurant_id': 1, 'name': 1, 'borough': 1, 'cuisine': 1}
        cursor = db.restaurants.find({}, fields)
        print(*cursor)


    if action[5]:
        cursor = db.restaurants.find({'borough': 'Bronx'})
        print(*cursor)

    if action[6]:
        pipeline = [
        {'$match': {'grades.score': {'$gte': 80, '$lte': 100}}},
        {'$project': {'_id': 0, 'restaurant_id': 1, 'name': 1, 'borough': 1, 'cuisine': 1}}
        ]
        cursor = db.restaurants.aggregate(pipeline)
        print(*cursor)


    if action[7]:
        # cursor = db.restaurants.find().sort([{'cuisine': 1, 'borough': -1}])
        cursor = db.restaurants.find().sort([('cuisine', ASCENDING), ('borough', DESCENDING)])
        print(*cursor)




