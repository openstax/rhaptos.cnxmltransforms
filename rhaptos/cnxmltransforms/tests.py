import os
import re
import glob
import unittest
from StringIO import StringIO

from Products.PortalTransforms.data import datastream

from rhaptos.cnxmltransforms.cnxml2html import cnxml_to_html
from rhaptos.cnxmltransforms.cnxml2eiphtml import cnxml_to_eiphtml

dirname = os.path.dirname(__file__)

class TestTransform(unittest.TestCase):

    def setUp(self):
        self.cwd = os.getcwd()
        os.chdir(dirname)

    def tearDown(self):
        os.chdir(self.cwd)

    def test_cnxml2html(self):
        cnxml = open('test.cnxml').read()
        transform = cnxml_to_html()
        data = datastream('test')
        transform.convert(cnxml, data)

    def test_cnxml2eiphtml(self):
        cnxml = open('test.cnxml').read()
        transform = cnxml_to_eiphtml()
        data = datastream('test')
        transform.convert(cnxml, data)

def test_suite():
    from unittest import TestSuite, makeSuite
    suite = TestSuite()
    suite.addTest(makeSuite(TestTransform))
    return suite

