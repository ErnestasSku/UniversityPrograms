from django.contrib import admin
from .models import VATInvoice, Form, InvoiceItem

# Register your models here.

admin.site.register(VATInvoice)
admin.site.register(InvoiceItem)
admin.site.register(Form)