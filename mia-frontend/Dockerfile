FROM skyrkt/nginx-node:1.0.4

# This port is used for things like browsersync or any development server
# change as you see fit
EXPOSE 4200

# We first copy over all the dependancy files and install them
# this allows docker to cache our dependancies which speeds up build by a huge amount
RUN npm install -g bower ember-cli phantomjs-prebuilt
COPY package.json npm-shrinkwrap.json bower.json /var/www/apps/mia.io/
WORKDIR /var/www/apps/mia.io
RUN npm install
RUN bower install --allow-root

# NGINX CONF #

# Create the files needed for logging in nginx
RUN mkdir -p /var/log/mia.io/ && \
    touch /var/log/mia.io/nginx.access.log && \
    mkdir -p /var/log/mia.io/ && \
    touch /var/log/mia.io/nginx.error.log

# Forward these files to standard out/error so we can see our
# nginx logs in the docker output logs
RUN ln -sf /dev/stdout /var/log/mia.io/nginx.access.log && \
    ln -sf /dev/stderr /var/log/mia.io/nginx.error.log

# Move over our nginx configuration (which is editable in this same directory)
# over so we can point to the right files to serve up
COPY .docker/nginx.conf /etc/nginx/sites-available/default.conf
COPY .docker/nginx.conf /etc/nginx/sites-enabled/default.conf
COPY .docker/nginx.conf /etc/nginx/conf.d/default.conf

# END NGINX CONF #

# Copy over the rest of application
COPY . /var/www/apps/mia.io

# Run the compile of the application (probably wont be build:prod for mia)
RUN npm run build

# Start Nginx on run. Command gets run ONCE THE DOCKER IS BUILT, and is overwritable by the command
# option in dockercompose.yml so the dockercompose.yml should run the development server command,
# not nginx.
CMD nginx -g "daemon off;"
