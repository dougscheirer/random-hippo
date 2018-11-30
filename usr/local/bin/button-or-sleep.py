#!/usr/bin/python

from gpiozero import LED, Button
from signal import pause
from time import sleep
import sys

def flash(led, interval, count):
	for i in range(0, count):
		led.off()
		sleep(interval)
		led.on()
		sleep(0.01)
	led.off()
	return

try:
	wait_time = sys.argv[1]
	ledport=sys.argv[2]
	buttonport=sys.argv[3]
except:
	# give up or use default values?
	wait_time = 1000
	ledport = 18
	buttonport = 23

led=LED(ledport)
button=Button(buttonport)

flash(led, 0.5, 4)
retval=button.wait_for_press(int(wait_time))
led.on()
print(retval)
led.close()

