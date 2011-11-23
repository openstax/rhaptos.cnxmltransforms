import logging
from StringIO import StringIO
from Products.CMFCore.utils import getToolByName
from Products.MimetypesRegistry.MimeTypeItem import MimeTypeItem

log = logging.getLogger('rhaptos.cnxmltransforms-setuphandlers')

cnxml = MimeTypeItem(name="application/cnxml+xml", 
                     mimetypes=("application/cnxml+xml",),
                     extensions=("cnxml",),
                     binary="no",
                     icon_path="application.png")

def register_cnxml_mimetype(portal):
    registry = getToolByName(portal, 'mimetypes_registry')
    log.info('Intalling application/cnxml+xml mimetype')
    registry.register(cnxml)
    log.info('Mimetype application/cnxml+xml installed successfully')


def install_cnxml_to_html(portal):
    log.info('Installing cnxml_to_html transform')
    cnxml_to_html_id = 'cnxml_to_html'
    cnxml_to_html_module = "rhaptos.cnxmltransforms.cnxml2html"
    pt = getToolByName(portal, 'portal_transforms')

    if cnxml_to_html_id not in pt.objectIds():
        pt.manage_addTransform(cnxml_to_html_id, cnxml_to_html_module)
    log.info('cnxml_to_html transform installed successfully')


def install(context):
    if context.readDataFile('rhaptos.cnxmltransforms-marker.txt') is None:
        return
    site = context.getSite()
    register_cnxml_mimetype(site)
    install_cnxml_to_html(site)

