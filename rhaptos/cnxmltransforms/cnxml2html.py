import os
from lxml import etree, html

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
        cnxmldoc = etree.fromstring(orig)

        xslt_root = etree.parse(os.path.join(dirname, 'xsl', 'cnxml2html.xsl'))
        transform = etree.XSLT(xslt_root)
        htmldoc = transform(cnxmldoc)
        result = ''
        # only return html inside the body tag
        for e in htmldoc.xpath('//xhtml:body/*',
                                namespaces={'xhtml':
                                            'http://www.w3.org/1999/xhtml'}):
            result += etree.tostring(e)
        data.setData(result)
        return data


def register():
    return cnxml_to_html()
