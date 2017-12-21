ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

COPY run.sh /
RUN chmod a+x /run.sh

RUN echo '#!/bin/sh' > /bin/mail
RUN echo 'exit 0' >> /bin/mail
RUN chmod a+x /bin/mail

RUN apk add --no-cache apcupsd jq curl openssh

WORKDIR /data

CMD [ "/run.sh" ]
