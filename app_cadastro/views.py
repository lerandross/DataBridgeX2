from django.shortcuts import render
from django.http.response import HttpResponse
from django.contrib.auth.decorators import login_required
# Create your views here.

@login_required(login_url='/login/')
def cadastro(request):
    return HttpResponse('pagina de cadastro')