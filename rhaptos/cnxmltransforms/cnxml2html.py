import os
from cStringIO import StringIO
from lxml import etree

from zope.interface import implements

from Products.PortalTransforms.interfaces import ITransform
from Products.PortalTransforms.utils import log

dirname = os.path.dirname(__file__)

class cnxml_to_html:
    implements(ITransform)

    __name__ = "cnxml_to_html"
    inputs = ("application/cnxml+xml",)
    output = "text/html"

    def name(self):
        return self.__name__

    def convert(self, orig, data, **kwargs):
        parser = etree.XMLParser(resolve_entities=False)
        cnxmldoc = etree.parse(StringIO(orig), parser)

        xslt_root = etree.parse(os.path.join(dirname, 'xsl', 'cnxml2html.xsl'))
        transform = etree.XSLT(xslt_root)
        htmldoc = transform(cnxmldoc)

        nsmap = {'xhtml': 'http://www.w3.org/1999/xhtml'}

        # delete the module header - we'll use Plone's title instead
        header = htmldoc.find('//xhtml:div[@id="cnx_module_header"]',
            namespaces=nsmap)
        header.getparent().remove(header)

        result = '<div>'
        # only return html inside the body tag
        for e in htmldoc.xpath('//xhtml:body/*', namespaces=nsmap):
            result += etree.tostring(e)
        result += '</div>'
        data.setData(result)
        return data


def register():
    return cnxml_to_html()
