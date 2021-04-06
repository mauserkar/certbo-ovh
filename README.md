# Usage
docker run -it --rm  \
  --name certbot-ovh-dns \
  -v <local/path/to/save/certs> \
  -e OVH_AKEY=<application key> \
  -e OVH_SECRET=<secret> \
  -e OVH_CKEY=<customer key> \
  -e CERTBOT_EMAIL=<email> \
  -e CERTBOT_DOMAIN=<wildcard.domain.com> \
  carlosgaro/certbot-ovh
