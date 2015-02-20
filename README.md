CloudFlare DNS backup tool
==========================

This tool allows you to backup your [CloudFlare DNS](https://www.cloudflare.com/dns) settings. It will back them up locally, and optionally push any changes to a git repository.

Install the dependencies with [bundler](http://bundler.io/): ```bundle install```.

Then to use it, you'll need the email address and API token from your CloudFlare account:
```bundle exec ./cloudflare-backup.rb EMAIL TOKEN OUTPUT_DIRECTORY```

You can run this from a cron job to keep up-to-date.

If you want to track your changes, make the OUTPUT_DIRECTORY a git repository. Set up a git remote where changes should be pushed, and create an ```id_rsa``` in this directory so that the backup tool has access to your remote.
