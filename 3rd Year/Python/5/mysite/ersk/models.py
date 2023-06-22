from django.db import models
from django.contrib.auth.models import User

# Create your models here.


class VATInvoice(models.Model):
    seller_company_name = models.CharField(max_length=100)
    buyer_company_name = models.CharField(max_length=100)

class InvoiceItem(models.Model):
    vat_invoice = models.ForeignKey(VATInvoice, on_delete=models.CASCADE, related_name='items')
    name = models.CharField(max_length=100)
    measurement_unit = models.CharField(max_length=50)
    price_without_vat = models.DecimalField(max_digits=10, decimal_places=2)
    vat_tariff = models.DecimalField(max_digits=5, decimal_places=2)
    vat_sum = models.DecimalField(max_digits=10, decimal_places=2)
    total_sum = models.DecimalField(max_digits=10, decimal_places=2)

class Form(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    vat_invoices = models.ManyToManyField(VATInvoice)
