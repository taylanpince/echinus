from django.db import models
from django.utils.translation import ugettext_lazy as _

from core.utils.fields import AutoSlugField

from portfolio.managers import ActiveItemsManager


class Category(models.Model):
    """
    A portfolio category
    """
    
    name = models.CharField(_("Name"), max_length=100)
    slug = AutoSlugField(_("Slug"), populate_from="name", max_length=100)
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
    A portfolio piece tied to a category
    """
    
    title = models.CharField(_("Title"), max_length=255)
    slug = AutoSlugField(_("Slug"), populate_from="title", max_length=255)
    category = models.ForeignKey(Category, verbose_name=_("Category"))
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
        return self.title


class Image(models.Model):
    """
    A portfolio image tied to a specific piece
    """
    
    piece = models.ForeignKey(Piece, verbose_name=_("Piece"))
    title = models.CharField(_("Title"), max_length=255, blank=True)
    file = models.ImageField(_("File"), upload_to="files/portfolio")
    thumbnail = models.ImageField(upload_to="files/portfolio", blank=True, null=True)
    order = models.IntegerField(_("Order"), default=0)
    
    class Meta:
        ordering = ["order"]
        verbose_name = _("Image")
        verbose_name_plural = _("Images")
    
    def __unicode__(self):
        return self.title
