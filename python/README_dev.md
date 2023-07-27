# Readme for Developers of openral-mongodb-py

## Run tests

The tests require a MongoDB Instance.
You can use the docker-compose file in tests/assets to start a MongoDB instance.

```bash
docker-compose -p=openral_mongodb_py -f tests/assets/docker-compose.yml up -d
```

or use the VS-Code Task (in .vscode/tasks.json) to start the MongoDB instance.

