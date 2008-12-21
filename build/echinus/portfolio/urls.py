from django.conf.urls.defaults import *


urlpatterns = patterns('portfolio.views',
    # Categories
    url(r'^categories\.xml$', 'categories', name='categories'),
)
