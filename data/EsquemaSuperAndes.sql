--- Sentencias SQL para la creación del esquema de parranderos

--Uso:
--Copie el contenido de este archivo y péguelo en una pestaña SQL de SQLDeveloper
--Ejecútelo como un script con el botón correspondiente

--Creación de la tabla User y especificación de sus restricciones
CREATE TABLE User (id Number PRIMARY KEY, login varchar(20), password varchar(20), nombre varchar(40), correo varchar(30), tipo varchar(20)),
CONSTRAINT User_PK PRIMARY KEY (id);

ALTER TABLE User
ADD CONSTRAINT user_tipo 
CHECK ()tipo IN ('empresa', 'persona'))
ENABLE;

--Creación de la tabla Empresas
CREATE TABLE Empresa (NIT Number, idUser Number, dir varchar(30), puntos Number, tipoEmpresa varchar(10)),
CONSTRAINT Empresa_PK PRIMARY KEY (NIT);

ALTER TABLE Empresa
ADD CONSTRAINT Empresa_FK_idUser
FOREIGN KEY (idUser)
REFERENCES User
ENABLE;

ALTER TABLE Empresa
ADD CONSTRAINT Empresa_tipoEmpresa
CHECK (tipoEmpresa IN ('cliente', 'proveedor'))
ENABLE;

--Creación de la tabla Personas
CREATE TABLE Persona(cedula Number,idUser Number, puntos Number, idSucursal Number, tipoPersona varchar(10)),
CONSTRAINT Persona_PK PRIMARY KEY (cedula);

ALTER TABLE Persona
ADD CONSTRAINT Persona_FK_idUser
FOREIGN KEY (idUser)
REFERENCES User
ENABLE;

ALTER TABLE Persona
ADD CONSTRAINT Persona_tipoPersona
CHECK (tipoPersona IN ('cliente', 'empleado_sucursal'))
ENABLE;


--Creación de la tabla Ciudad
CREATE TABLE Ciudad(id Number, nombre varchar(30)),
CONSTRAINT Ciudad_PK PRIMARY KEY (id);

--Creación de la tabla Sucursales
CREATE TABLE Sucursal (id Number, nombre varchar (30), tamanho Number, direccion varchar(30), nivelReorden Number, nivelReabastecimiento Number, idCiudad Number),
CONSTRAINT Sucursal_PK PRIMARY KEY (id);

ALTER TABLE Sucursal 
ADD CONSTRAINT Sucursal_FK_idCiudad 
FOREIGN KEY (idCiudad)
REFERENCES ciudad
ENABLE;

--Creación de la tabla ProveedoresSucursales
CREATE TABLE ProveedorSucursal(idSucursal Number, NITProveedor Number),
CONSTRAINT ProveedorSucursal_PK PRIMARY KEY (idSucursal, NITProveedor);

ALTER TABLE ProveedorSucursal
ADD CONSTRAINT ProveedorSucursal_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursal
ENABLE;

ALTER TABLE ProveedorSucursal
ADD CONSTRAINT ProveedorSucursal_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresa
ENABLE;

--Creación de la tabla Categoria

CREATE TABLE Categoria(nombre varchar(30), caracteristicas varchar(100), almacenamiento varchar(20), manejo varchar(40)),
CONSTRAINT Categoria_PK PRIMARY KEY (nombre);

ALTER TABLE Categoria
ADD CONSTRAINT Categoria_almacenamiento 
CHECK almacenamiento IN ('Nevera', 'Granos', 'Cereales');



--Creación de la tabla ProductosAbstractos
CREATE TABLE ProductoAbstracto(id Number, nombre varchar(30), tipo varchar(20), unidadMedida varchar(2), categoria varchar(30)),
CONSTRAINT ProductosAbstractos_PK PRIMARY KEY (id);

ALTER TABLE ProductoAbstracto
ADD CONSTRAINT ProductoAbstracto_FK_categoria
FOREIGN KEY (categoria)
REFERENCES Categoria
ENABLE;

--Creación de la tabla OfrecidosSucursales
CREATE TABLE OfrecidoSucursal(idOfrecido Number, idSucursal Number, precio Number),
CONSTRAINT OfrecidoSucursal_PK PRIMARY KEY (idOfrecido, idSucursal);

ALTER TABLE OfrecidoSucursal
ADD CONSTRAINT OfrecidoSucursal_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursal
ENABLE;

--Creación de la tabla OfrecidosProveedores
CREATE TABLE OfrecidoProveedor(idOfrecido, NITProveedor, precio),
CONSTRAINT OfrecidoProveedor_PK PRIMARY KEY (idOfrecido, NITProveedor);

ALTER TABLE OfrecidoProveedor
ADD CONSTRAINT OfrecidoProveedor_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresa
ENABLE;

--Creación de la tabla ProductosFisicos
CREATE TABLE ProductoFisico(id Number, idOfrecido Number, cantidadMedida Number, codigoBarras varchar(20)),
CONSTRAINT ProductoFisico PRIMARY KEY (id);

ALTER TABLE ProductoFisicos
ADD CONSTRAINT ProductoFisico_FK_idOfrecido
FOREIGN KEY (idOfrecido)
REFERENCES OfrecidoSucursal
ENABLE;
--Falta la parte de hexadecimales en el código de barras.

--Creación de la tabla Contenedores

CREATE TABLE Contenedor(id Number, sucursalId Number, tipo varchar(20), capacidad Number, capacidadOcupada Number),
CONSTRAINT Contenedor_PK PRIMARY KEY (id);

