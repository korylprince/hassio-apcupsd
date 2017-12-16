# About

This unofficial add-on gives you the ability to connect an APC UPS to your [Hass.io](https://home-assistant.io/hassio/) device and monitor it with the [apcupsd component](https://home-assistant.io/components/apcupsd/).

# Installation

See the actual [repository](https://github.com/korylprince/hassio-apcupsd/) for installation instructions.

# Configuration

The default options will work for most modern APC UPSs. The following table shows the default options:

Configuration Option | `apcupsd.conf` Equivalent | Default Value
---------------------|---------------------------|--------------
name | UPSNAME | APC UPS
cable | UPSCABLE | usb
type | UPSTYPE | usb
device | DEVICE | \<unset\>

You can also override any setting in `apcupsd.conf` using the `extra` configuration option:

```json
...
"extra": [
    {"key": "KILLDELAY", "val": 10},
    {"key": "NISPORT", "val": 5555}
],
...
```

Note: If you're wondering why the excessive syntax, currently it's not possible to have an arbitrary map with the Hass.io schema.

For help with configuring apcupsd itself, see the [manual](http://www.apcupsd.com/manual/manual.html).

# Home Assistant Configuration

Home Assistant can communicate with this add-on through the [internal Hass.io network](https://home-assistant.io/developers/hassio/addon_communication/):

```
apcupsd:
  host: a722577e-apcupsd
```
