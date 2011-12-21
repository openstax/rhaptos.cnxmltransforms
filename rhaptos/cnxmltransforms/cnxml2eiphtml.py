import os
from lxml import etree, html

from zope.interface import implements

from Products.PortalTransforms.interfaces import ITransform
from Products.PortalTransforms.utils import log

dirname = os.path.dirname(__file__)

class cnxml_to_eiphtml:
    implements(ITransform)

    __name__ = "cnxml_to_eiphtml"
    inputs = ("application/cnxml+xml",)
    output = "text/x-html-eip"

    def name(self):
        return self.__name__

    def convert(self, orig, data, **kwargs):
        cnxmldoc = etree.fromstring(orig)

        xslt_root = etree.parse(os.path.join(dirname, 'xsl',
                                             'editInPlace.xsl'))
        transform = etree.XSLT(xslt_root)
        htmldoc = transform(cnxmldoc)
        data.setData(etree.tostring(htmldoc))
        return data


def register():
    return cnxml_to_eiphtml()
