from flask_nemo import Nemo
from flask import Markup, redirect, url_for
from MyCapytain.resources.prototypes.cts.inventory import CtsWorkMetadata, CtsEditionMetadata
from MyCapytain.errors import UnknownCollection
from MyCapytain.common.constants import Mimetypes


class NemoPTA(Nemo):
    """ We'll write more there later """
    ROUTES = Nemo.ROUTES + [
        ("/text/<objectId>/full", "r_full_text", ["GET"]),
        ("/about", "r_about", ["GET"]),
        ("/contributing", "r_contributing", ["GET"]),
        ("/encoding", "r_encoding", ["GET"]),
        ("/contact", "r_contact", ["GET"]),
        ("/bibliography", "r_bibliography", ["GET"]),
        ("/manuscripts", "r_manuscripts", ["GET"]),
        ("/indices", "r_indices", ["GET"]),
    ]
    CACHED = Nemo.CACHED + ["r_full_text"]

    def r_full_text(self, objectId, lang=None,original_breadcrumb=True):
        """ Retrieve the text of the passage
        :param objectId: Collection identifier
        :type objectId: str
        :param lang: Lang in which to express main data
        :type lang: str
        :param subreference: Reference identifier
        :type subreference: str
        :return: Template, collections metadata and Markup object representing the text
        :rtype: {str: Any}
        """
        collection = self.get_collection(objectId)
        if isinstance(collection, CtsWorkMetadata):
            editions = [t for t in collection.children.values() if isinstance(t, CtsEditionMetadata)]
            if len(editions) == 0:
                raise UnknownCollection("This work has no default edition")
            return redirect(url_for(".r_full_text", objectId=str(editions[0].id)))
        text = self.get_passage(objectId=objectId, subreference=None)
        passage = self.transform(text, text.export(Mimetypes.PYTHON.ETREE), objectId)
        return {
            "template": "main::text.html",
            "objectId": objectId,
            "subreference": None,
            "collections": {
                "current": {
                    "label": collection.get_label(lang),
                    "id": collection.id,
                    "model": str(collection.model),
                    "type": str(collection.type),
                    "author": text.get_creator(lang),
                    "title": text.get_title(lang),
                    "description": text.get_description(lang),
                    "citation": collection.citation,
                    "coins": self.make_coins(collection, text, "", lang=lang)
                },
                "parents": self.make_parents(collection, lang=lang)
            },
            "text_passage": Markup(passage),
            "prev": None,
            "next": None
        }

    
    def r_about(self):
        """ About route function

        :return: Template to use for About page
        :rtype: {str: str}
        """
        return {"template": "main::about.html"}

    def r_contributing(self):
        """ Contributing route function

        :return: Template to use for contributing page
        :rtype: {str: str}
        """
        return {"template": "main::contributing.html"}

    def r_encoding(self):
        """ Encoding guidelines route function

        :return: Template to use for encoding guidelines page
        :rtype: {str: str}
        """
        return {"template": "main::encoding.html"}

    def r_contact(self):
        """ Contact route function

        :return: Template to use for contact page
        :rtype: {str: str}
        """
        return {"template": "main::contact.html"}

    def r_manuscripts(self):
        """ Manuscripts route function

        :return: Template to use for manuscripts page
        :rtype: {str: str}
        """
        return {"template": "main::404.html"}

    def r_bibliography(self):
        """ Bibliography route function

        :return: Template to use for bibliography page
        :rtype: {str: str}
        """
        return {"template": "main::404.html"}

    def r_indices(self):
        """ Indices route function

        :return: Template to use for manuscripts page
        :rtype: {str: str}
        """
        return {"template": "main::indices.html"}
