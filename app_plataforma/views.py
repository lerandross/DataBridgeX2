from django.shortcuts import render
from django.http.response import HttpResponse
from django.contrib.auth.decorators import login_required

# Create your views here.

@login_required(login_url='/login/')
def plataforma(request):
    if request.method == 'GET':
        return render(request, 'plataforma/index.html')
    else:
        print(request.POST)
        return HttpResponse('teste')