.SUFFIXES: .o .a .c .s

DEV_NUL=/dev/null

CHIP=ameba

RM=rm -f

CROSS_COMPILE = arm-none-eabi-
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
SIZE = $(CROSS_COMPILE)size

SDK_SRC_BASE_PATH = sdk/src

vpath %.c ./src
vpath %.c $(SDK_SRC_BASE_PATH)/targets/cmsis/target_rtk/target_8195a

INCLUDES += -I$(SDK_SRC_BASE_PATH)/targets/cmsis
INCLUDES += -I$(SDK_SRC_BASE_PATH)/targets/cmsis/target_rtk/target_8195a
INCLUDES += -I$(SDK_SRC_BASE_PATH)/targets/hal/target_rtk/target_8195a
INCLUDES += -I$(SDK_SRC_BASE_PATH)/targets/hal/target_rtk/target_8195a/rtl8195a
INCLUDES += -I$(SDK_SRC_BASE_PATH)/sw/lib/sw_lib/mbed/hal
INCLUDES += -I$(SDK_SRC_BASE_PATH)/sw/lib/sw_lib/mbed/targets/hal/rtl8195a/
INCLUDES += -I$(SDK_SRC_BASE_PATH)/sw/os

OUTPUT_PATH=build

CFLAGS = -g -mcpu=cortex-m3
CFLAGS += -mthumb
CFLAGS += -c -nostartfiles -fno-short-enums
CFLAGS += -Wall -Wpointer-arith -Wstrict-prototypes -Wundef
CFLAGS += -Wno-write-strings
CFLAGS += -MMD -MP
CFLAGS += -fno-common -fmessage-length=0 -fno-exceptions 
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -fomit-frame-pointer 
CFLAGS += -std=gnu99
CFLAGS += -O2 $(INCLUDES) -D$(CHIP)

ASFLAGS = -mcpu=cortex-m3 -mthumb -Wall -a -g $(INCLUDES)

C_SRC+=$(wildcard $(SDK_SRC_BASE_PATH)/targets/cmsis/target_rtk/target_8195a/app_start.c)
C_SRC+=$(wildcard src/*.c)

C_OBJ_TEMP=$(patsubst %.c, %.o, $(notdir $(C_SRC)))

# during development, remove some files
C_OBJ_FILTER=

C_OBJ=$(filter-out $(C_OBJ_FILTER), $(C_OBJ_TEMP))

ELF_FLAGS= -O2 -Wl,--gc-sections -mcpu=cortex-m3 -mthumb --specs=nano.specs
ELF_FLAGS+= -Lsdk/lib -Lsdk/scripts -Tsdk/scripts/rlx8195a.ld -Wl,-Map=$(OUTPUT_PATH)/target.map 
ELF_FLAGS+= -Wl,--cref -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--no-enum-size-warning

ELF_LDLIBS= sdk/lib/startup.o -l_platform -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

all: makebin/ram_all.bin

makebin/ram_all.bin: $(OUTPUT_PATH)/target.axf
	cd ./makebin && /bin/bash ./makebin.sh

$(OUTPUT_PATH)/target.axf: $(addprefix $(OUTPUT_PATH)/,$(C_OBJ))
	echo build all objects
	$(CC) $(ELF_FLAGS) -o $(OUTPUT_PATH)/target.axf -Wl,--start-group $^ -Wl,--end-group $(ELF_LDLIBS)
	$(SIZE) $(OUTPUT_PATH)/target.axf 

$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: %.c
	@echo "$(CC) -c $(CFLAGS) $< -o $@"
	@"$(CC)" -c $(CFLAGS) $< -o $@

clean:
	@echo clean
	-@$(RM) $(OUTPUT_PATH)/target.* 1>$(DEV_NUL) 2>&1
	-@$(RM) $(OUTPUT_PATH)/*.d 1>$(DEV_NUL) 2>&1
	-@$(RM) $(OUTPUT_PATH)/*.o 1>$(DEV_NUL) 2>&1
	-@$(RM) $(OUTPUT_PATH)/*.i 1>$(DEV_NUL) 2>&1
	-@$(RM) $(OUTPUT_PATH)/*.s 1>$(DEV_NUL) 2>&1
	-@$(RM) ./makebin/target* 1>$(DEV_NUL) 2>&1
	-@$(RM) ./makebin/*.bin 1>$(DEV_NUL) 2>&1

