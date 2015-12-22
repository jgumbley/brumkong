from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'editorial', views.editorial, name='editorial'),
    url(r'buildings', views.buildings, name='building'),
]
