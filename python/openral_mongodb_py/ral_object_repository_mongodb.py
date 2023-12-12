from abc import abstractmethod
from typing import Any, Callable, Generator, List, Mapping, Optional

from openral_py import RalObject
from openral_py.repository import RalObjectRepository
from pymongo.database import Database
from pymongo.change_stream import CollectionChangeStream

class RalObjectRepositoryMongoDB(RalObjectRepository):
    """
    MongoDB Implementation of a RalRepository for openRAL.
    """

    def __init__(
        self, 
        database: Database,
        collectionName: str):

        self._database = database
        """The MongoDB database where the [RalObject]s are stored. Received by the [MongoClient].get_database() method."""
        
        self._collectionName = collectionName
        """Name of the collection in the database where the [RalObject]s are stored."""
    
    async def get_by_uid(self, uid: str, specificPropertiesTransform: Optional[Callable] = None) -> RalObject:
        """
        Returns the [RalObject] with the given uid. Looks for 'identity.UID' == uid in the database.
        If [specificPropertiesTransform] is not null, the [SpecificProperties] of the [RalObject] will be transformed to the given type.
        """

        collection = self._get_collection()
        doc : Optional[Mapping[str, Any]] = collection.find_one({"identity.UID": uid})

        if doc is None:
            raise Exception(f"No RalObject found for uid '{uid}'");

        ral_object = RalObject.from_map(doc)

        return ral_object
    
    async def get_by_container_id(self, containerId: str) -> List[RalObject]:
        """
        Returns all [RalObject]s with the given containerId. Looks for 'currentGeolocation.container.UID' == containerId in the database.
        """
        
        collection = self._get_collection()
        docs = collection.find({"currentGeolocation.container.UID": containerId}) 

        #loop over docs
        ral_objects = []

        for doc in docs:
            ral_object = RalObject.from_map(doc)
            ral_objects.append(ral_object)

        return ral_objects

    async def get_by_ral_type(self, ralType: str) -> List[RalObject]:
        """
        Returns all [RalObject]s with the given ralType. Looks for 'template.RALType' == ralType in the database.
        """

        collection = self._get_collection()
        docs = collection.find({"template.RALType": ralType})

        ral_objects = []

        #loop over docs
        for doc in docs:
            ral_object = RalObject.from_map(doc)
            ral_objects.append(ral_object)

        return ral_objects

    #TODO: we can use the new update functions for that
    def update_object_state(self, uid: str, state: str):
        """
        Updates the `objectState` of the [RalObject] with the given uid in the database.
        """

        collection = self._get_collection()
        collection.update_one({"identity.UID": uid}, {"$set": {"objectState": state}})

    def _get_collection(self):
        return self._database.get_collection(self._collectionName)
    

    async def create(self, ral_object: RalObject, override_if_exists: bool):
        """
        Creates a new [RalObject] in the database. If [override_if_exists] is true, the [RalObject] will be overwritten if it already exists. Otherwise, an error will be thrown.
        """

        collection = self._get_collection()

        if override_if_exists:
            collection.replace_one({"identity.UID": ral_object.identity.uid}, ral_object.to_map(), upsert=True)
        else:
            if(collection.find_one({"identity.UID": ral_object.identity.uid}) is not None):
                raise Exception("RalObject with uid '${ral_object.identity.uid}' already exists in the database.")
            else:
                collection.insert_one(ral_object.to_map())

        