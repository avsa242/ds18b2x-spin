# ds18b2x-spin 
--------------

This is a P8X32A/Propeller driver object for Dallas/Maxim DS18B2x-series temperature sensors.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* One-wire connection
* Supports reading device serial number
* Supports reading temperature (Celsius, Fahrenheit)
* Supports setting sensor resolution

## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM One-Wire driver

P2/SPIN2:
* p2-spin-standard-library

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)
* P2/SPIN2: FastSpin (tested with 4.1.10-beta)
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* More than one device on the bus untested/unsupported
* Very early in development - may malfunction or outright fail to build
* Doesn't perform CRC checks on data received

## TODO

- [ ] Implement CRC checking
- [x] Implement resolution setting
- [ ] Implement alarms
- [ ] Test multiple devices on bus
