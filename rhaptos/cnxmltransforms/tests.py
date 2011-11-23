import os
import re
import glob
import unittest
from StringIO import StringIO

from Products.PortalTransforms.data import datastream

from rhaptos.cnxmltransforms.cnxml2html import cnxml2html

dirname = os.path.dirname(__file__)

class TestTransform(unittest.TestCase):

    def setUp(self):
        self.cwd = os.getcwd()
        os.chdir(dirname)

    def tearDown(self):
        os.chdir(self.cwd)

    def test_transform(self):
        cnxml = open('test.cnxml').read()
        transform = cnxml2html()
        data = datastream('test')
        transform.convert(cnxml, data)

def test_suite():
    from unittest import TestSuite, makeSuite
    suite = TestSuite()
    suite.addTest(makeSuite(TestTransform))
    return suite

