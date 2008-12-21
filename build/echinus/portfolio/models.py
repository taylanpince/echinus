from django.db import models
from django.utils.translation import ugettext_lazy as _

from core.utils.fields import AutoSlugField

from portfolio.managers import ActiveItemsManager


class Category(models.Model):
    """
    A portfolio category
    """
    
    name = models.CharField(_("Name"), max_length=100)
    slug = AutoSlugField(_("Slug"), populate_from="name")
    active = models.BooleanField(_("Active"), default=True)
    order = models.IntegerField(_("Order"), default=0)
    
    # Managers
    admin_objects = models.Manager()
    objects = ActiveItemsManager()
    
    @property
    def pieces(self):
        return Piece.objects.filter(categories=self)
    
    class Meta:
        ordering = ["order"]
        verbose_name = _("Category")
        verbose_name_plural = _("Categories")
    
    def __unicode__(self):
        return self.name


class Piece(models.Model):
    """
    A portfolio piece tied to one or more categories
    """
    
    categories = models.ManyToManyField(Category, verbose_name=_("Categories"))
    active = models.BooleanField(_("Active"), default=True)
    order = models.IntegerField(_("Order"), default=0)
    
    # Managers
    admin_objects = models.Manager()
    objects = ActiveItemsManager()
    
    @property
    def images(self):
        return Image.objects.filter(piece=self)
    
    class Meta:
        ordering = ["order"]
        verbose_name = _("Piece")
        verbose_name_plural = _("Pieces")
    
    def __unicode__(self):
        return u"Piece %s" % self.pk


class Image(models.Model):
    """
    A portfolio image tied to a specific piece
    """
    
    piece = models.ForeignKey(Piece, verbose_name=_("Piece"))
    title = models.CharField(_("Title"), max_length=100)
    description = models.TextField(_("Description"), blank=True)
    file = models.ImageField(_("File"), upload_to="files/portfolio")
    order = models.IntegerField(_("Order"), default=0)
    
    class Meta:
        ordering = ["order"]
        verbose_name = _("Image")
        verbose_name_plural = _("Images")
    
    def __unicode__(self):
        return self.title