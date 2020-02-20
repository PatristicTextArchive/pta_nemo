import os
import sys
from MyCapytain.resources.prototypes.cts.inventory import CtsTextInventoryCollection, CtsTextInventoryMetadata
from MyCapytain.resolvers.utils import CollectionDispatcher
from capitains_nautilus.cts.resolver import NautilusCTSResolver
# Setting up the collections

general_collection = CtsTextInventoryCollection()
misc = CtsTextInventoryMetadata("all", parent=general_collection)
misc.set_label("All authors", "mul")

gcs = CtsTextInventoryMetadata("gcs", parent=general_collection)
gcs.set_label("GCS retrodigitized (uncorrected from OGL/First1KGreek)", "mul")


organizer = CollectionDispatcher(general_collection, default_inventory_name="misc")


@organizer.inventory("all")
def organize_my_misc(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:pta:"):
        return True
    return False

@organizer.inventory("gcs")
def organize_my_gcs(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:greekLit:"):
        return True
    return False


d = "./corpora"

resolver = NautilusCTSResolver(
    [os.path.join(d,o) for o in os.listdir(d) if os.path.isdir(os.path.join(d,o))],
    dispatcher=organizer,
    cache=None
)

