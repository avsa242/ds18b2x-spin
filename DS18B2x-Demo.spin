CON

    _clkmode    = cfg#_CLKMODE
    _xinfreq    = cfg#_XINFREQ

    LED         = cfg#LED1

    SER_BAUD    = 115_200

    OW_PIN      = 0

    C           = 0
    F           = 1
    SCALE       = F

OBJ

    cfg : "core.con.boardcfg.flip"
    time: "time"
    ds  : "sensor.temperature.ds18b2x.ow"
    ser : "com.serial.terminal.ansi"
    math: "tiny.math.float"
    fs  : "string.float"
    int : "string.integer"

VAR

    byte _ser_cog, _sn[7]

PUB Main | sn_byte, temp

    Setup
    ds.Scale(ds#SCALE_F)

    ser.Position(0, 4)
    ser.Str(string("SN: "))
    ds.SN(@_sn)
    repeat sn_byte from 0 to 5
        ser.Hex(_sn[sn_byte], 2)

    repeat
        temp := ds.Temperature
        ser.Position(0, 5)
        ser.Str(string("Temp: "))
        ser.Dec(temp)
        ser.Newline
        DispTemp(temp)
    Flash(LED, 100)

PUB DispTemp(cent_deg) | temp

    ser.Dec(cent_deg/100)
    ser.Char(".")
    ser.Str(int.DecZeroed(cent_deg//100, 2))

PUB Setup

    repeat until _ser_cog := ser.Start (SER_BAUD)
    time.MSleep(200)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#NL, ser#LF))
    if ds.Start (OW_PIN)
        ser.Str (string("DS18B2x driver started ("))
        case ds.Family
            $28:
                ser.Str(string("DS18B20 found)"))
            OTHER:
                ser.Str(string("UNKNOWN DEVICE found)"))
    else
        ser.Str (string("DS18B2x driver failed to start - halting", ser#NL, ser#LF))
        ds.Stop
        time.MSleep (500)
        ser.Stop
        Flash(LED, 500)

PUB Flash(pin, delay_ms)

    dira[pin] := 1
    repeat   
        !outa[pin]
        time.MSleep (delay_ms)

