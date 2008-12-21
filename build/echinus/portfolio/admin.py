from django.contrib import admin
from django.utils.translation import ugettext_lazy as _

from portfolio.models import Category, Piece, Image


class ImageInline(admin.TabularInline):
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


class CommentAdmin(BatchModelAdmin):
    list_display = ("post", "author", "email", "body", "creation_date", "change_date", "published")
    list_filter = ["published"]
    
    search_fields = ("author", "email", "body", "url")
    
    save_on_top = True
    
    inlines = [ImageInline]
    
    fieldsets = (
        (_("Relations"), {
            "fields": ("categories",),
        }),
        (_("Publication Settings"), {
            "fields": ("active", "order"),
            "classes": ["collapse"],
        }),
    )


admin.site.register(Category, CategoryAdmin)
admin.site.register(Piece, PieceAdmin)