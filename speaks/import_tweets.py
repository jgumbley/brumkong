import tweepy
from django.conf import settings
from django.db import transaction

from speaks.models import Tweet


class ImportTweets:

    def __init__(self):
        self.consumer_key = settings.TWITTER_FEED_CONSUMER_PUBLIC_KEY
        self.consumer_secret = settings.TWITTER_FEED_CONSUMER_SECRET
        self.o_auth_token = settings.TWITTER_FEED_OPEN_AUTH_TOKEN
        self.o_auth_secret = settings.TWITTER_FEED_OPEN_AUTH_SECRET

    def update_tweets(self):
        raw_tweets = self._get_latest_tweets_from_api()
        tweets = [self._tweepy_status_to_tweet(status=status) for status in raw_tweets]
        self._replace_all_tweets(tweets)

    def _get_latest_tweets_from_api(self):
        """
        http://pythonhosted.org/tweepy/html/index.html
        """
        auth = tweepy.OAuthHandler(self.consumer_key, self.consumer_secret)
        auth.set_access_token(self.o_auth_token, self.o_auth_secret)
        api = tweepy.API(auth)

        return api.user_timeline()

    def _tweepy_status_to_tweet(self, status):
        """
        Fields documentation: https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
        """
        tweet = Tweet()
        tweet.published_at = status.created_at
        tweet.tweet_id = status.id_str
        from ttp import ttp
        p = ttp.Parser()
        tweet.content = p.parse(status.text).html
        if hasattr(status, 'retweeted_status') and status.retweeted_status:
            tweet.content = p.parse(status.retweeted_status.text).html
        return tweet

    @transaction.atomic
    def _replace_all_tweets(self, new_tweets):
        Tweet.objects.remove_all()

        for tweet in new_tweets:
            tweet.save()
