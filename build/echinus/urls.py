from django.contrib import admin
from django.conf.urls.defaults import *


admin.autodiscover()


urlpatterns = patterns('',
    # Admin
    (r'^admin/(.*)', admin.site.root),
    
    # Home
    url(r'^$', 'django.views.generic.simple.direct_to_template', {
        'template': 'base.html',
    }, name='home'),
    
    # Portfolio
    (r'^portfolio/', include('portfolio.urls'))
)
