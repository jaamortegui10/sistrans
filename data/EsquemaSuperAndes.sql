--- Sentencias SQL para la creación del esquema de parranderos

--Uso:
--Copie el contenido de este archivo y péguelo en una pestaña SQL de SQLDeveloper
--Ejecútelo como un script con el botón correspondiente

--Creación de la tabla User y especificación de sus restricciones
CREATE TABLE Users (id Number PRIMARY KEY, login varchar(20), password varchar(20), nombre varchar(40), correo varchar(30), tipo varchar(20)),
CONSTRAINT Users_PK PRIMARY KEY (id);

ALTER TABLE Users
ADD CONSTRAINT users_tipo 
CHECK ()tipo IN ('empresa', 'persona'))
ENABLE;

--Creación de la tabla Empresas
CREATE TABLE Empresas (NIT Number, idUser Number, dir varchar(30), puntos Number, tipoEmpresa varchar(10)),
CONSTRAINT Empresas_PK PRIMARY KEY (NIT);

ALTER TABLE Empresas
ADD CONSTRAINT Empresas_FK_idUser
FOREIGN KEY (idUser)
REFERENCES Users
ENABLE;

ALTER TABLE Empresas
ADD CONSTRAINT Empresas_tipoEmpresa
CHECK (tipoEmpresa IN ('cliente', 'proveedor'))
ENABLE;

--Creación de la tabla Personas
CREATE TABLE Personas(cedula Number,idUser Number, puntos Number, idSucursal Number, tipoPersona varchar(10)),
CONSTRAINT Personas_PK PRIMARY KEY (cedula);

ALTER TABLE Personas
ADD CONSTRAINT Personas_FK_idUser
FOREIGN KEY (idUser)
REFERENCES Users
ENABLE;

ALTER TABLE Personas
ADD CONSTRAINT Personas_tipoPersona
CHECK (tipoPersona IN ('cliente', 'empleado_sucursal'))
ENABLE;


--Creación de la tabla Ciudad
CREATE TABLE Ciudades(id Number, nombre varchar(30)),
CONSTRAINT Ciudades_PK PRIMARY KEY (id);

--Creación de la tabla Sucursales
CREATE TABLE Sucursales (id Number, nombre varchar (30), tamanho Number, direccion varchar(30), nivelReorden Number, nivelReabastecimiento Number, idCiudad Number),
CONSTRAINT Sucursales_PK PRIMARY KEY (id);

ALTER TABLE Sucursales 
ADD CONSTRAINT Sucursales_FK_idCiudad 
FOREIGN KEY (idCiudad)
REFERENCES ciudades
ENABLE;

--Creación de la tabla ProveedoresSucursales
CREATE TABLE ProveedoresSucursales(idSucursal Number, NITProveedor Number),
CONSTRAINT ProveedoresSucursales_PK PRIMARY KEY (idSucursal, NITProveedor);

ALTER TABLE ProveedoresSucursales
ADD CONSTRAINT ProveedoresSucursales_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursales
ENABLE;

ALTER TABLE ProveedoresSucursales
ADD CONSTRAINT ProveedoresSucursales_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresas
ENABLE;

--Creación de la tabla Categoria

CREATE TABLE Categoria(nombre varchar(30), caracteristicas varchar(100), almacenamiento varchar(20), manejo varchar(40)),
CONSTRAINT Categoria_PK PRIMARY KEY (nombre);

ALTER TABLE Categoria
ADD CONSTRAINT Categoria_almacenamiento 
CHECK almacenamiento IN ('Nevera', 'Granos', 'Cereales');



--Creación de la tabla ProductosAbstractos
CREATE TABLE ProductosAbstractos(id Number, nombre varchar(30), tipo varchar(20), unidadMedida varchar(2), categoria varchar(30)),
CONSTRAINT ProductosAbstractos_PK PRIMARY KEY (id);

ALTER TABLE ProductosAbstractos
ADD CONSTRAINT ProductosAbstractos_FK_categoria
FOREIGN KEY (categoria)
REFERENCES Categoria
ENABLE;

--Creación de la tabla OfrecidosSucursales
CREATE TABLE OfrecidosSucursales(idOfrecido Number, idSucursal Number, precio Number),
CONSTRAINT OfrecidosSucursales_PK PRIMARY KEY (idOfrecido, idSucursal);

ALTER TABLE OfrecidosSucursales
ADD CONSTRAINT OfrecidosSucursales_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursales
ENABLE;

--Creación de la tabla OfrecidosProveedores
CREATE TABLE OfrecidosProveedores(idOfrecido, NITProveedor, precio),
CONSTRAINT OfrecidosProveedores_PK PRIMARY KEY (idOfrecido, NITProveedor);

ALTER TABLE OfrecidosProveedores
ADD CONSTRAINT OfrecidosProveedores_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresas
ENABLE;

--Creación de la tabla ProductosFisicos
CREATE TABLE ProductosFisicos(id Number, idOfrecido Number, cantidadMedida Number, codigoBarras varchar(20)),
CONSTRAINT ProductosFisicos PRIMARY KEY (id);

ALTER TABLE ProductosFisicos 
ADD CONSTRAINT ProductosFisicos_FK_idOfrecido
FOREIGN KEY (idOfrecido)
REFERENCES OfrecidosSucursales
ENABLE;
--Falta la parte de hexadecimales en el código de barras.

--Creación de la tabla Contenedores

CREATE TABLE Contenedores(id Number, sucursalId Number, tipo varchar(20), capacidad Number, capacidadOcupada Number),
CONSTRAINT Contenedores_PK PRIMARY KEY (id);

