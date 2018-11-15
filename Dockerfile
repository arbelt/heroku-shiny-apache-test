FROM albertw/r-apache:devel
COPY /apache.conf /etc/apache2/sites-available/shiny.conf
COPY /01_hello /app
CMD ["/runApp.r", "/app"]
