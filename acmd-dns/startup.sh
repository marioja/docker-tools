#!/usr/bin/bash
docker run --rm --name acmedns                 \
 -p 53:53                                      \
 -p 53:53/udp                                  \
 -p 80:80                                      \
 -v config:/etc/acme-dns:ro      \
 -v data:/var/lib/acme-dns       \
 -d joohoi/acme-dns