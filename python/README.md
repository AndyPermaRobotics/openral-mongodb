# openral-mongodb-py
MongoDB Implementation of a RalRepository for openRAL.

## Install

Test-Version:
```bash
pip install --upgrade -i https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ openral-mongodb-py
```

```bash
pip install openral-mongodb-py
```

## Usage

```python
from openral_mongodb_py import RalRepositoryMongoDB
from pymongo import MongoClient
from pymongo.database import Database

# connect to MongoDB
client = MongoClient({connection_string})

# get database by name
database : Database = client["{database_name}"]
# alternative: get the database that is specified in connection_string
database : Database = client.get_database()

# create the repository
repository = RalRepositoryMongoDB(database, "{collection_name}")

repository.get_ral_object_by_uid("{uid}")

```