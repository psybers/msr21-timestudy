#!/usr/bin/env python3
# coding: utf-8

import datetime
from sys import argv

print(int(datetime.datetime.strptime(argv[1], '%Y-%m-%dT%H:%M:%S%z').timestamp()))
