# openral-mongodb

Implementations of the RalRepositories of openral-core for MongoDB in various programming languages.

## Packages

* Python: [openral-mongodb-py](https://test.pypi.org/project/openral-mongodb-py/0.1.2/) (on test.pypi.org)
* Flutter: [openral_mongodb](https://github.com/AndyPermaRobotics/openral-core) (not yet published on pub.dev)

## Hints

### Replica Set for Watching

To use the methods of the repositories that watch for changes, we have to start the MongoDB as a ReplicaSet.
See: https://www.mongodb.com/docs/manual/tutorial/convert-standalone-to-replica-set/

In `docker-compose.yml` you can see the configuration for the ReplicaSet:
    
```yaml
command: mongod --bind_ip_all --replSet rs0; sleep 5; mongosh --eval "rs.initiate()"
``` 


## Testing

Use the docker-compose.yml file to start a MongoDB instance for testing.

```bash
./start_mongodb_test_instance.sh
```

You can also use the VS-Code Task "Start MongoDB Test Instance" to start the MongoDB instance.