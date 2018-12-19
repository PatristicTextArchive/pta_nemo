from flask import Flask
from capitains_nautilus.flask_ext import FlaskNautilus
from application.corpus import resolver
from application.extension import MyNemo

def get_citation_scheme(text):
    # We create an empty list to store citations level names
    citation_types = []
    #  We loop over the citation scheme of the text
    for citation in text.citation:
        # We append the name of the citation level in the list we created
        citation_types.append(citation.name)
    # At this point, we just return
    return citation_types


def generic_chunker(text, getreffs):
    # We build a the citation type
    citation_types = get_citation_scheme(text)
    if "section" in citation_types:
        level = citation_types.index("section") + 1
        level_name = "Section"
    else:
        level = len(citation_types)
        level_name = citation_types[-1]

    reffs = getreffs(level=level)
    reffs = [(reff, level_name + " " + reff) for reff in reffs]

    return reffs

flask_app = Flask("Flask Application for Nemo")


nautilus_api = FlaskNautilus(name="Nautilus", prefix="/api", app=flask_app, resolver=resolver)
nemo = MyNemo(
    name="InstanceNemo",
    app=flask_app,
    resolver=resolver,
    base_url="",
    css=["assets/css/theme.css"],
    statics=["assets/images/logo.png"],
    transform={"default": "components/edition.xsl"},
    templates={"main": "templates/main"},
    chunker={"default": generic_chunker},
)

if __name__ == "__main__":
    flask_app.run(debug=True)

