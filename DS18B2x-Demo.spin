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

VAR

    byte _ser_cog, _sn[7]

PUB Main | sn_byte

    Setup

    ser.Position(0, 4)
    ser.Str(string("SN: "))
    ds.SN(@_sn)
    repeat sn_byte from 0 to 5
        ser.Hex(_sn[sn_byte], 2)

    repeat
        ser.Position(0, 5)
        ser.Str(string("Temp: "))
        DispTemp
    Flash(LED, 100)

PUB DispTemp | temp
{
    case SCALE
        C:
            temp := math.FFloat(ds.Temperature)
            temp := math.FDiv(temp, 100.0)
            temp := fs.FloatToString(temp)
            ser.Str(temp)
        F:
            temp := ds.Temperature
            temp := temp * 9 / 5 + 32_00
            temp := math.FFloat(temp)
            temp := math.FDiv(temp, 100.0)
            temp := fs.FloatToString(temp)
            ser.Str(temp)}
  temp := ds.Temperature
  if (temp > 0)
    temp := (temp/10) * 9 / 5 + 32_0
  else
    temp := 32_0 - (||temp * 9 / 5)

  if (temp < 0)
    ser.Char("-")
    ||temp

  ser.dec(temp / 10)
  ser.Char(".")
  ser.dec(temp // 10)
  ser.Char(176)
  ser.Char("F")
  ser.Chars(32, 5)


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

