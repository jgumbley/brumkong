from django.http import HttpResponse
from django.template.loader import get_template
from speaks.models import Tweet
import datetime


def nice_date():
    """Move this please
    """
    today = datetime.date.today()
    # todo add th, nd, st etc.
    return today.strftime('%d %B %Y')


def index(request):
    tweets = Tweet.objects.all()
    date = nice_date()
    return HttpResponse(get_template("frontpage.j2.html")
                        .render({"tweets": tweets,
                                 "date": date})
                        )


def editorial(request):
    return HttpResponse(get_template("editorial.j2.html").render())


def buildings(request):
    return HttpResponse(get_template("buildings.j2.html").render())
