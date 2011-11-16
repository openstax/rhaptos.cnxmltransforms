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

        xslfile = open(os.path.join(dirname, 'cnxml2html.xsl'))
        xslt_root = etree.XML(xslfile.read())
        transform = etree.XSLT(xslt_root)
        htmldoc = transform(cnxml)
        html = etree.tostring(htmldoc)
        xslfile.close()

        data.setData(html)
        return data


def register():
    return markdown()
