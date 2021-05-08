# ds18b2x-spin 
--------------

This is a P8X32A/Propeller driver object for Dallas/Maxim DS18B2x-series temperature sensors.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* One-wire connection
* Read device serial number
* Read temperature (Celsius, Fahrenheit)
* Set resolution

## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM One-Wire driver

P2/SPIN2:
* p2-spin-standard-library

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81), FlexSpin (tested with 5.0.6-beta)
* P2/SPIN2: FlexSpin (tested with 5.0.6-beta)
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* Doesn't perform CRC checks on data received
* Doesn't support alarms

## TODO

- [x] Implement CRC checking
- [x] Implement resolution setting
- [ ] Implement alarms
- [x] Test multiple devices on bus
- [x] Port to P2/SPIN2
