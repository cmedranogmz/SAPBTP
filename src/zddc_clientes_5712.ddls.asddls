@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZDDC_CLIENTES_5712
  as select from ztb_cliente_5712 as Clientes
    inner join   ztb_cln_lib_5712 as ClientesLibros on Clientes.id_cliente = ClientesLibros.id_cliente
{
  key ClientesLibros.id_libro as IdLibro,
  key Clientes.id_cliente     as IdCliente,
  key Clientes.tipo_acceso    as TipoAcceso,
      Clientes.nombre         as Nombre,
      Clientes.apellidos      as Apellidos,
      Clientes.email          as Email,
      Clientes.url            as Imagen
}
