from django.contrib import admin
from .models import Products
from import_export.admin import ImportExportModelAdmin

class ProductAdmin(ImportExportModelAdmin):
    exclude = ('product_id','id',)
    list_display = ('name', 'brand', 'description', 'product_id', 'availability', 'price', 'avg_rating')

admin.site.register(Products, ProductAdmin)

