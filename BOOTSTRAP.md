Bootstrapping the app in Heroku
-------------------------------

There is the notion of a Django environment. Steps to bootstrap (i.e. new env, not done by pipeline).

 - Create new app in Heroku
 - Login to via Heroku toolbelt
 - Run 'heroku run python manage.py syncdb'
 - Setup in Snap per: https://docs.snap-ci.com/deployments/heroku-deployments/
