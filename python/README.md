# openral-mongodb-py
MongoDB Implementation of a RalRepository for openRAL.

## Install

```bash
pip install openral-mongodb-py
```

## Usage

```python
from openral_mongodb_py import RalRepositoryMongoDB
from pymongo import MongoClient

# connect to MongoDB and get the database
client = MongoClient({connection_string})
database : Database = client["{database_name}"]

# create the repository
repository = RalRepositoryMongoDB(database, "{collection_name}")

repository.get_ral_object_by_uid("{uid}")

```