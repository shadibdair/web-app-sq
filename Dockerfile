FROM tomcat 
WORKDIR webapps 
COPY target/WebApp-1.0-SNAPSHOT.war .
RUN rm -rf ROOT && mv WebApp-1.0-SNAPSHOT.war ROOT.war
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]