import os
from lxml import etree, html

from zope.interface import implements

from Products.PortalTransforms.interfaces import ITransform
from Products.PortalTransforms.utils import log

dirname = os.path.dirname(__file__)

class cnxml2html:
    implements(ITransform)

    __name__ = "cnxml2html"
    inputs = ("text/cnxml",)
    output = "text/html"

    def name(self):
        return self.__name__

    def convert(self, orig, data, **kwargs):
        cnxml = orig.decode('utf-8')
        cnxmldoc = etree.fromstring(cnxml)

        xslt_root = etree.parse(os.path.join(dirname, 'xsl', 'cnxml2html.xsl'))
        transform = etree.XSLT(xslt_root)
        htmldoc = transform(cnxmldoc)
        html = etree.tostring(htmldoc)

        data.setData(html)
        return data


def register():
    return markdown()
