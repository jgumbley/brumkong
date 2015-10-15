from django.db import models


class Pronouncement(models.Model):
    invective = models.CharField(max_length=10000)
    pub_date = models.DateTimeField('date published')
