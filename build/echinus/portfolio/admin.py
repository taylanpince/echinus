from django.contrib import admin
from django.utils.translation import ugettext_lazy as _

from portfolio.models import Category, Piece, Image


class ImageInline(admin.StackedInline):
    model = Image


class CategoryAdmin(admin.ModelAdmin):
    list_display = ("name", "active", "order")
    list_filter = ["active"]
    
    search_fields = ["name"]
    
    save_on_top = True
    
    fieldsets = (
        (_("Content"), {
            "fields": ("name",),
        }),
        (_("Publication Settings"), {
            "fields": ("active", "slug", "order"),
            "classes": ["collapse"],
        }),
    )


class PieceAdmin(admin.ModelAdmin):
    list_display = ("title", "category", "active", "order")
    list_filter = ["active", "category"]
    
    search_fields = ["title"]
    
    save_on_top = True
    
    inlines = [ImageInline]
    
    fieldsets = (
        (_("Content"), {
            "fields": ("title", "categories",),
        }),
        (_("Publication Settings"), {
            "fields": ("active", "slug", "order"),
            "classes": ["collapse"],
        }),
    )


admin.site.register(Category, CategoryAdmin)
admin.site.register(Piece, PieceAdmin)
