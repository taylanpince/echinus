import os
import sys

sys.path.append("/home/taylan/sites/echinus/app")
sys.path.append("/home/taylan/sites/echinus/app/libs")
sys.path.append("/home/taylan/sites/echinus/app/echinus")

os.environ["DJANGO_SETTINGS_MODULE"] = "echinus.settings"

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()
