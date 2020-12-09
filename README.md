# Archived

Unfortunately, I just don't have time to maintain this project anymore. This repository is now archived, but will remain in place for anyone still using it. If someone wants to take over maintaining this repo please contact me.

I suggest migrating to the [Community NUT Add-on](https://github.com/hassio-addons/addon-nut). To help you along here's my add-on configuration:

```yaml
users:
  - username: nut
    password: <random pass here>
    instcmds:
      - all
    actions: []
devices:
  - name: apc
    driver: usbhid-ups
    port: auto
    config:
      - desc = "APC Back-UPS 600VA"
      - vendorid = 051d
mode: netserver
shutdown_host: 'false'
```

You can then add the [NUT Integration](https://www.home-assistant.io/integrations/nut/) using:

* Host: `a0d7b954-nut`
* Port: `3493`
* Username: `nut`
* Password: `<random pass here>`

# About

This repository contains just one add-on, an unofficial [apcupsd add-on](https://github.com/korylprince/hassio-apcupsd/tree/master/apcupsd).

# Installation

Add this repository to your [Hass.io](https://home-assistant.io/hassio/) instance:

`https://github.com/korylprince/hassio-apcupsd`

If you have trouble you can follow the [official docs](https://home-assistant.io/hassio/installing_third_party_addons/).

Then install the "APC UPS Daemon" add-on.

# Configuration

See the [apcupsd add-on](https://github.com/korylprince/hassio-apcupsd/tree/master/apcupsd) itself for information on configuring it.

# Issues

If you have an issue with this plugin, please [file an issue](https://github.com/korylprince/hassio-apcupsd/issues).
