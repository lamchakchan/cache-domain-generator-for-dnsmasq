#cache-domain-generator-for-dnsmasq
A cron script wrapped in a docker image that pulls from this [`uklans/cache-domains`](https://github.com/uklans/cache-domains) to make a `dnsmasq` configuration file.  This process supports timely updates for CDN cache routing for [Lancache](https://lancache.net/docs/installation/docker/) when coupled with [PiHole](https://github.com/pi-hole/pi-hole).

## Docker Hub
This image is build to the following repository on `hub.docker.com`.

* [`lamchakchan/cache-domain-generator-for-dnsmasq`](https://hub.docker.com/repository/docker/lamchakchan/cache-domain-generator-for-dnsmasq)

## Unraid Docker Template
* [`cache-domain-generator.xml`](cache-domain-generator.xml)

## Configurations

### `CACHE_DOMAIN_GIT_URL`
The Git repository referenced for building out the Lancache CDN redirections.

* Defaults to `https://github.com/uklans/cache-domains.git`.

### `CRON_EXPRESSION`
The cron schedule to use for how often to trigger this job.

* Defaults to every minute.

### `LANCACHE_IP`
The network target to offload cache traffic to for the redirection rules.  This value can be an IPv4 or host name address.

* No defaults

### Bind Mount for `/etc/dnsmasq.d`
The job writes the output to `/etc/dnsmasq.d`.  Bind mount the host volume to this container path to share the output with the DNS service such as PiHole.
