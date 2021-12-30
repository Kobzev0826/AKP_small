onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib AKP_KSI_fifo_opt

do {wave.do}

view wave
view structure
view signals

do {AKP_KSI_fifo.udo}

run -all

quit -force
