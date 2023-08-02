from django.shortcuts import render, redirect
from django.http.response import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from app_plataforma.views import plataforma
# Create your views here.

def render_login(request):
    if request.method == 'GET':
        return render(request, 'index.html')
    else:
        username = request.POST.get('username')
        password = request.POST.get('password')

        user = authenticate(username=username, password = password)

        if user:
            login(request, user)
            return redirect('plataforma')
        else:
            return HttpResponse('Falha em autenticar')