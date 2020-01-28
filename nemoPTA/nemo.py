from flask_nemo import Nemo
from flask import Markup, redirect, url_for
from MyCapytain.resources.prototypes.cts.inventory import CtsWorkMetadata, CtsEditionMetadata
from MyCapytain.errors import UnknownCollection
from MyCapytain.common.constants import Mimetypes
from lxml import etree

class NemoPTA(Nemo):
    """ We'll write more there later """
    ROUTES = Nemo.ROUTES + [
        ("/text/<objectId>/full", "r_full_text", ["GET"]),
        ("/about", "r_about", ["GET"]),
        ("/contributing", "r_contributing", ["GET"]),
        ("/encoding", "r_encoding", ["GET"]),
        ("/contact", "r_contact", ["GET"]),
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
        ## additional metadata
        metadata = {}
        try:
            xss = etree.fromstring(str(text))
            ns = {None: 'http://www.tei-c.org/ns/1.0'}
            titlef = xss.findtext(".//title", namespaces=ns)
            pta = xss.findall('.//idno', namespaces=ns)[0].text
            cpg = xss.findall('.//idno', namespaces=ns)[1].text
            pinakes = xss.findall('.//idno', namespaces=ns)[4].text
            metadata["PTA"] = pta
            metadata["CPG"] = cpg
            metadata["Pinakes-Oeuvre"] = pinakes
        except:
            print("No metadata in file")
        ## kind of edition
        banner = ""
        try:
            kind = xss.findtext('.//sourceDesc//note', namespaces=ns)
            if "Non-critical" in kind:
                banner = "edition-pre-critical-red"
            elif "Outdated" in kind:
                banner = "edition-outdated--critical_with_app-orange"
            elif "without critical apparatus" in kind:
                banner = "edition-critical (no app)-orange"
            else:
                banner = "edition-critical%20(with%20app)-brightgreen"
        except:
            print("Kind of edition not encoded")
        # text = Bibelstellen verlinken
        reffs = self.get_reffs(objectId=objectId)
        passage = self.transform(text, text.export(Mimetypes.PYTHON.ETREE), objectId)
        return {
            "template": "main::text.html",
            "objectId": objectId,
            "citation": collection.citation,
            "subreference": None,
            "collections": {
                "current": {
                    "label": collection.get_label(lang),
                    "id": collection.id,
                    "model": str(collection.model),
                    "type": str(collection.type),
                    "author": text.get_creator(lang),
                    "title": text.get_title(lang),
                    "ext_metadata": metadata,
                    "kind": banner,
                    "description": text.get_description(lang),
                    "citation": collection.citation,
                    "coins": self.make_coins(collection, text, "", lang=lang)
                },
                "parents": self.make_parents(collection, lang=lang)
            },
            "text_passage": Markup(passage),
            "prev": None,
            "next": None,
            "reffs": reffs
        }

    def r_passage(self, objectId, subreference, lang=None):
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
            return redirect(url_for(".r_passage", objectId=str(editions[0].id), subreference=subreference))
        text = self.get_passage(objectId=objectId, subreference=subreference)
        reffs = self.get_reffs(objectId=objectId)
        passage = self.transform(text, text.export(Mimetypes.PYTHON.ETREE), objectId)
        prev, next = self.get_siblings(objectId, subreference, text)
        return {
            "template": "main::text.html",
            "objectId": objectId,
            "subreference": subreference,
            "citation": collection.citation,
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
                    "coins": self.make_coins(collection, text, subreference, lang=lang)
                },
                "parents": self.make_parents(collection, lang=lang)
            },
            "text_passage": Markup(passage),
            "prev": prev,
            "next": next,
            "reffs": reffs
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
