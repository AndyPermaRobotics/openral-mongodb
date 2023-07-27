from abc import abstractmethod
from typing import Any, Callable, List, Mapping, Optional

from openral_py.ral_object import RalObject
from openral_py.repository import RalRepository
from pymongo.database import Database


class RalRepositoryMongoDB(RalRepository):
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
    
    async def get_ral_object_by_uid(self, uid: str, specificPropertiesTransform: Optional[Callable] = None) -> RalObject:
        """
        Returns the [RalObject] with the given uid. Looks for 'identity.UID' == uid in the database.
        If [specificPropertiesTransform] is not null, the [SpecificProperties] of the [RalObject] will be transformed to the given type.
        """

        collection = self._get_collection()
        doc : Optional[Mapping[str, Any]] = collection.find_one({"identity.UID": uid})

        if doc is None:
            raise Exception("No RalObject found for uid '$uid'");

        ral_object = RalObject.from_map(doc)

        return ral_object
    
    async def get_ral_objects_with_container_id(self, containerId: str) -> List[RalObject]:
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

    async def get_ral_objects_by_ral_type(self, ralType: str) -> List[RalObject]:
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


    def update_object_state(self, uid: str, state: str):
        """
        Updates the `objectState` of the [RalObject] with the given uid in the database.
        """

        collection = self._get_collection()
        collection.update_one({"identity.UID": uid}, {"$set": {"objectState": state}})

    def _get_collection(self):
        return self._database.get_collection(self._collectionName)