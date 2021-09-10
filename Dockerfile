FROM zenika/alpine-maven:latest
RUN mkdir /opt
COPY  config /opt/config
RUN apk add --update git
RUN git clone https://github.com/Afsana2910/iosynth.git
RUN mv iosynth /opt
RUN mvn package -f /opt/iosynth/pom.xml
WORKDIR /opt/iosynth/target


###Install Python
RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache


WORKDIR /app
COPY crontab.txt /crontab.txt
COPY orchestrator.py /mnt/orchestrator.py
COPY entry.sh /entry.sh
RUN chmod 755 /mnt/orchestrator.py /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]

#ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["/usr/bin/crond", "-f"]

