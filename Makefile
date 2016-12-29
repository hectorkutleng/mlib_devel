# Auto Generated by Xilinx generate_app. Modify at your own risk

# Reduce HEAP_SIZE while diagnostic messages are enabled
HEAP_SIZE = 0x3800

CC := mb-gcc
CC_FLAGS := -MMD -MP -mlittle-endian -mxl-soft-mul -mcpu=v10.0
CFLAGS := -ffunction-sections -fdata-sections
CFLAGS_PEDANTIC := -Wall -Werror
LN_FLAGS := -Wl,--start-group,-lxil,-lgcc,-lc,--end-group \
            -Wl,--gc-sections \
            -Wl,-Map=map \
            -Wl,--strip-debug \
            -Wl,--defsym=_HEAP_SIZE=$(HEAP_SIZE)

c_SOURCES := $(wildcard *.c)

# Add just the LwIP sources that we need
c_SOURCES += lwip/src/core/def.c           \
             lwip/src/core/init.c          \
             lwip/src/core/inet_chksum.c   \
             lwip/src/core/ip.c            \
             lwip/src/core/mem.c           \
             lwip/src/core/memp.c          \
             lwip/src/core/netif.c         \
             lwip/src/core/pbuf.c          \
             lwip/src/core/stats.c         \
             lwip/src/core/timeouts.c      \
             lwip/src/core/udp.c           \
             lwip/src/core/ipv4/autoip.c   \
             lwip/src/core/ipv4/dhcp.c     \
             lwip/src/core/ipv4/etharp.c   \
             lwip/src/core/ipv4/icmp.c     \
             lwip/src/core/ipv4/ip4.c      \
             lwip/src/core/ipv4/ip4_addr.c \
             lwip/src/netif/ethernet.c     \
             lwip/src/apps/tftp/tftp_server.c

S_SOURCES := $(wildcard *.S)
s_SOURCES := $(wildcard *.s)
INCLUDES := $(wildcard *.h)
OBJS := $(patsubst %.c, %.o, $(c_SOURCES))
OBJS += $(patsubst %.S, %.o, $(S_SOURCES))
OBJS += $(patsubst %.s, %.o, $(s_SOURCES))
LSCRIPT := -Tlscript.ld

# Variables related to core_info data
OBJCOPY = mb-objcopy
OBJFMT = elf32-microblazeel
OBJARCH = MicroBlaze
core_info_BINARY = $(wildcard core_info.bin)
OBJS += $(patsubst %.bin, %.o, $(core_info_BINARY))
CFLAGS += -DEXTERN_CORE_INFO=$(words $(core_info_BINARY))

CURRENT_DIR = $(shell pwd)
DEPFILES := $(patsubst %.o, %.d, $(OBJS))
LIBS := bsp/microblaze_0/lib/libxil.a
EXEC := executable.elf

INCLUDEPATH := -Ibsp/microblaze_0/include -I. -Ijam_lwip/include -Ilwip/src/include
LIBPATH := -Lbsp/microblaze_0/lib

export CFLAGS

all: symbols

$(EXEC): $(LIBS) $(OBJS) $(INCLUDES)
	$(CC) -o $@ $(OBJS) $(CC_FLAGS) $(CFLAGS) $(LN_FLAGS) $(LIBPATH) $(LSCRIPT)

$(LIBS):
	$(MAKE) -C bsp

%.o:%.c
	$(CC) $(CC_FLAGS) $(CFLAGS) $(CFLAGS_PEDANTIC) -c $< -o $@ $(INCLUDEPATH)

%.o:%.S
	$(CC) $(CC_FLAGS) $(CFLAGS) $(CFLAGS_PEDANTIC) -c $< -o $@ $(INCLUDEPATH)

%.o:%.s
	$(CC) $(CC_FLAGS) $(CFLAGS) $(CFLAGS_PEDANTIC) -c $< -o $@ $(INCLUDEPATH)

core_info.o: core_info.bin
	$(OBJCOPY) -I binary -O $(OBJFMT) -B $(OBJARCH) $< $@

symbols: $(EXEC)
	mb-readelf -s $< | sort -rnk3 > $@

tags:
	ctags -R

clean:
	$(MAKE) -C bsp clean
	rm -rf $(OBJS) $(LIBS) $(EXEC) *.o tags

.PHONY: clean tags

-include $(DEPFILES)
