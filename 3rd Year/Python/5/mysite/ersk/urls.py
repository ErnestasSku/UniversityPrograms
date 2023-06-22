from django.urls import path
from django.contrib.auth.views import LoginView, LogoutView
from .views import register

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path('fill-form/', views.fill_form, name='fill_form'),
    path('view-data/', views.view_data, name='view_data'),
    path('generate-pdf/<int:form_id>/', views.generate_pdf, name='generate_pdf'),
    path('login/', LoginView.as_view(template_name='login.html'), name='login'),
    path('register/', register, name='register'),
    path('logout/', LogoutView.as_view(next_page='login'), name='logout'),
    path('main/', views.main, name="main"),
]
