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

# Host Control

This add-on communicates with the Hass.io API to reboot or poweroff the host (e.g. Raspberry Pi) just like if `apcupsd` was running on the host. It does this by replacing `/sbin/reboot` and `/sbin/poweroff` with scripts that talk to the Hass.io API. To prevent your host from powering off when your battery gets low, see the Advanced Configuration section below.

# Home Assistant Configuration

Home Assistant can communicate with this add-on through the [internal Hass.io network](https://home-assistant.io/developers/hassio/addon_communication/):

```
apcupsd:
  host: a722577e-apcupsd
```

# Advanced Configuration

This add-on supports running scripts on any of the [apcupsd events](http://www.apcupsd.com/manual/manual.html#customizing-event-handling).

### Setup

Use the [SSH](https://home-assistant.io/addons/ssh/) or [Samba](https://home-assistant.io/addons/samba/) add-on to create the scripts directory: `/share/apcupsd/scripts`. Place any script you'd like to run (e.g. `commfailure` or `onbattery`) in this directory.

For example, if you'd like to run a script on the `commfailure` event, create a shell script at `/share/apcupsd/scripts/commfailure` (it *shouldn't* have a `.sh` extension.)

### Tips & Tricks

* `apcupsd` provides scripts for the following events: `commfailure`, `offbattery`, `changeme`, `commok`, `onbattery`. If you provide your own script, it will override the one `apcupsd` provides.
* `curl` and `openssh` are provided for use in scripts. If there is another program you'd like to be included in the image, create an Issue and I'll consider adding it.
* Even if you override an event script, `acpupsd` still runs additional actions on certain events, e.g. `doreboot` and `doshutdown` still reboot or poweroff the host. If you'd like to prevent that action from happening, `exit 99` in your script. See the [guide](http://www.apcupsd.com/manual/manual.html#customizing-event-handling) for more information.

### Email Setup

[msmtp](http://msmtp.sourceforge.net/doc/msmtp.html) is included in the image to allow sending email from scripts. Put your configuration in `/share/apcupsd/msmtprc`. 

**Example Gmail Setup:**

```
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
syslog         on

# Gmail
account        gmail
host           smtp.gmail.com
port           587
from           <your email>
user           <your username>
password       <plain text password>

aliases /etc/aliases

# Set a default account
account default : gmail
```

**Note:** Make sure to include `syslog on` in your configuration so messages will show up in the add-on logs.

If you use the default `apcupsd` scripts, you'll need to provide an alias for `root` in `/share/apcupsd/aliases`:

```
root: <your email>
```
