#!/usr/bin/env python
'''
This software was created by United States Government employees at 
The Center for the Information Systems Studies and Research (CISR) 
at the Naval Postgraduate School NPS.  Please note that within the 
United States, copyright protection is not available for any works 
created  by United States Government employees, pursuant to Title 17 
United States Code Section 105.   This software is in the public 
domain and is not subject to copyright. 
'''

import inspect
import logging
import os
import sys
import re

# FILE_LOG_LEVEL and CONSOLE_LOG_LEVEL
# valid levels are: DEBUG, INFO, WARNING or ERROR
# specifies the log level to file and console respectively
# log to file logging.INFO and above
file_log_level = logging.DEBUG
# log to console logging.WARNING and above
console_log_level = logging.WARNING

class AddPkgLogging():
    def __init__(self, logname):
        #print "filename is (%s)" % logname

        self.logger = logging.getLogger(logname)
        self.logger.setLevel(file_log_level)
        formatter = logging.Formatter('[%(asctime)s - %(levelname)s : %(message)s')

        file_handler = logging.FileHandler(logname)
        file_handler.setLevel(file_log_level)
        file_handler.setFormatter(formatter)

        console_handler = logging.StreamHandler()
        console_handler.setLevel(console_log_level)
        console_handler.setFormatter(formatter)

        self.logger.addHandler(file_handler)
        self.logger.addHandler(console_handler)

    def DEBUG(self, message):
        func = inspect.currentframe().f_back
        #print "func.f_code.co_name is %s" % func.f_code.co_name
        #print "func.f_code.co_filename is %s" % func.f_code.co_filename
        #print "func.f_lineno is %s" % func.f_lineno
        filename = os.path.basename(func.f_code.co_filename)
        lineno = func.f_lineno
        funcname = func.f_code.co_name
        linemessage = '%s:%s - %s() ] %s' % (filename, lineno, funcname[:15], message)
        self.logger.debug(linemessage)

    def INFO(self, message):
        func = inspect.currentframe().f_back
        #print "func.f_code.co_name is %s" % func.f_code.co_name
        #print "func.f_code.co_filename is %s" % func.f_code.co_filename
        #print "func.f_lineno is %s" % func.f_lineno
        filename = os.path.basename(func.f_code.co_filename)
        lineno = func.f_lineno
        funcname = func.f_code.co_name
        linemessage = '%s:%s - %s() ] %s' % (filename, lineno, funcname[:15], message)
        self.logger.info(linemessage)

    def WARNING(self, message):
        func = inspect.currentframe().f_back
        #print "func.f_code.co_name is %s" % func.f_code.co_name
        #print "func.f_code.co_filename is %s" % func.f_code.co_filename
        #print "func.f_lineno is %s" % func.f_lineno
        filename = os.path.basename(func.f_code.co_filename)
        lineno = func.f_lineno
        funcname = func.f_code.co_name
        linemessage = '%s:%s - %s() ] %s' % (filename, lineno, funcname[:15], message)
        self.logger.warning(linemessage)

    def ERROR(self, message):
        func = inspect.currentframe().f_back
        #print "func.f_code.co_name is %s" % func.f_code.co_name
        #print "func.f_code.co_filename is %s" % func.f_code.co_filename
        #print "func.f_lineno is %s" % func.f_lineno
        filename = os.path.basename(func.f_code.co_filename)
        lineno = func.f_lineno
        funcname = func.f_code.co_name
        linemessage = '%s:%s - %s() ] %s' % (filename, lineno, funcname[:15], message)
        self.logger.error(linemessage)

