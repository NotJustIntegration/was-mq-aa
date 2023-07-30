
#!/bin/bash

podman stop -a
podman rm -a
podman build -t was-mq-aa .
podman run -d -p 0.0.0.0:9080:9080  was-mq-aa
podman ps
