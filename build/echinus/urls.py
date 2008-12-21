from django.contrib import admin
from django.conf.urls.defaults import *


admin.autodiscover()


urlpatterns = patterns('',
    # Admin
    (r'^admin/(.*)', admin.site.root),
    
    # Home
    url(r'^$', 'django.views.generic.simple.direct_to_template', {
        'template': 'home.html',
    }, name='home'),
    
    # Fake Links
    url(r'^links\.xml', 'django.views.generic.simple.direct_to_template', {
        'template': 'links.xml',
    }, name='links'),
    
    # Portfolio
    (r'^portfolio/', include('portfolio.urls'))
)
