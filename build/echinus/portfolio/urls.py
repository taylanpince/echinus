from django.conf.urls.defaults import *


urlpatterns = patterns('portfolio.views',
    # Categories
    url(r'^categories/$', 'categories', name='categories'),
)
