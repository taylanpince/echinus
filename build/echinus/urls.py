from django.contrib import admin
from django.conf.urls.defaults import *


admin.autodiscover()


urlpatterns = patterns('',
    # Admin
    (r'^admin/(.*)', admin.site.root),
)
