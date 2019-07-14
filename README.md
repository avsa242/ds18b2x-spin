# ds18b2x-spin 
---------------

This is a P8X32A/Propeller driver object for Dallas/Maxim DS18B2x-series temperature sensors.

## Salient Features

* One-wire connection
* Supports reading device serial number
* Supports reading temperature (Celsius, Fahrenheit)

## Requirements

* 1 extra core/cog for the PASM One-Wire driver

## Limitations

* More than one device on the bus untested/unsupported
* Very early in development - may malfunction or outright fail to build
* Doesn't perform CRC checks on data received

## TODO

- [ ] Implement CRC checking
- [ ] Implement resolution setting
- [ ] Test multiple devices on bus
