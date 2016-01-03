from django.db import models


class Pronouncement(models.Model):
    invective = models.CharField(max_length=10000)
    pub_date = models.DateTimeField('date published')


class TweetManager(models.Manager):

    def get_latest_tweets(self, offset=0, limit=10):
        return self.all().order_by('-published_at')[offset:limit]

    def remove_all(self):
        self.all().delete()


class Tweet(models.Model):
    """
    Cached imported tweet
    """
    tweet_id = models.TextField(u"Twitter ID as String", max_length=200)
    content = models.TextField(u"Tweet Content", max_length=20000)
    published_at = models.DateTimeField(u"Published At")
    updated_at = models.DateTimeField(u"Last Update", auto_now=True)
    created_at = models.DateTimeField(u"Date", auto_now_add=True)

    objects = TweetManager()

    class Meta:
        verbose_name = 'Tweet'
        verbose_name_plural = 'Tweets'

    def __unicode__(self):
        return self.content
