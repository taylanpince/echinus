import re

from django.db.models import SlugField
from django.template.defaultfilters import slugify


class AutoSlugField(SlugField):
    """
    A SlugField that populates itself automatically, adds an index number if 
    multiple objects with the same slug exists. Based on the AutoSlugField 
    from django_extensions.
    
    Required arguments:
    
        populate_from
            Specifies which field the slug is generated from
    
    Optional arguments:
    
        separator
            Defines the used separator (default: '-')
        
        overwrite
            If set to True, overwrites the slug on every save (default: False)
    """
    def __init__(self, *args, **kwargs):
        kwargs.setdefault("blank", True)
        
        self.populate_from = kwargs.pop("populate_from", None)
        
        if self.populate_from is None:
            raise ValueError("Missing 'populate_from' argument for AutoSlugField")
        
        self.separator = kwargs.pop("separator",  u"-")
        self.overwrite = kwargs.pop("overwrite", False)
        
        super(AutoSlugField, self).__init__(*args, **kwargs)
    
    def strip_slug(self, value):
        """
        Cleans up a slug by removing slug separator characters that occur at
        the beginning or end of a slug.
        
        If an alternate separator is used, it will also replace any instances
        of the default '-' separator with the new separator.
        """
        re_sep = "(?:-|%s)" % re.escape(self.separator)
        value = re.sub("%s+" % re_sep, self.separator, value)
        
        return re.sub(r"^%s+|%s+$" % (re_sep, re_sep), "", value)
    
    def create_slug(self, model_instance, add):
        # Get fields to populate from and slug field to set
        populate_field = model_instance._meta.get_field(self.populate_from)
        slug_field = model_instance._meta.get_field(self.attname)
        
        if (add or self.overwrite) and getattr(model_instance, self.attname) == "":
            # Slugify the original field content and set next step to 2
            slug = slugify(getattr(model_instance, populate_field.attname))
            next = 2
        else:
            # Get slug from the current model instance and calculate next step from its number, clean-up
            if getattr(model_instance, self.attname) == "":
                slug = slugify(getattr(model_instance, populate_field.attname))
            else:
                slug = self.strip_slug(getattr(model_instance, self.attname))
            
            next = slug.split(self.separator)[-1]
            
            if next.isdigit():
                slug = self.separator.join(slug.split(self.separator)[:-1])
                next = int(next)
            else:
                next = 2
        
        # Strip slug depending on max_length attribute of the slug field and clean-up
        slug_len = slug_field.max_length
        
        if slug_len:
            slug = slug[:slug_len]
        
        slug = self.strip_slug(slug)
        original_slug = slug
        
        # Exclude the current model instance from the queryset used in finding the next valid slug
        queryset = model_instance.__class__._default_manager.all()
        
        if model_instance.pk:
            queryset = queryset.exclude(pk=model_instance.pk)
        
        # Increases the number while searching for the next valid slug depending on the given slug, clean-up
        while not slug or queryset.filter(**{self.attname: slug}):
            slug = original_slug
            end = "%s%s" % (self.separator, next)
            end_len = len(end)
            
            if slug_len and len(slug) + end_len > slug_len:
                slug = slug[:slug_len - end_len]
                slug = self.strip_slug(slug)
            
            slug = "%s%s" % (slug, end)
            next += 1
        
        return slug
    
    def pre_save(self, model_instance, add):
        value = unicode(self.create_slug(model_instance, add))
        setattr(model_instance, self.attname, value)
        
        return value
    
    def get_internal_type(self):
        return "SlugField"
