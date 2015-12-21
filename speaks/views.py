from django.http import HttpResponse
from django.template.loader import get_template


def index(request):
    return HttpResponse(get_template("frontpage.j2.html").render())


def buildings(request):
    return HttpResponse(get_template("buildings.j2.html").render())
