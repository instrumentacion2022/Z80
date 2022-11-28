# Z80
Implementación del z80 en Verilog
# Unidad de control

# File register
# RALU
 La unidad aritmética lógica va conectada a los registros A y F. El registro A corresponde al primer operando mientras que el registro F corresponde al valor de las banderas
 EL resultado de la operación se retroalimenta a los registros A y F respectivamente. Para enviar el valor al bus de datos se tiene que pasar el valor nuevamente por el registro y con un demultiplexor a la salida se envía al bus de datos. A continuación se muestra el diagrama de la RALU

![imagen](https://user-images.githubusercontent.com/117603745/204180242-6976b357-0b7a-4f29-b4e8-b5c0a2873969.png)

La ALU cuenta con 20 operaciones aritméticas y lógicas, las cuales son:

- Suma
- Suma con acarreo
- Resta
- Resta con acarreo(Bit de prestado)
- AND
- OR
- XOR
- Comparación
- Incremento
- Decremento
- Rotaciones
- Corrimientos

## Testbench
### ALU
Para probar la ALU se hizo un testbech que comparaba el resultado calculado con la ALU  y el resultado de un archivo externo(Llamado en el proyecto como "Datain.csv").Este archivo fue generado mediante un excel calculando los resultados y banderas con funciones propias de excel.

### ALU con registros A y F

