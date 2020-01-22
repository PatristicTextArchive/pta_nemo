from MyCapytain.resources.prototypes.cts.inventory import CtsTextInventoryCollection, CtsTextInventoryMetadata
from MyCapytain.resolvers.utils import CollectionDispatcher
from capitains_nautilus.cts.resolver import NautilusCTSResolver
# Setting up the collections

general_collection = CtsTextInventoryCollection()
misc = CtsTextInventoryMetadata("all", parent=general_collection)
misc.set_label("All authors", "mul")

gcs = CtsTextInventoryMetadata("gcs", parent=general_collection)
gcs.set_label("GCS Retrodigitalisate", "mul")

bibelexegese = CtsTextInventoryMetadata("bibelexegese", parent=general_collection)
bibelexegese.set_label("Bibelexegese Neueditionen", "mul")

organizer = CollectionDispatcher(general_collection, default_inventory_name="misc")


@organizer.inventory("all")
def organize_my_misc(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:pta:"):
        return True
    return False

@organizer.inventory("gcs")
def organize_my_severian(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:dummy:dummy1"):
        return True
    return False

@organizer.inventory("bibelexegese")
def organize_my_dok(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:dummy:dummy2"):
        return True
    return False


# Parsing the data
resolver = NautilusCTSResolver(["corpora/pta_data","corpora/dummy"], dispatcher=organizer)
resolver.parse()

