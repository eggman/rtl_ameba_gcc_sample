# rtl_ameba_gcc_sample

Realtek ameba gcc build environment

* os : linux
* toolchan : arm-eabi-none-gcc

# usage

```
$ make
...
genrate makebin/ram_all.bin
```
program ram_all.bin to ameba. ( [Programming the RTL8710 via DAP](https://github.com/eggman/RTL8710_DOC/blob/master/ProgrammingRTL8710.md) )




# support chips
* RTL8195AM
* RTL8711AM
* RTL8711AF
* RTL8710AF

# features
## support
* UART
* GPIO
* I2C
* SPI
* FLASH
* PWM
* Timer
* ADC (RTL8195AM only)
* DAC (RTL8195AM only)
* SDRAM (RTL8195AM and RTL8711AM only)
* I2S (HAL only)

## not support
* Wi-Fi
* USB OTG
* Ethernet
* SDIO Host
* SDIO Device
* NFC

Features depend on sdk/lib/lib_platform.a .

# other

This environment is based on https://github.com/neojou/arm-gcc-blink-example
