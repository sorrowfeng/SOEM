# This software is dual-licensed under GPLv3 and a commercial
# license. See the file LICENSE.md distributed with this software for
# full license information.

# macOS backend: libpcap (BPF) based raw Ethernet access.

target_sources(soem PRIVATE
  osal/macosx/osal.c
  osal/macosx/osal_defs.h
  oshw/macosx/oshw.c
  oshw/macosx/oshw.h
  oshw/macosx/nicdrv.c
  oshw/macosx/nicdrv.h
)

target_include_directories(soem PUBLIC
  $<BUILD_INTERFACE:${SOEM_SOURCE_DIR}/osal/macosx>
  $<BUILD_INTERFACE:${SOEM_SOURCE_DIR}/oshw/macosx>
  $<INSTALL_INTERFACE:include/soem>
)

foreach(target IN ITEMS
    soem
    ec_sample
    eepromtool
    eni_test
    firm_update
    simple_ng
    slaveinfo)
  if (TARGET ${target})
    target_compile_options(${target} PRIVATE
      -Wall
      -Wextra
    )
  endif()
endforeach()

find_library(PCAP_LIBRARY pcap)
target_link_libraries(soem PUBLIC pthread ${PCAP_LIBRARY})

if(EC_INSTALL)
  install(FILES
    osal/macosx/osal_defs.h
    oshw/macosx/nicdrv.h
    DESTINATION include/soem
  )
endif()