ALTER TABLE Contenedores
ADD CONSTRAINT Contenedores_tipo
CHECK (tipo IN ('estante', 'bodega'))
ENABLE;

ALTER TABLE Contenedores
ADD CONSTRAINT Contenedores_capacidad_vs_capacidadOcupada
CHECK (capacidadOcupada <= capacidad)
ENABLE;

--Creación de tabla Pedido
CREATE TABLE Pedido  (id Number, idSucursal Number, NITProveedor Number, precio Number, estado varchar(10), fechaEntrega varchar(10), calidad varchar(15), calificacion Number),
CONSTRAINT Pedido_PK PRIMARY KEY (id);

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursales
ENABLE;

ALTER TABLE Pedido
ADD CONSTRAINT Pedido_FK_NITProveedor
FOREIGN KEY (NITProveedor)
REFERENCES Empresas
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
CREATE TABLE ProductosPedidos(idPedido Number, idProductoOfrecido Number, cantidad Number)
CONSTRAINT ProductosPedidos_PK PRIMARY KEY (idPedido, idProductoOfrecido);

ALTER TABLE ProductosPedidos
ADD CONSTRAINT ProductosPedidos_FK_idPedido
FOREIGN KEY (idPedido)
REFERENCES Pedidos
ENABLE;

ALTER TABLE ProductosPedidos
ADD CONSTRAINT ProductosPedidos_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidosProveedores
ENABLE;

--Creación de tabla Promociones
CREATE TABLE Promociones(id Number, idSucursal Number, slogan varchar(40), descripcion varchar(130), tipo varchar(20)),
CONSTRAINT Promociones_PK PRIMARY KEY (id);

ALTER TABLE Promociones
ADD CONSTRAINT Promociones_FK_idSucursal
FOREIGN KEY (idSucursal)
REFERENCES Sucursales
ENABLE;

ALTER TABLE Promociones
ADD CONSTRAINT Promociones_tipo
CHECK (tipo IN ('pague_n_lleve_m', 'pague_x_lleve_y', 'porcentaje_descuento', 'paquete_productos'))
ENABLE;

--Creación de tabla PromocionesPorCantidadOUnidad
CREATE TABLE PromocionesPorCantidadOUnidad(idProductoOfrecido Number, idPromocion Number, cantidadOUnidadesPagadas Number, cantidadOUnidadesCompradas Number),
CONSTRAINT PromocionesPorCantidadOUnidad_PK PRIMARY KEY (idProductoOfrecido);--Revisar <-- <-- <-- <--

ALTER TABLE PromocionesPorCantidadOUnidad
ADD CONSTRAINT PromocionesPorCantidadOUnidad_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidosSucursales
ENABLE;

ALTER TABLE PromocionesPorCantidadOUnidad
ADD CONSTRAINT PromocionesPorCantidadOUnidad_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promociones
ENABLE;

--Creación de la tabla PromocionesPorcentajeDescuento
CREATE TABLE PromocionesPorcentajeDescuento(idProductoOfrecido Number, idPromocion Number, porcentajeDescuento Number),
CONSTRAINT PromocionesPorcentajeDescuento_PK PRIMARY KEY (idProductoOfrecido Number);

ALTER TABLE PromocionesPorcentajeDescuento
ADD CONSTRAINT PromocionesPorcentajeDescuento_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidosSucursales
ENABLE;

ALTER TABLE PromocionesPorcentajeDescuento
ADD CONSTRAINT PromocionesPorcentajeDescuento_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promociones
ENABLE;

--Creación de la tabla PromocionesPaqueteProductos
CREATE TABLE PromocionesPaquetesProductos(idPromocion Number, precio Number, idProductoOfrecido1 Number, idProductoOfrecido2 Number),
CONSTRAINT PromocionesPaquetesProductos_PK PRIMARY KEY(idProductoOfrecido1, idProductoOfrecido2);

ALTER TABLE PromocionesPaquetesProductos
ADD CONSTRAINT PromocionesPaquetesProductos_FK_idPromocion
FOREIGN KEY (idPromocion)
REFERENCES promociones
ENABLE;

ALTER TABLE PromocionesPaquetesProductos
ADD CONSTRAINT PromocionesPaquetesProductos_FK_idProductoOfrecido1
FOREIGN KEY (idProductoOfrecido1)
REFERENCES OfrecidosSucursales
ENABLE;

ALTER TABLE PromocionesPaquetesProductos
ADD CONSTRAINT PromocionesPaquetesProductos_FK_idProductoOfrecido2
FOREIGN KEY (idProductoOfrecido2)
REFERENCES OfrecidosSucursales
ENABLE;

--Creación de tabla Facturas
CREATE TABLE Facturas(id Number, idUser Number, costoTotal Number),
CONSTRAINT Facturas_PK PRIMARY KEY (id);

ALTER TABLE Facturas
ADD CONSTRAINT Facturas_FK_idUser
FOREIGN KEY (idUser)
REFERENCES Users
ENABLE;

--Creación de tabla ItemsFacturas
CREATE TABLE ItemsFacturas(idFactura Number, idProductoOfrecido Number, cantidad Number, costo Number),
CONSTRAINT ItemsFacturas_PK PRIMARY KEY (idFactura, idProductoOfrecido);

ALTER TABLE ItemsFacturas 
ADD CONSTRAINT ItempsFacturas_FK_idFactura
FOREIGN KEY (idFactura)
REFERENCES Facturas
ENABLE;

ALTER TABLE ItemsFacturas 
ADD CONSTRAINT ItempsFacturas_FK_idProductoOfrecido
FOREIGN KEY (idProductoOfrecido)
REFERENCES OfrecidosSucursales
ENABLE;