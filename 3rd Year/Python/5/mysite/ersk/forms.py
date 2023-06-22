from django import forms
from .models import VATInvoice, InvoiceItem
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User


class VATInvoiceForm(forms.ModelForm):
    class Meta:
        model = VATInvoice
        fields = ['seller_company_name', 'buyer_company_name']

class InvoiceItemForm(forms.ModelForm):
    class Meta:
        model = InvoiceItem
        fields = ['name', 'measurement_unit', 'price_without_vat', 'vat_tariff', 'vat_sum', 'total_sum']


class RegistrationForm(UserCreationForm):
    email = forms.EmailField()
    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']