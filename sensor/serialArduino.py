from time import sleep
import serial
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

ser = serial.Serial('/dev/ttyUSB0', 9600)
counter = 32

try:
	while True:
		counter += 1
		print ser.readline()
		sleep(.1)
		channel.basic_publish(exchange='',routing_key='hello',body=ser.readline())
		if counter == 255:
			counter = 32

finally:
	connection.close()
