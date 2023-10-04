@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DD Libros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZDDC_LIBROS_5712
  as select from    ztb_libros_5712  as Libros
    inner join      ztb_catego_5712  as Categoria on Libros.bi_categ = Categoria.bi_categ
    left outer join ZDDC_VENTAS_5712 as Ventas    on Libros.id_libro = Ventas.IdLibro
  association [0..*] to ZDDC_CLIENTES_5712 as _Clientes on $projection.IdLibro = _Clientes.IdLibro
{

  key Libros.id_libro       as IdLibro,
      Libros.titulo         as Titulo,
      Categoria.descripcion as Categoria,
      Libros.autor          as Autor,
      Libros.editorial      as Editorial,
      Libros.idioma         as Idioma,
      Libros.paginas        as Paginas,
      @Semantics.amount.currencyCode: 'Moneda'
      Libros.precio         as Precio,
      Libros.moneda         as Moneda,
      Libros.formato        as Formato,
      case
        when Ventas.Ventas < 0 then 0 // Sin ventas
        when Ventas.Ventas = 1 then 1 // Pocas ventas
        when Ventas.Ventas = 2 then 2 // Ventas medias
        else  3                       // Ventas altas
        end                 as Ventas,
      /*case
        when Ventas.Ventas < 0 then 'Sin ventas'
        when Ventas.Ventas = 1 then 'Pocas ventas'
        when Ventas.Ventas = 2 then 'Ventas medias'
        else                        'Ventas altas'
        end                 as Estado,*/
      ''                    as Estado,
      Libros.url            as Imagen,
      _Clientes

}
