onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clock
add wave -noupdate /tb/reset
add wave -noupdate -divider {fluxo IN e OUT}
add wave -noupdate /tb/din
add wave -noupdate /tb/dout
add wave -noupdate -radix hexadecimal /tb/DUT/data
add wave -noupdate -divider PROGRAMACAO
add wave -noupdate -radix unsigned /tb/prog
add wave -noupdate -divider ALARME
add wave -noupdate /tb/DUT/match(0)
add wave -noupdate /tb/DUT/match(1)
add wave -noupdate /tb/DUT/match(2)
add wave -noupdate /tb/DUT/match(3)
add wave -noupdate /tb/alarme
add wave -noupdate -radix unsigned /tb/numero
add wave -noupdate /tb/DUT/EA
add wave -noupdate -divider PADROES
add wave -noupdate -radix hexadecimal /tb/padrao
add wave -noupdate /tb/DUT/sel(0)
add wave -noupdate -radix hexadecimal /tb/DUT/gen(0)/CD/padrao
add wave -noupdate /tb/DUT/sel(1)
add wave -noupdate -radix hexadecimal /tb/DUT/gen(1)/CD/padrao
add wave -noupdate /tb/DUT/sel(2)
add wave -noupdate -radix hexadecimal /tb/DUT/gen(2)/CD/padrao
add wave -noupdate /tb/DUT/sel(3)
add wave -noupdate -radix hexadecimal /tb/DUT/gen(3)/CD/padrao
add wave -noupdate -divider {test bench}
add wave -noupdate -radix unsigned /tb/conta_tempo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1088 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 154
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 3
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 2000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {1094 ns}
