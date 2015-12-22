from django.http import HttpResponse
from django.template.loader import get_template
from speaks.models import Tweet


def index(request):
    tweets = Tweet.objects.all()
    return HttpResponse(get_template("frontpage.j2.html")
                        .render({"tweets": tweets})
                        )


def editorial(request):
    return HttpResponse(get_template("editorial.j2.html").render())


def buildings(request):
    return HttpResponse(get_template("buildings.j2.html").render())
