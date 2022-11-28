# Z80
Implementación del z80 en Verilog
# Unidad de control

#File register
#RALU
 La unidad aritmética lógica va conectada a los registros A y F. El registro A corresponde al primer operando mientras que el registro F corresponde al valor de las banderas
 EL resultado de la operación se retroalimenta a los registros A y F respectivamente. Para enviar el valor al bus de datos se tiene que pasar el valor nuevamente por el registro y con un demultiplexor a la salida se envía al bus de datos. A continuación se muestra el diagrama de la RALU
 ![imagen](https://user-images.githubusercontent.com/117603745/204168525-1379319e-1123-443b-9164-cb5d86a4cec3.png)
#Testbench

# Simulación
En la primera suma se provoca el error al proposito (A4h) 164 más (94h) 184 es 312 que en 8 bits es 56 (38h)
![imagen](https://user-images.githubusercontent.com/117603745/201577391-dc2cde70-e3f4-49ae-ab60-abc5fda9744d.png)


