FROM 056154071827.dkr.ecr.us-east-1.amazonaws.com/base-image-ruby-version-arg:2.3
MAINTAINER cru.org <wmd@cru.org>

ARG RAILS_ENV=production

COPY Gemfile Gemfile.lock ./

RUN bundle config gems.contribsys.com $SIDEKIQ_CREDS
RUN bundle install --jobs 20 --retry 5 --path vendor
RUN bundle binstub puma rake

COPY . ./

ARG TEST_DB_USER=postgres
ARG TEST_DB_PASSWORD=
ARG TEST_DB_HOST=localhost
ARG TEST_DB_PORT=5432

RUN bundle exec rake db:create db:setup docs:generate RAILS_ENV=test

## Run this last to make sure permissions are all correct
RUN mkdir -p /home/app/webapp/tmp \
             /home/app/webapp/db \
             /home/app/webapp/log \
             /home/app/webapp/public/uploads \
             /home/app/webapp/pages && \
    chmod -R ugo+rw /home/app/webapp/tmp \
                    /home/app/webapp/db \
                    /home/app/webapp/log \
                    /home/app/webapp/public/uploads \
                    /home/app/webapp/pages