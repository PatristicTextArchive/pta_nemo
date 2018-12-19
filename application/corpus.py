from MyCapytain.resources.prototypes.cts.inventory import CtsTextInventoryCollection, CtsTextInventoryMetadata
from MyCapytain.resolvers.utils import CollectionDispatcher


from capitains_nautilus.cts.resolver import NautilusCTSResolver

# Setting up the collections

general_collection = CtsTextInventoryCollection()
severian = CtsTextInventoryMetadata("severian_collection", parent=general_collection)
severian.set_label("Severian", "mul")

dok = CtsTextInventoryMetadata("dok_collection", parent=general_collection)
dok.set_label("Dokumente (Athanasius Werke III)", "mul")

athanasius = CtsTextInventoryMetadata("athanasius_collection", parent=general_collection)
athanasius.set_label("Athanasius", "mul")

misc = CtsTextInventoryMetadata("id:misc", parent=general_collection)
misc.set_label("Miscellaneous", "mul")
organizer = CollectionDispatcher(general_collection, default_inventory_name="id:misc")


@organizer.inventory("severian_collection")
def organize_my_severian(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:pta:pta0001"):
        return True
    return False

@organizer.inventory("athanasius_collection")
def organize_my_severian(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:pta:pta0022"):
        return True
    return False

@organizer.inventory("dok_collection")
def organize_my_dok(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:pta:pta0100"):
        return True
    return False


# Parsing the data
resolver = NautilusCTSResolver(["corpora/pta_data"], dispatcher=organizer)
resolver.parse()

