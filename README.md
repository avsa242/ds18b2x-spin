# ds18b2x-spin 
--------------

This is a P8X32A/Propeller driver object for Dallas/Maxim DS18B2x-series temperature sensors.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* One-wire connection
* Multi-drop mode for reading multiple bussed devices or single-device mode
* Read device serial number
* Read temperature (Celsius, Fahrenheit)
* Set resolution


## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM One-Wire engine
* `sensor.temp_rh.common.spinh` (source: spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* `sensor.temp_rh.common.spin2h` (source: p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.9.4)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.9.4)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.9.4)       | NuCode       | Untested              |
| P2        | SPIN2    | FlexSpin (6.9.4)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Limitations

* Doesn't support alarms

