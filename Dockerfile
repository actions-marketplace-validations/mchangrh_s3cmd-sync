FROM alpine:edge
RUN apk add --no-cache s3cmd
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]