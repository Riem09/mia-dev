FROM skyrkt/ruby-node-passenger

ENV RAILS_ENV development

WORKDIR /var/www/apps/mia.io
ADD Gemfile Gemfile.lock /var/www/apps/mia.io/
RUN bundle install

# Apache2 Conf
COPY .docker/apache.conf /etc/apache2/sites-enabled/000-default.conf
RUN mkdir -p /var/log/mia.io

RUN ln -sf /dev/stdout /var/log/mia.io/access.log && \
    ln -sf /dev/stderr /var/log/mia.io/error.log

#Install Rails App
ADD . /var/www/apps/mia.io
WORKDIR /var/www/apps/mia.io
RUN chown -R www-data:www-data /var/www/
RUN chmod 744 -R /var/www/

EXPOSE 3000

CMD rake db:migrate && /usr/sbin/apache2ctl -D FOREGROUND
