
import pytest
from pymongo import MongoClient
from pymongo.database import Database

# from openral_mongodb_py.ral_repository_mongodb import RalRepositoryMongoDB
from openral_mongodb_py import RalRepositoryMongoDB
from tests.mock_data import mock_docs


class TestRalRepositoryMongoDB:
    """
    IMPORTANT: Tests the RalRepositoryMongoDB class with a real MongoDB instance.

    You can start a MongoDB instance with the dockercompose file in tests/assets/docker-compose.yml:
    $> docker-compose -p=openral_mongodb_py -f tests/assets/docker-compose.yml up -d
    
    """

    client_connection_str = "mongodb://localhost:27017/"
    database_name = "openral_mongodb_py_test"
    collection_name = "ral_objects"

    @pytest.fixture
    def create_repository(self) -> RalRepositoryMongoDB:
        """
        Connects to a MongoDB instance and returns the database.
        """

        client = MongoClient(TestRalRepositoryMongoDB.client_connection_str)

        database : Database = client[TestRalRepositoryMongoDB.database_name]

        database.drop_collection(TestRalRepositoryMongoDB.collection_name)

        collection = database.create_collection(TestRalRepositoryMongoDB.collection_name, check_exists=False)

        collection.insert_many(mock_docs)

        repository = RalRepositoryMongoDB(database, TestRalRepositoryMongoDB.collection_name)

        return repository

    @pytest.mark.asyncio
    async def test_get_ral_object_by_uid(self, create_repository):
        """
        Tests the get_ral_object_by_uid() method.
        """

        repo : RalRepositoryMongoDB = create_repository

        ral_object = await repo.get_ral_object_by_uid("farm_id") 

        assert ral_object.identity.uid == "farm_id", "ral_object.identity.uid should be 'farm_id'"
        assert ral_object.identity.name == "Farm Instance", "ral_object.identity.name should be 'Farm Instance'"

    @pytest.mark.asyncio
    async def test_get_ral_object_by_uid_not_found(self, create_repository):
        """
        Tests the get_ral_object_by_uid() method with a uid that is not in the database.
        """

        repo : RalRepositoryMongoDB = create_repository

        with pytest.raises(Exception):
            await repo.get_ral_object_by_uid("not_existing_uid")

    @pytest.mark.asyncio
    async def test_get_ral_objects_with_container_id(self, create_repository):

        repo: RalRepositoryMongoDB = create_repository

        ral_objects = await repo.get_ral_objects_with_container_id("me_pc")

        uids = [ral_object.identity.uid for ral_object in ral_objects]
        
        assert len(ral_objects) == 2, "expected 2 ral_objects having container_id 'me_pc'"
        assert uids.count("mqtt_id") == 1, "expected 1 mqtt_id"
        assert uids.count("firebaseConnectionUID") == 1, "expected 1 firebaseConnectionUID"
        

    @pytest.mark.asyncio
    async def test_get_ral_objects_by_ral_type(self, create_repository):

        repo: RalRepositoryMongoDB = create_repository

        ral_objects = await repo.get_ral_objects_by_ral_type("pc_instance")

        assert len(ral_objects) == 1, "expected 1 ral_object having ral_type 'pc_instance'"
        assert ral_objects[0].identity.uid == "me_pc", "expected ral_object with uid 'me_pc'"

