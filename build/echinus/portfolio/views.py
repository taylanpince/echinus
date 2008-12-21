from django.template import RequestContext
from django.shortcuts import render_to_response

from portfolio.models import Category


def categories(request):
    """
    A list of categories in XML format
    """
    
    return render_to_response("categories.xml", {
        "categories": Category.objects.all(),
    }, context_instance=RequestContext(request), mimetype="text/xml")