ALTER TABLE Contenedor
ADD CONSTRAINT Contenedor_tipo
CHECK (tipo IN ('estante', 'bodega'))
ENABLE;

ALTER TABLE Contenedor
ADD CONSTRAINT Contenedor_capacidad_vs_capacidadOcupada
CHECK (capacidadOcupada <= capacidad)
ENABLE;

--Creación de tabla Pedido
CREATE TABLE Pedido  (id Number, idSucursal Number, NITProveedor Number, precio Number, estado varchar(10), fechaEntrega varchar(10), calidad varchar(15), calificacion Number),
CONSTRAINT Pedido_PK PRIMARY KEY (id);

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursal
ENABLE;

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresa
ENABLE;

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_estado
CHECK (estado IN('entregado', 'por_entregar'))
ENABLE;

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_calidad
CHECK (calidad IN ('muy_mala', 'mala', 'regular', 'buena', 'muy_buena'))
ENABLE;

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_calificacion
CHECK (calificacion IN (1,2,3,4,5))
ENABLE;

--Creación de tabla ProductosPedidos
CREATE TABLE ProductoPedido(idPedido Number, idProductoOfrecido Number, cantidad Number)
CONSTRAINT ProductoPedido_PK PRIMARY KEY (idPedido, idProductoOfrecido);

ALTER TABLE ProductoPedido
ADD CONSTRAINT ProductoPedido_FK_idPedido
FOREIGN KEY (idPedido)
REFERENCES Pedido
ENABLE;

ALTER TABLE ProductoPedido
ADD CONSTRAINT ProductoPedido_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidoProveedor
ENABLE;

--Creación de tabla Promociones
CREATE TABLE Promocion(id Number, idSucursal Number, slogan varchar(40), descripcion varchar(130), tipo varchar(20)),
CONSTRAINT Promocion_PK PRIMARY KEY (id);

ALTER TABLE Promocion
ADD CONSTRAINT Promocion_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursal
ENABLE;

ALTER TABLE Promocion
ADD CONSTRAINT Promocion_tipo
CHECK (tipo IN ('pague_n_lleve_m', 'pague_x_lleve_y', 'porcentaje_descuento', 'paquete_productos'))
ENABLE;

--Creación de tabla PromocionesPorCantidadOUnidad
CREATE TABLE PromocionPorCantidadOUnidad(idProductoOfrecido Number, idPromocion Number, cantidadOUnidadesPagadas Number, cantidadOUnidadesCompradas Number),
CONSTRAINT PromocionPorCantidadOUnidad_PK PRIMARY KEY (idProductoOfrecido);--Revisar <-- <-- <-- <--

ALTER TABLE PromocionPorCantidadOUnidad
ADD CONSTRAINT PromocionPorCantidadOUnidad_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidoSucursal
ENABLE;

ALTER TABLE PromocionPorCantidadOUnidad
ADD CONSTRAINT PromocionPorCantidadOUnidad_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promocion
ENABLE;

--Creación de la tabla PromocionesPorcentajeDescuento
CREATE TABLE PromocionPorcentajeDescuento(idProductoOfrecido Number, idPromocion Number, porcentajeDescuento Number),
CONSTRAINT PromocionPorcentajeDescuento_PK PRIMARY KEY (idProductoOfrecido Number);

ALTER TABLE PromocionPorcentajeDescuento
ADD CONSTRAINT PromocionPorcentajeDescuento_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidoSucursal
ENABLE;

ALTER TABLE PromocionPorcentajeDescuento
ADD CONSTRAINT PromocionPorcentajeDescuento_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promocion
ENABLE;

--Creación de la tabla PromocionesPaqueteProductos
CREATE TABLE PromocionPaqueteProductos(idPromocion Number, precio Number, idProductoOfrecido1 Number, idProductoOfrecido2 Number),
CONSTRAINT PromocionesPaquetesProductos_PK PRIMARY KEY(idProductoOfrecido1, idProductoOfrecido2);

ALTER TABLE PromocionPaqueteProductos
ADD CONSTRAINT PromocionPaqueteProductos_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promocion
ENABLE;

ALTER TABLE PromocionPaqueteProductos
ADD CONSTRAINT PromocionPaqueteProductos_FK_idProductoOfrecido1
FOREIGN KEY (idProductoOfrecido1)
REFERENCES OfrecidoSucursal
ENABLE;

ALTER TABLE PromocionPaqueteProductos
ADD CONSTRAINT PromocionPaqueteProductos_FK_idProductoOfrecido2
FOREIGN KEY (idProductoOfrecido2)
REFERENCES OfrecidoSucursal
ENABLE;

--Creación de tabla Facturas
CREATE TABLE Factura(id Number, idUser Number, costoTotal Number),
CONSTRAINT Factura_PK PRIMARY KEY (id);

ALTER TABLE Factura
ADD CONSTRAINT Factura_FK_idUser
FOREIGN KEY (idUser)
REFERENCES User
ENABLE;

--Creación de tabla ItemsFacturas
CREATE TABLE ItemFactura(idFactura Number, idProductoOfrecido Number, cantidad Number, costo Number),
CONSTRAINT ItemFactura_PK PRIMARY KEY (idFactura, idProductoOfrecido);

ALTER TABLE ItemFacturas
ADD CONSTRAINT ItemFactura_FK_idFactura
FOREIGN KEY (idFactura)
REFERENCES Factura
ENABLE;

ALTER TABLE ItemFactura
ADD CONSTRAINT ItemFactura_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidoSucursal
ENABLE;