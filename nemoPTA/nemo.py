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

    def get_add_metadata(self, text):
        """
        Get additional metadata from xml
        """
        xss = etree.fromstring(str(text))
        ns = {None: 'http://www.tei-c.org/ns/1.0'}
        titlef = xss.findtext(".//title", namespaces=ns)
        try:
            pta = xss.findall('.//idno', namespaces=ns)[0].text
        except:
            pta = "–"
        try:
            cpg = xss.findall('.//idno', namespaces=ns)[1].text
        except:
            cpg = "–"
        try:
            bhg = xss.findall('.//idno', namespaces=ns)[2].text
        except:
            bhg = "–"
        try:
            pinakes = xss.findall('.//idno', namespaces=ns)[4].text
        except:
            pinakes = "–"
        if "pta" in pta: # only for pta-files
            idnos = [pta,cpg,bhg,pinakes]
        else:
            idnos = []
        return idnos

    def get_licence(self, text):
        """
        Get licence info from xml
        """
        xss = etree.fromstring(str(text))
        ns = {None: 'http://www.tei-c.org/ns/1.0'}
        lic = xss.find('.//licence', namespaces=ns)
        licence_text = lic.text
        licence_link = lic.attrib['target']
        if "by-nc" in licence_link:
            licence_image = "cc-by-nc"
        elif "by-sa" in licence_link:
            licence_image = "cc-by-sa"
        elif "by" in licence_link:
            licence_image = "cc-by"
        licence = [licence_text,licence_link,licence_image]
        return licence

    def get_edition_type(self, text):
        """
        Get type of edition from xml
        """
        xss = etree.fromstring(str(text))
        ns = {None: 'http://www.tei-c.org/ns/1.0'}
        banner = ""
        try:
            kind = xss.find('.//revisionDesc', namespaces=ns)
            if "pre-critical-edition" in kind.attrib['status']:
                banner = "edition-pre-critical-red"
            elif "critical-edition-outdated" in kind.attrib['status']:
                banner = "edition-outdated--critical_with_app-orange"
            elif "critical-edition-no-app" in kind.attrib['status']:
                banner = "edition-critical (no app)-orange"
            elif "critical-edition" in kind.attrib['status']:
                banner = "edition-critical%20(with%20app)-brightgreen"
            else:
                pass
        except:
            pass
        return banner

    def get_features(self, text):
        """
        Get encoded features from xml
        """
        xss = etree.fromstring(str(text))
        ns = {None: 'http://www.tei-c.org/ns/1.0'}
        features = xss.findall('.//editorialDecl/interpretation/p', namespaces=ns)
        features_intext = []
        for feature in features:
            if "biblical-quotations" in feature.attrib["{http://www.w3.org/XML/1998/namespace}id"]:
                features_intext.append("encoded-biblical quotes-090A3B")
            else:
                pass
            if "persons" in feature.attrib["{http://www.w3.org/XML/1998/namespace}id"]:
                features_intext.append("encoded-persons-555794")
            else:
                pass
            if "places" in feature.attrib["{http://www.w3.org/XML/1998/namespace}id"]:
                features_intext.append("encoded-places-333577")
            else:
                pass
        return features_intext

    def get_xml_link(self,collection):
        """
        Get link for xml file in github repository
        """
        download_filename = collection.id.split(":")[3]
        if collection.id.split(":")[2] == "pta": # provide link only for pta
            download_path = download_filename.split(".")[0]+"/"+download_filename.split(".")[1]
            download = [download_path,download_filename]
        else:
            download = []
        return download

    def get_witnesses(self, text):
        """
        Get information on witnesses from xml
        """
        xss = etree.fromstring(str(text))
        ns = {None: 'http://www.tei-c.org/ns/1.0'}
        listwit = xss.findall('.//listWit/witness', namespaces=ns)
        witnesses = []
        for wit in listwit:
            witlist = []
            #link = wit.attrib["facs"]
            witness = ":".join(wit.itertext()).split(":")
            witlist.append(witness[0])
            witlist.append(witness[1])
            witlist.append(witness[3])
            try:
                witlist.append(witness[5])
            except:
                pass
            #witlist.append(link)
            witnesses.append(witlist)
        return witnesses
    
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
        idnos = self.get_add_metadata(text)
        licence = self.get_licence(text)
        banner = self.get_edition_type(text)
        features_intext = self.get_features(text)
        download = self.get_xml_link(collection)
        witnesses = self.get_witnesses(text)
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
                    "download": download,
                    "witnesses": witnesses,
                    "idnos": idnos,
                    "kind": banner,
                    "features": features_intext,
                    "licence": licence,
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
        full_text = self.get_passage(objectId=objectId, subreference=None)
        idnos = self.get_add_metadata(full_text)
        licence = self.get_licence(full_text)
        banner = self.get_edition_type(full_text)
        features_intext = self.get_features(full_text)
        download = self.get_xml_link(collection)
        witnesses = self.get_witnesses(full_text)
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
                    "download": download,
                    "witnesses": witnesses,
                    "idnos": idnos,
                    "kind": banner,
                    "features": features_intext,
                    "licence": licence,
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
