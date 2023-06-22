from django import forms
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.template.loader import get_template
from django.template import Context
from .forms import RegistrationForm
from .models import Form, VATInvoice
from .forms import VATInvoiceForm, InvoiceItemForm



def index(request):
    return render(request, 'index.html')
    # return HttpResponse("Hello, world. You're at the polls index.")


@login_required
def fill_form(request):
    vat_invoice_form = VATInvoiceForm()
    invoice_item_formset = forms.formset_factory(InvoiceItemForm)

    if request.method == 'POST':
        vat_invoice_form = VATInvoiceForm(request.POST)
        formset = invoice_item_formset(request.POST)

        if vat_invoice_form.is_valid() and formset.is_valid():
            vat_invoice = vat_invoice_form.save()
            for form in formset:
                invoice_item = form.save(commit=False)
                invoice_item.vat_invoice = vat_invoice
                invoice_item.save()

            # Redirect to a success page or return an appropriate response
            return redirect('success')

    return render(request, 'fill_form.html', {'vat_invoice_form': vat_invoice_form, 'invoice_item_formset': invoice_item_formset})


@login_required
def view_data(request):
    vat_invoices = VATInvoice.objects.all()
    return render(request, 'view_data.html', {'vat_invoices': vat_invoices})


@login_required
def generate_pdf(request, vat_invoice_id):
    vat_invoice = VATInvoice.objects.get(id=vat_invoice_id)
    template = get_template('pdf_template.html')
    context = {'vat_invoice': vat_invoice}
    html = template.render(context)

    # Generate PDF using your preferred library (e.g., reportlab, weasyprint)
    # ...

    # Return the PDF as a downloadable response
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="vat_invoice.pdf"'
    # Set appropriate PDF content here
    # ...

    return response


def register(request):
    if request.method == 'POST':
        form = RegistrationForm(request.POST)
        if form.is_valid():
            form.save()
            # Redirect to login page after successful registration
            return redirect('login')
    else:
        form = RegistrationForm()
    return render(request, 'register.html', {'form': form})

@login_required
def main(request):

    return render(request, 'main.html')