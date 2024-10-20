{
----------------------------------------------------------------------------------------------------
    Filename:       DS18B2x-Demo.spin
    Description:    Demo of the DS18B2x driver
        * Temperature output
    Author:         Jesse Burt
    Started:        Jul 13, 2019
    Updated:        Oct 19, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000

' -- User-modifiable constants
    NR_DEVICES  = 1                             ' set to the maximum number of discoverable sensors
    ADC_RES     = 12                            ' ADC resolution (bits, 9..12)
' --


OBJ

    time:   "time"
    sensor: "sensor.temperature.ds18b2x" | OW_PIN=0
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200


VAR

    long _devs[NR_DEVICES * 2]


PUB main() | temp, i, nr_found, tscl

    setup()

    sensor.temp_scale(sensor.C)                 ' set temperature scale: C, F
    sensor.opmode(sensor.MULTI)                 ' ONE (1 sensor), MULTI

    ' count how many sensors are found on the bus (up to NR_DEVICES)
    nr_found := sensor.search(@_devs, NR_DEVICES)

    i := 0
    repeat nr_found                             ' for each sensor,
        sensor.select(@_devs[i])                '   address it and set its
        sensor.temp_adc_res(ADC_RES)            '   ADC resolution (9..12 bits)
        i += 2

    repeat
        ser.pos_xy(0, 3)
        nr_found := sensor.search(@_devs, NR_DEVICES)

        i := 0
        repeat nr_found                         ' for each sensor,
            sensor.select(@_devs[i])            '   address it
            temp := sensor.temperature()        '   read its temperature
            ser.printf3(@"(%d) %08.8x%08.8x: ", i/2, _devs[i+1], _devs[i])
            tscl := lookupz(sensor.temp_scale(-2): "C", "F", "K")
            ser.printf3(@"Temp. (deg %c): %3.3d.%02.2d\n\r", tscl, (temp / 100), ||(temp // 100))
            i += 2


PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( sensor.start() )
        ser.strln(@"DS18B2x driver started")
    else
        ser.strln(@"DS18B2x driver failed to start - halting")
        repeat


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

