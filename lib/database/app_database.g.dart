// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class RetailSalesman extends DataClass implements Insertable<RetailSalesman> {
  final int id;
  final String name;
  RetailSalesman({required this.id, required this.name});
  factory RetailSalesman.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return RetailSalesman(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RetailSalesmanTableCompanion toCompanion(bool nullToAbsent) {
    return RetailSalesmanTableCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory RetailSalesman.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RetailSalesman(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  RetailSalesman copyWith({int? id, String? name}) => RetailSalesman(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('RetailSalesman(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetailSalesman &&
          other.id == this.id &&
          other.name == this.name);
}

class RetailSalesmanTableCompanion extends UpdateCompanion<RetailSalesman> {
  final Value<int> id;
  final Value<String> name;
  const RetailSalesmanTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RetailSalesmanTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<RetailSalesman> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RetailSalesmanTableCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RetailSalesmanTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RetailSalesmanTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RetailSalesmanTableTable extends RetailSalesmanTable
    with TableInfo<$RetailSalesmanTableTable, RetailSalesman> {
  final GeneratedDatabase _db;
  final String? _alias;
  $RetailSalesmanTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'retail_salesman_table';
  @override
  String get actualTableName => 'retail_salesman_table';
  @override
  VerificationContext validateIntegrity(Insertable<RetailSalesman> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RetailSalesman map(Map<String, dynamic> data, {String? tablePrefix}) {
    return RetailSalesman.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RetailSalesmanTableTable createAlias(String alias) {
    return $RetailSalesmanTableTable(_db, alias);
  }
}

class ProductDataClass extends DataClass
    implements Insertable<ProductDataClass> {
  final int id;
  final int? category;
  final List<ProductImagesModel> product_images;
  final UnitModel? units;
  final String? name;
  final String? price_currency;
  final String? price;
  final int? stock_qty;
  final String? color;
  final String? size;
  final String? brand;
  final String? price_s;
  final bool isNewArrivals;
  final bool? isFavourite;
  final int? cartQty;
  final List<ColorModel> colors;
  final String? briefDescription;
  ProductDataClass(
      {required this.id,
      this.category,
      required this.product_images,
      this.units,
      this.name,
      this.price_currency,
      this.price,
      this.stock_qty,
      this.color,
      this.size,
      this.brand,
      this.price_s,
      required this.isNewArrivals,
      this.isFavourite,
      this.cartQty,
      required this.colors,
      this.briefDescription});
  factory ProductDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProductDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      category: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
      product_images: $ProductTableTable.$converter0.mapToDart(
          const StringType().mapFromDatabaseResponse(
              data['${effectivePrefix}product_images']))!,
      units: $ProductTableTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}units'])),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      price_currency: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price_currency']),
      price: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price']),
      stock_qty: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stock_qty']),
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color']),
      size: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}size']),
      brand: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}brand']),
      price_s: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}price_s']),
      isNewArrivals: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_new_arrivals'])!,
      isFavourite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_favourite']),
      cartQty: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cart_qty']),
      colors: $ProductTableTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}colors']))!,
      briefDescription: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}brief_description']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int?>(category);
    }
    {
      final converter = $ProductTableTable.$converter0;
      map['product_images'] =
          Variable<String>(converter.mapToSql(product_images)!);
    }
    if (!nullToAbsent || units != null) {
      final converter = $ProductTableTable.$converter1;
      map['units'] = Variable<String?>(converter.mapToSql(units));
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || price_currency != null) {
      map['price_currency'] = Variable<String?>(price_currency);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String?>(price);
    }
    if (!nullToAbsent || stock_qty != null) {
      map['stock_qty'] = Variable<int?>(stock_qty);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String?>(color);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<String?>(size);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String?>(brand);
    }
    if (!nullToAbsent || price_s != null) {
      map['price_s'] = Variable<String?>(price_s);
    }
    map['is_new_arrivals'] = Variable<bool>(isNewArrivals);
    if (!nullToAbsent || isFavourite != null) {
      map['is_favourite'] = Variable<bool?>(isFavourite);
    }
    if (!nullToAbsent || cartQty != null) {
      map['cart_qty'] = Variable<int?>(cartQty);
    }
    {
      final converter = $ProductTableTable.$converter2;
      map['colors'] = Variable<String>(converter.mapToSql(colors)!);
    }
    if (!nullToAbsent || briefDescription != null) {
      map['brief_description'] = Variable<String?>(briefDescription);
    }
    return map;
  }

  ProductTableCompanion toCompanion(bool nullToAbsent) {
    return ProductTableCompanion(
      id: Value(id),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      product_images: Value(product_images),
      units:
          units == null && nullToAbsent ? const Value.absent() : Value(units),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      price_currency: price_currency == null && nullToAbsent
          ? const Value.absent()
          : Value(price_currency),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      stock_qty: stock_qty == null && nullToAbsent
          ? const Value.absent()
          : Value(stock_qty),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      price_s: price_s == null && nullToAbsent
          ? const Value.absent()
          : Value(price_s),
      isNewArrivals: Value(isNewArrivals),
      isFavourite: isFavourite == null && nullToAbsent
          ? const Value.absent()
          : Value(isFavourite),
      cartQty: cartQty == null && nullToAbsent
          ? const Value.absent()
          : Value(cartQty),
      colors: Value(colors),
      briefDescription: briefDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(briefDescription),
    );
  }

  factory ProductDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ProductDataClass(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<int?>(json['category']),
      product_images:
          serializer.fromJson<List<ProductImagesModel>>(json['product_images']),
      units: serializer.fromJson<UnitModel?>(json['units']),
      name: serializer.fromJson<String?>(json['name']),
      price_currency: serializer.fromJson<String?>(json['price_currency']),
      price: serializer.fromJson<String?>(json['price']),
      stock_qty: serializer.fromJson<int?>(json['stock_qty']),
      color: serializer.fromJson<String?>(json['color']),
      size: serializer.fromJson<String?>(json['size']),
      brand: serializer.fromJson<String?>(json['brand']),
      price_s: serializer.fromJson<String?>(json['price_s']),
      isNewArrivals: serializer.fromJson<bool>(json['isNewArrivals']),
      isFavourite: serializer.fromJson<bool?>(json['isFavourite']),
      cartQty: serializer.fromJson<int?>(json['cartQty']),
      colors: serializer.fromJson<List<ColorModel>>(json['colors']),
      briefDescription: serializer.fromJson<String?>(json['briefDescription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<int?>(category),
      'product_images':
          serializer.toJson<List<ProductImagesModel>>(product_images),
      'units': serializer.toJson<UnitModel?>(units),
      'name': serializer.toJson<String?>(name),
      'price_currency': serializer.toJson<String?>(price_currency),
      'price': serializer.toJson<String?>(price),
      'stock_qty': serializer.toJson<int?>(stock_qty),
      'color': serializer.toJson<String?>(color),
      'size': serializer.toJson<String?>(size),
      'brand': serializer.toJson<String?>(brand),
      'price_s': serializer.toJson<String?>(price_s),
      'isNewArrivals': serializer.toJson<bool>(isNewArrivals),
      'isFavourite': serializer.toJson<bool?>(isFavourite),
      'cartQty': serializer.toJson<int?>(cartQty),
      'colors': serializer.toJson<List<ColorModel>>(colors),
      'briefDescription': serializer.toJson<String?>(briefDescription),
    };
  }

  ProductDataClass copyWith(
          {int? id,
          int? category,
          List<ProductImagesModel>? product_images,
          UnitModel? units,
          String? name,
          String? price_currency,
          String? price,
          int? stock_qty,
          String? color,
          String? size,
          String? brand,
          String? price_s,
          bool? isNewArrivals,
          bool? isFavourite,
          int? cartQty,
          List<ColorModel>? colors,
          String? briefDescription}) =>
      ProductDataClass(
        id: id ?? this.id,
        category: category ?? this.category,
        product_images: product_images ?? this.product_images,
        units: units ?? this.units,
        name: name ?? this.name,
        price_currency: price_currency ?? this.price_currency,
        price: price ?? this.price,
        stock_qty: stock_qty ?? this.stock_qty,
        color: color ?? this.color,
        size: size ?? this.size,
        brand: brand ?? this.brand,
        price_s: price_s ?? this.price_s,
        isNewArrivals: isNewArrivals ?? this.isNewArrivals,
        isFavourite: isFavourite ?? this.isFavourite,
        cartQty: cartQty ?? this.cartQty,
        colors: colors ?? this.colors,
        briefDescription: briefDescription ?? this.briefDescription,
      );
  @override
  String toString() {
    return (StringBuffer('ProductDataClass(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('product_images: $product_images, ')
          ..write('units: $units, ')
          ..write('name: $name, ')
          ..write('price_currency: $price_currency, ')
          ..write('price: $price, ')
          ..write('stock_qty: $stock_qty, ')
          ..write('color: $color, ')
          ..write('size: $size, ')
          ..write('brand: $brand, ')
          ..write('price_s: $price_s, ')
          ..write('isNewArrivals: $isNewArrivals, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('cartQty: $cartQty, ')
          ..write('colors: $colors, ')
          ..write('briefDescription: $briefDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          category.hashCode,
          $mrjc(
              product_images.hashCode,
              $mrjc(
                  units.hashCode,
                  $mrjc(
                      name.hashCode,
                      $mrjc(
                          price_currency.hashCode,
                          $mrjc(
                              price.hashCode,
                              $mrjc(
                                  stock_qty.hashCode,
                                  $mrjc(
                                      color.hashCode,
                                      $mrjc(
                                          size.hashCode,
                                          $mrjc(
                                              brand.hashCode,
                                              $mrjc(
                                                  price_s.hashCode,
                                                  $mrjc(
                                                      isNewArrivals.hashCode,
                                                      $mrjc(
                                                          isFavourite.hashCode,
                                                          $mrjc(
                                                              cartQty.hashCode,
                                                              $mrjc(
                                                                  colors
                                                                      .hashCode,
                                                                  briefDescription
                                                                      .hashCode)))))))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductDataClass &&
          other.id == this.id &&
          other.category == this.category &&
          other.product_images == this.product_images &&
          other.units == this.units &&
          other.name == this.name &&
          other.price_currency == this.price_currency &&
          other.price == this.price &&
          other.stock_qty == this.stock_qty &&
          other.color == this.color &&
          other.size == this.size &&
          other.brand == this.brand &&
          other.price_s == this.price_s &&
          other.isNewArrivals == this.isNewArrivals &&
          other.isFavourite == this.isFavourite &&
          other.cartQty == this.cartQty &&
          other.colors == this.colors &&
          other.briefDescription == this.briefDescription);
}

class ProductTableCompanion extends UpdateCompanion<ProductDataClass> {
  final Value<int> id;
  final Value<int?> category;
  final Value<List<ProductImagesModel>> product_images;
  final Value<UnitModel?> units;
  final Value<String?> name;
  final Value<String?> price_currency;
  final Value<String?> price;
  final Value<int?> stock_qty;
  final Value<String?> color;
  final Value<String?> size;
  final Value<String?> brand;
  final Value<String?> price_s;
  final Value<bool> isNewArrivals;
  final Value<bool?> isFavourite;
  final Value<int?> cartQty;
  final Value<List<ColorModel>> colors;
  final Value<String?> briefDescription;
  const ProductTableCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.product_images = const Value.absent(),
    this.units = const Value.absent(),
    this.name = const Value.absent(),
    this.price_currency = const Value.absent(),
    this.price = const Value.absent(),
    this.stock_qty = const Value.absent(),
    this.color = const Value.absent(),
    this.size = const Value.absent(),
    this.brand = const Value.absent(),
    this.price_s = const Value.absent(),
    this.isNewArrivals = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.cartQty = const Value.absent(),
    this.colors = const Value.absent(),
    this.briefDescription = const Value.absent(),
  });
  ProductTableCompanion.insert({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    required List<ProductImagesModel> product_images,
    this.units = const Value.absent(),
    this.name = const Value.absent(),
    this.price_currency = const Value.absent(),
    this.price = const Value.absent(),
    this.stock_qty = const Value.absent(),
    this.color = const Value.absent(),
    this.size = const Value.absent(),
    this.brand = const Value.absent(),
    this.price_s = const Value.absent(),
    required bool isNewArrivals,
    this.isFavourite = const Value.absent(),
    this.cartQty = const Value.absent(),
    required List<ColorModel> colors,
    this.briefDescription = const Value.absent(),
  })  : product_images = Value(product_images),
        isNewArrivals = Value(isNewArrivals),
        colors = Value(colors);
  static Insertable<ProductDataClass> custom({
    Expression<int>? id,
    Expression<int?>? category,
    Expression<List<ProductImagesModel>>? product_images,
    Expression<UnitModel?>? units,
    Expression<String?>? name,
    Expression<String?>? price_currency,
    Expression<String?>? price,
    Expression<int?>? stock_qty,
    Expression<String?>? color,
    Expression<String?>? size,
    Expression<String?>? brand,
    Expression<String?>? price_s,
    Expression<bool>? isNewArrivals,
    Expression<bool?>? isFavourite,
    Expression<int?>? cartQty,
    Expression<List<ColorModel>>? colors,
    Expression<String?>? briefDescription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (product_images != null) 'product_images': product_images,
      if (units != null) 'units': units,
      if (name != null) 'name': name,
      if (price_currency != null) 'price_currency': price_currency,
      if (price != null) 'price': price,
      if (stock_qty != null) 'stock_qty': stock_qty,
      if (color != null) 'color': color,
      if (size != null) 'size': size,
      if (brand != null) 'brand': brand,
      if (price_s != null) 'price_s': price_s,
      if (isNewArrivals != null) 'is_new_arrivals': isNewArrivals,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (cartQty != null) 'cart_qty': cartQty,
      if (colors != null) 'colors': colors,
      if (briefDescription != null) 'brief_description': briefDescription,
    });
  }

  ProductTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? category,
      Value<List<ProductImagesModel>>? product_images,
      Value<UnitModel?>? units,
      Value<String?>? name,
      Value<String?>? price_currency,
      Value<String?>? price,
      Value<int?>? stock_qty,
      Value<String?>? color,
      Value<String?>? size,
      Value<String?>? brand,
      Value<String?>? price_s,
      Value<bool>? isNewArrivals,
      Value<bool?>? isFavourite,
      Value<int?>? cartQty,
      Value<List<ColorModel>>? colors,
      Value<String?>? briefDescription}) {
    return ProductTableCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      product_images: product_images ?? this.product_images,
      units: units ?? this.units,
      name: name ?? this.name,
      price_currency: price_currency ?? this.price_currency,
      price: price ?? this.price,
      stock_qty: stock_qty ?? this.stock_qty,
      color: color ?? this.color,
      size: size ?? this.size,
      brand: brand ?? this.brand,
      price_s: price_s ?? this.price_s,
      isNewArrivals: isNewArrivals ?? this.isNewArrivals,
      isFavourite: isFavourite ?? this.isFavourite,
      cartQty: cartQty ?? this.cartQty,
      colors: colors ?? this.colors,
      briefDescription: briefDescription ?? this.briefDescription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<int?>(category.value);
    }
    if (product_images.present) {
      final converter = $ProductTableTable.$converter0;
      map['product_images'] =
          Variable<String>(converter.mapToSql(product_images.value)!);
    }
    if (units.present) {
      final converter = $ProductTableTable.$converter1;
      map['units'] = Variable<String?>(converter.mapToSql(units.value));
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (price_currency.present) {
      map['price_currency'] = Variable<String?>(price_currency.value);
    }
    if (price.present) {
      map['price'] = Variable<String?>(price.value);
    }
    if (stock_qty.present) {
      map['stock_qty'] = Variable<int?>(stock_qty.value);
    }
    if (color.present) {
      map['color'] = Variable<String?>(color.value);
    }
    if (size.present) {
      map['size'] = Variable<String?>(size.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String?>(brand.value);
    }
    if (price_s.present) {
      map['price_s'] = Variable<String?>(price_s.value);
    }
    if (isNewArrivals.present) {
      map['is_new_arrivals'] = Variable<bool>(isNewArrivals.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool?>(isFavourite.value);
    }
    if (cartQty.present) {
      map['cart_qty'] = Variable<int?>(cartQty.value);
    }
    if (colors.present) {
      final converter = $ProductTableTable.$converter2;
      map['colors'] = Variable<String>(converter.mapToSql(colors.value)!);
    }
    if (briefDescription.present) {
      map['brief_description'] = Variable<String?>(briefDescription.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTableCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('product_images: $product_images, ')
          ..write('units: $units, ')
          ..write('name: $name, ')
          ..write('price_currency: $price_currency, ')
          ..write('price: $price, ')
          ..write('stock_qty: $stock_qty, ')
          ..write('color: $color, ')
          ..write('size: $size, ')
          ..write('brand: $brand, ')
          ..write('price_s: $price_s, ')
          ..write('isNewArrivals: $isNewArrivals, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('cartQty: $cartQty, ')
          ..write('colors: $colors, ')
          ..write('briefDescription: $briefDescription')
          ..write(')'))
        .toString();
  }
}

class $ProductTableTable extends ProductTable
    with TableInfo<$ProductTableTable, ProductDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ProductTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumn<int?> category = GeneratedColumn<int?>(
      'category', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _product_imagesMeta =
      const VerificationMeta('product_images');
  late final GeneratedColumnWithTypeConverter<List<ProductImagesModel>, String?>
      product_images = GeneratedColumn<String?>(
              'product_images', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<List<ProductImagesModel>>(
              $ProductTableTable.$converter0);
  final VerificationMeta _unitsMeta = const VerificationMeta('units');
  late final GeneratedColumnWithTypeConverter<UnitModel, String?> units =
      GeneratedColumn<String?>('units', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<UnitModel>($ProductTableTable.$converter1);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _price_currencyMeta =
      const VerificationMeta('price_currency');
  late final GeneratedColumn<String?> price_currency = GeneratedColumn<String?>(
      'price_currency', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _priceMeta = const VerificationMeta('price');
  late final GeneratedColumn<String?> price = GeneratedColumn<String?>(
      'price', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _stock_qtyMeta = const VerificationMeta('stock_qty');
  late final GeneratedColumn<int?> stock_qty = GeneratedColumn<int?>(
      'stock_qty', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _sizeMeta = const VerificationMeta('size');
  late final GeneratedColumn<String?> size = GeneratedColumn<String?>(
      'size', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _brandMeta = const VerificationMeta('brand');
  late final GeneratedColumn<String?> brand = GeneratedColumn<String?>(
      'brand', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _price_sMeta = const VerificationMeta('price_s');
  late final GeneratedColumn<String?> price_s = GeneratedColumn<String?>(
      'price_s', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _isNewArrivalsMeta =
      const VerificationMeta('isNewArrivals');
  late final GeneratedColumn<bool?> isNewArrivals = GeneratedColumn<bool?>(
      'is_new_arrivals', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_new_arrivals IN (0, 1))');
  final VerificationMeta _isFavouriteMeta =
      const VerificationMeta('isFavourite');
  late final GeneratedColumn<bool?> isFavourite = GeneratedColumn<bool?>(
      'is_favourite', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_favourite IN (0, 1))');
  final VerificationMeta _cartQtyMeta = const VerificationMeta('cartQty');
  late final GeneratedColumn<int?> cartQty = GeneratedColumn<int?>(
      'cart_qty', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _colorsMeta = const VerificationMeta('colors');
  late final GeneratedColumnWithTypeConverter<List<ColorModel>, String?>
      colors = GeneratedColumn<String?>('colors', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<List<ColorModel>>($ProductTableTable.$converter2);
  final VerificationMeta _briefDescriptionMeta =
      const VerificationMeta('briefDescription');
  late final GeneratedColumn<String?> briefDescription =
      GeneratedColumn<String?>('brief_description', aliasedName, true,
          typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        category,
        product_images,
        units,
        name,
        price_currency,
        price,
        stock_qty,
        color,
        size,
        brand,
        price_s,
        isNewArrivals,
        isFavourite,
        cartQty,
        colors,
        briefDescription
      ];
  @override
  String get aliasedName => _alias ?? 'product_table';
  @override
  String get actualTableName => 'product_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProductDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    context.handle(_product_imagesMeta, const VerificationResult.success());
    context.handle(_unitsMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('price_currency')) {
      context.handle(
          _price_currencyMeta,
          price_currency.isAcceptableOrUnknown(
              data['price_currency']!, _price_currencyMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stock_qtyMeta,
          stock_qty.isAcceptableOrUnknown(data['stock_qty']!, _stock_qtyMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('price_s')) {
      context.handle(_price_sMeta,
          price_s.isAcceptableOrUnknown(data['price_s']!, _price_sMeta));
    }
    if (data.containsKey('is_new_arrivals')) {
      context.handle(
          _isNewArrivalsMeta,
          isNewArrivals.isAcceptableOrUnknown(
              data['is_new_arrivals']!, _isNewArrivalsMeta));
    } else if (isInserting) {
      context.missing(_isNewArrivalsMeta);
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
          _isFavouriteMeta,
          isFavourite.isAcceptableOrUnknown(
              data['is_favourite']!, _isFavouriteMeta));
    }
    if (data.containsKey('cart_qty')) {
      context.handle(_cartQtyMeta,
          cartQty.isAcceptableOrUnknown(data['cart_qty']!, _cartQtyMeta));
    }
    context.handle(_colorsMeta, const VerificationResult.success());
    if (data.containsKey('brief_description')) {
      context.handle(
          _briefDescriptionMeta,
          briefDescription.isAcceptableOrUnknown(
              data['brief_description']!, _briefDescriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProductDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductTableTable createAlias(String alias) {
    return $ProductTableTable(_db, alias);
  }

  static TypeConverter<List<ProductImagesModel>, String> $converter0 =
      const ProductImagesModelConverter();
  static TypeConverter<UnitModel, String> $converter1 =
      const UnitModelConverter();
  static TypeConverter<List<ColorModel>, String> $converter2 =
      const ColorModelConverter();
}

class OfferDataClass extends DataClass implements Insertable<OfferDataClass> {
  final int id;
  final ProductModel xItem;
  final ProductModel? yItem;
  final String name;
  final String scheme;
  final int xAmt;
  final int yAmt;
  final String dateFrom;
  final String dateTo;
  final String pic;
  final String detailName;
  OfferDataClass(
      {required this.id,
      required this.xItem,
      this.yItem,
      required this.name,
      required this.scheme,
      required this.xAmt,
      required this.yAmt,
      required this.dateFrom,
      required this.dateTo,
      required this.pic,
      required this.detailName});
  factory OfferDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return OfferDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      xItem: $OfferTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}x_item']))!,
      yItem: $OfferTableTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}y_item'])),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      scheme: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scheme'])!,
      xAmt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}x_amt'])!,
      yAmt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}y_amt'])!,
      dateFrom: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_from'])!,
      dateTo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_to'])!,
      pic: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pic'])!,
      detailName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}detail_name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $OfferTableTable.$converter0;
      map['x_item'] = Variable<String>(converter.mapToSql(xItem)!);
    }
    if (!nullToAbsent || yItem != null) {
      final converter = $OfferTableTable.$converter1;
      map['y_item'] = Variable<String?>(converter.mapToSql(yItem));
    }
    map['name'] = Variable<String>(name);
    map['scheme'] = Variable<String>(scheme);
    map['x_amt'] = Variable<int>(xAmt);
    map['y_amt'] = Variable<int>(yAmt);
    map['date_from'] = Variable<String>(dateFrom);
    map['date_to'] = Variable<String>(dateTo);
    map['pic'] = Variable<String>(pic);
    map['detail_name'] = Variable<String>(detailName);
    return map;
  }

  OfferTableCompanion toCompanion(bool nullToAbsent) {
    return OfferTableCompanion(
      id: Value(id),
      xItem: Value(xItem),
      yItem:
          yItem == null && nullToAbsent ? const Value.absent() : Value(yItem),
      name: Value(name),
      scheme: Value(scheme),
      xAmt: Value(xAmt),
      yAmt: Value(yAmt),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
      pic: Value(pic),
      detailName: Value(detailName),
    );
  }

  factory OfferDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OfferDataClass(
      id: serializer.fromJson<int>(json['id']),
      xItem: serializer.fromJson<ProductModel>(json['xItem']),
      yItem: serializer.fromJson<ProductModel?>(json['yItem']),
      name: serializer.fromJson<String>(json['name']),
      scheme: serializer.fromJson<String>(json['scheme']),
      xAmt: serializer.fromJson<int>(json['xAmt']),
      yAmt: serializer.fromJson<int>(json['yAmt']),
      dateFrom: serializer.fromJson<String>(json['dateFrom']),
      dateTo: serializer.fromJson<String>(json['dateTo']),
      pic: serializer.fromJson<String>(json['pic']),
      detailName: serializer.fromJson<String>(json['detailName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'xItem': serializer.toJson<ProductModel>(xItem),
      'yItem': serializer.toJson<ProductModel?>(yItem),
      'name': serializer.toJson<String>(name),
      'scheme': serializer.toJson<String>(scheme),
      'xAmt': serializer.toJson<int>(xAmt),
      'yAmt': serializer.toJson<int>(yAmt),
      'dateFrom': serializer.toJson<String>(dateFrom),
      'dateTo': serializer.toJson<String>(dateTo),
      'pic': serializer.toJson<String>(pic),
      'detailName': serializer.toJson<String>(detailName),
    };
  }

  OfferDataClass copyWith(
          {int? id,
          ProductModel? xItem,
          ProductModel? yItem,
          String? name,
          String? scheme,
          int? xAmt,
          int? yAmt,
          String? dateFrom,
          String? dateTo,
          String? pic,
          String? detailName}) =>
      OfferDataClass(
        id: id ?? this.id,
        xItem: xItem ?? this.xItem,
        yItem: yItem ?? this.yItem,
        name: name ?? this.name,
        scheme: scheme ?? this.scheme,
        xAmt: xAmt ?? this.xAmt,
        yAmt: yAmt ?? this.yAmt,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        pic: pic ?? this.pic,
        detailName: detailName ?? this.detailName,
      );
  @override
  String toString() {
    return (StringBuffer('OfferDataClass(')
          ..write('id: $id, ')
          ..write('xItem: $xItem, ')
          ..write('yItem: $yItem, ')
          ..write('name: $name, ')
          ..write('scheme: $scheme, ')
          ..write('xAmt: $xAmt, ')
          ..write('yAmt: $yAmt, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('pic: $pic, ')
          ..write('detailName: $detailName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          xItem.hashCode,
          $mrjc(
              yItem.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      scheme.hashCode,
                      $mrjc(
                          xAmt.hashCode,
                          $mrjc(
                              yAmt.hashCode,
                              $mrjc(
                                  dateFrom.hashCode,
                                  $mrjc(
                                      dateTo.hashCode,
                                      $mrjc(pic.hashCode,
                                          detailName.hashCode)))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfferDataClass &&
          other.id == this.id &&
          other.xItem == this.xItem &&
          other.yItem == this.yItem &&
          other.name == this.name &&
          other.scheme == this.scheme &&
          other.xAmt == this.xAmt &&
          other.yAmt == this.yAmt &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.pic == this.pic &&
          other.detailName == this.detailName);
}

class OfferTableCompanion extends UpdateCompanion<OfferDataClass> {
  final Value<int> id;
  final Value<ProductModel> xItem;
  final Value<ProductModel?> yItem;
  final Value<String> name;
  final Value<String> scheme;
  final Value<int> xAmt;
  final Value<int> yAmt;
  final Value<String> dateFrom;
  final Value<String> dateTo;
  final Value<String> pic;
  final Value<String> detailName;
  const OfferTableCompanion({
    this.id = const Value.absent(),
    this.xItem = const Value.absent(),
    this.yItem = const Value.absent(),
    this.name = const Value.absent(),
    this.scheme = const Value.absent(),
    this.xAmt = const Value.absent(),
    this.yAmt = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.pic = const Value.absent(),
    this.detailName = const Value.absent(),
  });
  OfferTableCompanion.insert({
    this.id = const Value.absent(),
    required ProductModel xItem,
    this.yItem = const Value.absent(),
    required String name,
    required String scheme,
    required int xAmt,
    required int yAmt,
    required String dateFrom,
    required String dateTo,
    required String pic,
    required String detailName,
  })  : xItem = Value(xItem),
        name = Value(name),
        scheme = Value(scheme),
        xAmt = Value(xAmt),
        yAmt = Value(yAmt),
        dateFrom = Value(dateFrom),
        dateTo = Value(dateTo),
        pic = Value(pic),
        detailName = Value(detailName);
  static Insertable<OfferDataClass> custom({
    Expression<int>? id,
    Expression<ProductModel>? xItem,
    Expression<ProductModel?>? yItem,
    Expression<String>? name,
    Expression<String>? scheme,
    Expression<int>? xAmt,
    Expression<int>? yAmt,
    Expression<String>? dateFrom,
    Expression<String>? dateTo,
    Expression<String>? pic,
    Expression<String>? detailName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (xItem != null) 'x_item': xItem,
      if (yItem != null) 'y_item': yItem,
      if (name != null) 'name': name,
      if (scheme != null) 'scheme': scheme,
      if (xAmt != null) 'x_amt': xAmt,
      if (yAmt != null) 'y_amt': yAmt,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (pic != null) 'pic': pic,
      if (detailName != null) 'detail_name': detailName,
    });
  }

  OfferTableCompanion copyWith(
      {Value<int>? id,
      Value<ProductModel>? xItem,
      Value<ProductModel?>? yItem,
      Value<String>? name,
      Value<String>? scheme,
      Value<int>? xAmt,
      Value<int>? yAmt,
      Value<String>? dateFrom,
      Value<String>? dateTo,
      Value<String>? pic,
      Value<String>? detailName}) {
    return OfferTableCompanion(
      id: id ?? this.id,
      xItem: xItem ?? this.xItem,
      yItem: yItem ?? this.yItem,
      name: name ?? this.name,
      scheme: scheme ?? this.scheme,
      xAmt: xAmt ?? this.xAmt,
      yAmt: yAmt ?? this.yAmt,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      pic: pic ?? this.pic,
      detailName: detailName ?? this.detailName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (xItem.present) {
      final converter = $OfferTableTable.$converter0;
      map['x_item'] = Variable<String>(converter.mapToSql(xItem.value)!);
    }
    if (yItem.present) {
      final converter = $OfferTableTable.$converter1;
      map['y_item'] = Variable<String?>(converter.mapToSql(yItem.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scheme.present) {
      map['scheme'] = Variable<String>(scheme.value);
    }
    if (xAmt.present) {
      map['x_amt'] = Variable<int>(xAmt.value);
    }
    if (yAmt.present) {
      map['y_amt'] = Variable<int>(yAmt.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<String>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<String>(dateTo.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String>(pic.value);
    }
    if (detailName.present) {
      map['detail_name'] = Variable<String>(detailName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfferTableCompanion(')
          ..write('id: $id, ')
          ..write('xItem: $xItem, ')
          ..write('yItem: $yItem, ')
          ..write('name: $name, ')
          ..write('scheme: $scheme, ')
          ..write('xAmt: $xAmt, ')
          ..write('yAmt: $yAmt, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('pic: $pic, ')
          ..write('detailName: $detailName')
          ..write(')'))
        .toString();
  }
}

class $OfferTableTable extends OfferTable
    with TableInfo<$OfferTableTable, OfferDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $OfferTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _xItemMeta = const VerificationMeta('xItem');
  late final GeneratedColumnWithTypeConverter<ProductModel, String?> xItem =
      GeneratedColumn<String?>('x_item', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<ProductModel>($OfferTableTable.$converter0);
  final VerificationMeta _yItemMeta = const VerificationMeta('yItem');
  late final GeneratedColumnWithTypeConverter<ProductModel, String?> yItem =
      GeneratedColumn<String?>('y_item', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<ProductModel>($OfferTableTable.$converter1);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _schemeMeta = const VerificationMeta('scheme');
  late final GeneratedColumn<String?> scheme = GeneratedColumn<String?>(
      'scheme', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _xAmtMeta = const VerificationMeta('xAmt');
  late final GeneratedColumn<int?> xAmt = GeneratedColumn<int?>(
      'x_amt', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _yAmtMeta = const VerificationMeta('yAmt');
  late final GeneratedColumn<int?> yAmt = GeneratedColumn<int?>(
      'y_amt', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _dateFromMeta = const VerificationMeta('dateFrom');
  late final GeneratedColumn<String?> dateFrom = GeneratedColumn<String?>(
      'date_from', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  late final GeneratedColumn<String?> dateTo = GeneratedColumn<String?>(
      'date_to', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _picMeta = const VerificationMeta('pic');
  late final GeneratedColumn<String?> pic = GeneratedColumn<String?>(
      'pic', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _detailNameMeta = const VerificationMeta('detailName');
  late final GeneratedColumn<String?> detailName = GeneratedColumn<String?>(
      'detail_name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        xItem,
        yItem,
        name,
        scheme,
        xAmt,
        yAmt,
        dateFrom,
        dateTo,
        pic,
        detailName
      ];
  @override
  String get aliasedName => _alias ?? 'offer_table';
  @override
  String get actualTableName => 'offer_table';
  @override
  VerificationContext validateIntegrity(Insertable<OfferDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_xItemMeta, const VerificationResult.success());
    context.handle(_yItemMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scheme')) {
      context.handle(_schemeMeta,
          scheme.isAcceptableOrUnknown(data['scheme']!, _schemeMeta));
    } else if (isInserting) {
      context.missing(_schemeMeta);
    }
    if (data.containsKey('x_amt')) {
      context.handle(
          _xAmtMeta, xAmt.isAcceptableOrUnknown(data['x_amt']!, _xAmtMeta));
    } else if (isInserting) {
      context.missing(_xAmtMeta);
    }
    if (data.containsKey('y_amt')) {
      context.handle(
          _yAmtMeta, yAmt.isAcceptableOrUnknown(data['y_amt']!, _yAmtMeta));
    } else if (isInserting) {
      context.missing(_yAmtMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(_dateFromMeta,
          dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta));
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(_dateToMeta,
          dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta));
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    if (data.containsKey('pic')) {
      context.handle(
          _picMeta, pic.isAcceptableOrUnknown(data['pic']!, _picMeta));
    } else if (isInserting) {
      context.missing(_picMeta);
    }
    if (data.containsKey('detail_name')) {
      context.handle(
          _detailNameMeta,
          detailName.isAcceptableOrUnknown(
              data['detail_name']!, _detailNameMeta));
    } else if (isInserting) {
      context.missing(_detailNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfferDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return OfferDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $OfferTableTable createAlias(String alias) {
    return $OfferTableTable(_db, alias);
  }

  static TypeConverter<ProductModel, String> $converter0 =
      const ProductModelConverter();
  static TypeConverter<ProductModel, String> $converter1 =
      const ProductModelConverter();
}

class BannerDataClass extends DataClass implements Insertable<BannerDataClass> {
  final int id;
  final String name;
  final String bannerText;
  final String? pic;
  final String status;
  final ProductModel? product;
  final OfferModel? offer;
  BannerDataClass(
      {required this.id,
      required this.name,
      required this.bannerText,
      this.pic,
      required this.status,
      this.product,
      this.offer});
  factory BannerDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return BannerDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      bannerText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}banner_text'])!,
      pic: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pic']),
      status: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      product: $BannerTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product'])),
      offer: $BannerTableTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}offer'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['banner_text'] = Variable<String>(bannerText);
    if (!nullToAbsent || pic != null) {
      map['pic'] = Variable<String?>(pic);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || product != null) {
      final converter = $BannerTableTable.$converter0;
      map['product'] = Variable<String?>(converter.mapToSql(product));
    }
    if (!nullToAbsent || offer != null) {
      final converter = $BannerTableTable.$converter1;
      map['offer'] = Variable<String?>(converter.mapToSql(offer));
    }
    return map;
  }

  BannerTableCompanion toCompanion(bool nullToAbsent) {
    return BannerTableCompanion(
      id: Value(id),
      name: Value(name),
      bannerText: Value(bannerText),
      pic: pic == null && nullToAbsent ? const Value.absent() : Value(pic),
      status: Value(status),
      product: product == null && nullToAbsent
          ? const Value.absent()
          : Value(product),
      offer:
          offer == null && nullToAbsent ? const Value.absent() : Value(offer),
    );
  }

  factory BannerDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BannerDataClass(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bannerText: serializer.fromJson<String>(json['bannerText']),
      pic: serializer.fromJson<String?>(json['pic']),
      status: serializer.fromJson<String>(json['status']),
      product: serializer.fromJson<ProductModel?>(json['product']),
      offer: serializer.fromJson<OfferModel?>(json['offer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bannerText': serializer.toJson<String>(bannerText),
      'pic': serializer.toJson<String?>(pic),
      'status': serializer.toJson<String>(status),
      'product': serializer.toJson<ProductModel?>(product),
      'offer': serializer.toJson<OfferModel?>(offer),
    };
  }

  BannerDataClass copyWith(
          {int? id,
          String? name,
          String? bannerText,
          String? pic,
          String? status,
          ProductModel? product,
          OfferModel? offer}) =>
      BannerDataClass(
        id: id ?? this.id,
        name: name ?? this.name,
        bannerText: bannerText ?? this.bannerText,
        pic: pic ?? this.pic,
        status: status ?? this.status,
        product: product ?? this.product,
        offer: offer ?? this.offer,
      );
  @override
  String toString() {
    return (StringBuffer('BannerDataClass(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bannerText: $bannerText, ')
          ..write('pic: $pic, ')
          ..write('status: $status, ')
          ..write('product: $product, ')
          ..write('offer: $offer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              bannerText.hashCode,
              $mrjc(
                  pic.hashCode,
                  $mrjc(status.hashCode,
                      $mrjc(product.hashCode, offer.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BannerDataClass &&
          other.id == this.id &&
          other.name == this.name &&
          other.bannerText == this.bannerText &&
          other.pic == this.pic &&
          other.status == this.status &&
          other.product == this.product &&
          other.offer == this.offer);
}

class BannerTableCompanion extends UpdateCompanion<BannerDataClass> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bannerText;
  final Value<String?> pic;
  final Value<String> status;
  final Value<ProductModel?> product;
  final Value<OfferModel?> offer;
  const BannerTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bannerText = const Value.absent(),
    this.pic = const Value.absent(),
    this.status = const Value.absent(),
    this.product = const Value.absent(),
    this.offer = const Value.absent(),
  });
  BannerTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bannerText,
    this.pic = const Value.absent(),
    required String status,
    this.product = const Value.absent(),
    this.offer = const Value.absent(),
  })  : name = Value(name),
        bannerText = Value(bannerText),
        status = Value(status);
  static Insertable<BannerDataClass> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bannerText,
    Expression<String?>? pic,
    Expression<String>? status,
    Expression<ProductModel?>? product,
    Expression<OfferModel?>? offer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bannerText != null) 'banner_text': bannerText,
      if (pic != null) 'pic': pic,
      if (status != null) 'status': status,
      if (product != null) 'product': product,
      if (offer != null) 'offer': offer,
    });
  }

  BannerTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? bannerText,
      Value<String?>? pic,
      Value<String>? status,
      Value<ProductModel?>? product,
      Value<OfferModel?>? offer}) {
    return BannerTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerText: bannerText ?? this.bannerText,
      pic: pic ?? this.pic,
      status: status ?? this.status,
      product: product ?? this.product,
      offer: offer ?? this.offer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bannerText.present) {
      map['banner_text'] = Variable<String>(bannerText.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String?>(pic.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (product.present) {
      final converter = $BannerTableTable.$converter0;
      map['product'] = Variable<String?>(converter.mapToSql(product.value));
    }
    if (offer.present) {
      final converter = $BannerTableTable.$converter1;
      map['offer'] = Variable<String?>(converter.mapToSql(offer.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BannerTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bannerText: $bannerText, ')
          ..write('pic: $pic, ')
          ..write('status: $status, ')
          ..write('product: $product, ')
          ..write('offer: $offer')
          ..write(')'))
        .toString();
  }
}

class $BannerTableTable extends BannerTable
    with TableInfo<$BannerTableTable, BannerDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BannerTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _bannerTextMeta = const VerificationMeta('bannerText');
  late final GeneratedColumn<String?> bannerText = GeneratedColumn<String?>(
      'banner_text', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _picMeta = const VerificationMeta('pic');
  late final GeneratedColumn<String?> pic = GeneratedColumn<String?>(
      'pic', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String?> status = GeneratedColumn<String?>(
      'status', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _productMeta = const VerificationMeta('product');
  late final GeneratedColumnWithTypeConverter<ProductModel, String?> product =
      GeneratedColumn<String?>('product', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<ProductModel>($BannerTableTable.$converter0);
  final VerificationMeta _offerMeta = const VerificationMeta('offer');
  late final GeneratedColumnWithTypeConverter<OfferModel, String?> offer =
      GeneratedColumn<String?>('offer', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<OfferModel>($BannerTableTable.$converter1);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, bannerText, pic, status, product, offer];
  @override
  String get aliasedName => _alias ?? 'banner_table';
  @override
  String get actualTableName => 'banner_table';
  @override
  VerificationContext validateIntegrity(Insertable<BannerDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('banner_text')) {
      context.handle(
          _bannerTextMeta,
          bannerText.isAcceptableOrUnknown(
              data['banner_text']!, _bannerTextMeta));
    } else if (isInserting) {
      context.missing(_bannerTextMeta);
    }
    if (data.containsKey('pic')) {
      context.handle(
          _picMeta, pic.isAcceptableOrUnknown(data['pic']!, _picMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    context.handle(_productMeta, const VerificationResult.success());
    context.handle(_offerMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BannerDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return BannerDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BannerTableTable createAlias(String alias) {
    return $BannerTableTable(_db, alias);
  }

  static TypeConverter<ProductModel, String> $converter0 =
      const ProductModelConverter();
  static TypeConverter<OfferModel, String> $converter1 =
      const OfferModelConverter();
}

class CategoryDataClass extends DataClass
    implements Insertable<CategoryDataClass> {
  final int id;
  final String? name;
  final String? category_pic;
  final int? parent_category;
  final int productcount;
  final List<int>? subCategory;
  CategoryDataClass(
      {required this.id,
      this.name,
      this.category_pic,
      this.parent_category,
      required this.productcount,
      this.subCategory});
  factory CategoryDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CategoryDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      category_pic: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category_pic']),
      parent_category: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_category']),
      productcount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}productcount'])!,
      subCategory: $CategoryTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_category'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || category_pic != null) {
      map['category_pic'] = Variable<String?>(category_pic);
    }
    if (!nullToAbsent || parent_category != null) {
      map['parent_category'] = Variable<int?>(parent_category);
    }
    map['productcount'] = Variable<int>(productcount);
    if (!nullToAbsent || subCategory != null) {
      final converter = $CategoryTableTable.$converter0;
      map['sub_category'] = Variable<String?>(converter.mapToSql(subCategory));
    }
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      category_pic: category_pic == null && nullToAbsent
          ? const Value.absent()
          : Value(category_pic),
      parent_category: parent_category == null && nullToAbsent
          ? const Value.absent()
          : Value(parent_category),
      productcount: Value(productcount),
      subCategory: subCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subCategory),
    );
  }

  factory CategoryDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CategoryDataClass(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      category_pic: serializer.fromJson<String?>(json['category_pic']),
      parent_category: serializer.fromJson<int?>(json['parent_category']),
      productcount: serializer.fromJson<int>(json['productcount']),
      subCategory: serializer.fromJson<List<int>?>(json['subCategory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'category_pic': serializer.toJson<String?>(category_pic),
      'parent_category': serializer.toJson<int?>(parent_category),
      'productcount': serializer.toJson<int>(productcount),
      'subCategory': serializer.toJson<List<int>?>(subCategory),
    };
  }

  CategoryDataClass copyWith(
          {int? id,
          String? name,
          String? category_pic,
          int? parent_category,
          int? productcount,
          List<int>? subCategory}) =>
      CategoryDataClass(
        id: id ?? this.id,
        name: name ?? this.name,
        category_pic: category_pic ?? this.category_pic,
        parent_category: parent_category ?? this.parent_category,
        productcount: productcount ?? this.productcount,
        subCategory: subCategory ?? this.subCategory,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryDataClass(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category_pic: $category_pic, ')
          ..write('parent_category: $parent_category, ')
          ..write('productcount: $productcount, ')
          ..write('subCategory: $subCategory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              category_pic.hashCode,
              $mrjc(parent_category.hashCode,
                  $mrjc(productcount.hashCode, subCategory.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDataClass &&
          other.id == this.id &&
          other.name == this.name &&
          other.category_pic == this.category_pic &&
          other.parent_category == this.parent_category &&
          other.productcount == this.productcount &&
          other.subCategory == this.subCategory);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryDataClass> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> category_pic;
  final Value<int?> parent_category;
  final Value<int> productcount;
  final Value<List<int>?> subCategory;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category_pic = const Value.absent(),
    this.parent_category = const Value.absent(),
    this.productcount = const Value.absent(),
    this.subCategory = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category_pic = const Value.absent(),
    this.parent_category = const Value.absent(),
    required int productcount,
    this.subCategory = const Value.absent(),
  }) : productcount = Value(productcount);
  static Insertable<CategoryDataClass> custom({
    Expression<int>? id,
    Expression<String?>? name,
    Expression<String?>? category_pic,
    Expression<int?>? parent_category,
    Expression<int>? productcount,
    Expression<List<int>?>? subCategory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category_pic != null) 'category_pic': category_pic,
      if (parent_category != null) 'parent_category': parent_category,
      if (productcount != null) 'productcount': productcount,
      if (subCategory != null) 'sub_category': subCategory,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? category_pic,
      Value<int?>? parent_category,
      Value<int>? productcount,
      Value<List<int>?>? subCategory}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category_pic: category_pic ?? this.category_pic,
      parent_category: parent_category ?? this.parent_category,
      productcount: productcount ?? this.productcount,
      subCategory: subCategory ?? this.subCategory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (category_pic.present) {
      map['category_pic'] = Variable<String?>(category_pic.value);
    }
    if (parent_category.present) {
      map['parent_category'] = Variable<int?>(parent_category.value);
    }
    if (productcount.present) {
      map['productcount'] = Variable<int>(productcount.value);
    }
    if (subCategory.present) {
      final converter = $CategoryTableTable.$converter0;
      map['sub_category'] =
          Variable<String?>(converter.mapToSql(subCategory.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category_pic: $category_pic, ')
          ..write('parent_category: $parent_category, ')
          ..write('productcount: $productcount, ')
          ..write('subCategory: $subCategory')
          ..write(')'))
        .toString();
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, CategoryDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CategoryTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _category_picMeta =
      const VerificationMeta('category_pic');
  late final GeneratedColumn<String?> category_pic = GeneratedColumn<String?>(
      'category_pic', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _parent_categoryMeta =
      const VerificationMeta('parent_category');
  late final GeneratedColumn<int?> parent_category = GeneratedColumn<int?>(
      'parent_category', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _productcountMeta =
      const VerificationMeta('productcount');
  late final GeneratedColumn<int?> productcount = GeneratedColumn<int?>(
      'productcount', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _subCategoryMeta =
      const VerificationMeta('subCategory');
  late final GeneratedColumnWithTypeConverter<List<int>, String?> subCategory =
      GeneratedColumn<String?>('sub_category', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<List<int>>($CategoryTableTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, category_pic, parent_category, productcount, subCategory];
  @override
  String get aliasedName => _alias ?? 'category_table';
  @override
  String get actualTableName => 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('category_pic')) {
      context.handle(
          _category_picMeta,
          category_pic.isAcceptableOrUnknown(
              data['category_pic']!, _category_picMeta));
    }
    if (data.containsKey('parent_category')) {
      context.handle(
          _parent_categoryMeta,
          parent_category.isAcceptableOrUnknown(
              data['parent_category']!, _parent_categoryMeta));
    }
    if (data.containsKey('productcount')) {
      context.handle(
          _productcountMeta,
          productcount.isAcceptableOrUnknown(
              data['productcount']!, _productcountMeta));
    } else if (isInserting) {
      context.missing(_productcountMeta);
    }
    context.handle(_subCategoryMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CategoryDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(_db, alias);
  }

  static TypeConverter<List<int>, String> $converter0 =
      const SubCategoryConverter();
}

class CartDataClass extends DataClass implements Insertable<CartDataClass> {
  final int id;
  final ProductModel product;
  final int cartQty;
  final int ret;
  CartDataClass(
      {required this.id,
      required this.product,
      required this.cartQty,
      required this.ret});
  factory CartDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CartDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      product: $CartTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product']))!,
      cartQty: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cart_qty'])!,
      ret: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ret'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $CartTableTable.$converter0;
      map['product'] = Variable<String>(converter.mapToSql(product)!);
    }
    map['cart_qty'] = Variable<int>(cartQty);
    map['ret'] = Variable<int>(ret);
    return map;
  }

  CartTableCompanion toCompanion(bool nullToAbsent) {
    return CartTableCompanion(
      id: Value(id),
      product: Value(product),
      cartQty: Value(cartQty),
      ret: Value(ret),
    );
  }

  factory CartDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartDataClass(
      id: serializer.fromJson<int>(json['id']),
      product: serializer.fromJson<ProductModel>(json['product']),
      cartQty: serializer.fromJson<int>(json['cartQty']),
      ret: serializer.fromJson<int>(json['ret']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'product': serializer.toJson<ProductModel>(product),
      'cartQty': serializer.toJson<int>(cartQty),
      'ret': serializer.toJson<int>(ret),
    };
  }

  CartDataClass copyWith(
          {int? id, ProductModel? product, int? cartQty, int? ret}) =>
      CartDataClass(
        id: id ?? this.id,
        product: product ?? this.product,
        cartQty: cartQty ?? this.cartQty,
        ret: ret ?? this.ret,
      );
  @override
  String toString() {
    return (StringBuffer('CartDataClass(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('cartQty: $cartQty, ')
          ..write('ret: $ret')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(product.hashCode, $mrjc(cartQty.hashCode, ret.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartDataClass &&
          other.id == this.id &&
          other.product == this.product &&
          other.cartQty == this.cartQty &&
          other.ret == this.ret);
}

class CartTableCompanion extends UpdateCompanion<CartDataClass> {
  final Value<int> id;
  final Value<ProductModel> product;
  final Value<int> cartQty;
  final Value<int> ret;
  const CartTableCompanion({
    this.id = const Value.absent(),
    this.product = const Value.absent(),
    this.cartQty = const Value.absent(),
    this.ret = const Value.absent(),
  });
  CartTableCompanion.insert({
    required int id,
    required ProductModel product,
    required int cartQty,
    required int ret,
  })  : id = Value(id),
        product = Value(product),
        cartQty = Value(cartQty),
        ret = Value(ret);
  static Insertable<CartDataClass> custom({
    Expression<int>? id,
    Expression<ProductModel>? product,
    Expression<int>? cartQty,
    Expression<int>? ret,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (product != null) 'product': product,
      if (cartQty != null) 'cart_qty': cartQty,
      if (ret != null) 'ret': ret,
    });
  }

  CartTableCompanion copyWith(
      {Value<int>? id,
      Value<ProductModel>? product,
      Value<int>? cartQty,
      Value<int>? ret}) {
    return CartTableCompanion(
      id: id ?? this.id,
      product: product ?? this.product,
      cartQty: cartQty ?? this.cartQty,
      ret: ret ?? this.ret,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (product.present) {
      final converter = $CartTableTable.$converter0;
      map['product'] = Variable<String>(converter.mapToSql(product.value)!);
    }
    if (cartQty.present) {
      map['cart_qty'] = Variable<int>(cartQty.value);
    }
    if (ret.present) {
      map['ret'] = Variable<int>(ret.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartTableCompanion(')
          ..write('id: $id, ')
          ..write('product: $product, ')
          ..write('cartQty: $cartQty, ')
          ..write('ret: $ret')
          ..write(')'))
        .toString();
  }
}

class $CartTableTable extends CartTable
    with TableInfo<$CartTableTable, CartDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CartTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _productMeta = const VerificationMeta('product');
  late final GeneratedColumnWithTypeConverter<ProductModel, String?> product =
      GeneratedColumn<String?>('product', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<ProductModel>($CartTableTable.$converter0);
  final VerificationMeta _cartQtyMeta = const VerificationMeta('cartQty');
  late final GeneratedColumn<int?> cartQty = GeneratedColumn<int?>(
      'cart_qty', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _retMeta = const VerificationMeta('ret');
  late final GeneratedColumn<int?> ret = GeneratedColumn<int?>(
      'ret', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES retail_salesman_table (id) ON DELETE CASCADE');
  @override
  List<GeneratedColumn> get $columns => [id, product, cartQty, ret];
  @override
  String get aliasedName => _alias ?? 'cart_table';
  @override
  String get actualTableName => 'cart_table';
  @override
  VerificationContext validateIntegrity(Insertable<CartDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    context.handle(_productMeta, const VerificationResult.success());
    if (data.containsKey('cart_qty')) {
      context.handle(_cartQtyMeta,
          cartQty.isAcceptableOrUnknown(data['cart_qty']!, _cartQtyMeta));
    } else if (isInserting) {
      context.missing(_cartQtyMeta);
    }
    if (data.containsKey('ret')) {
      context.handle(
          _retMeta, ret.isAcceptableOrUnknown(data['ret']!, _retMeta));
    } else if (isInserting) {
      context.missing(_retMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, ret};
  @override
  CartDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CartDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CartTableTable createAlias(String alias) {
    return $CartTableTable(_db, alias);
  }

  static TypeConverter<ProductModel, String> $converter0 =
      const ProductModelConverter();
}

class RetailerDataClass extends DataClass
    implements Insertable<RetailerDataClass> {
  final int id;
  final String pinNo;
  final String name;
  final String phone;
  final String email;
  final String? pic;
  final List<DistributorsModel>? distributors;
  RetailerDataClass(
      {required this.id,
      required this.pinNo,
      required this.name,
      required this.phone,
      required this.email,
      this.pic,
      this.distributors});
  factory RetailerDataClass.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return RetailerDataClass(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      pinNo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pin_no'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      phone: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}phone'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email'])!,
      pic: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pic']),
      distributors: $RetailetTableTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}distributors'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pin_no'] = Variable<String>(pinNo);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || pic != null) {
      map['pic'] = Variable<String?>(pic);
    }
    if (!nullToAbsent || distributors != null) {
      final converter = $RetailetTableTable.$converter0;
      map['distributors'] = Variable<String?>(converter.mapToSql(distributors));
    }
    return map;
  }

  RetailetTableCompanion toCompanion(bool nullToAbsent) {
    return RetailetTableCompanion(
      id: Value(id),
      pinNo: Value(pinNo),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      pic: pic == null && nullToAbsent ? const Value.absent() : Value(pic),
      distributors: distributors == null && nullToAbsent
          ? const Value.absent()
          : Value(distributors),
    );
  }

  factory RetailerDataClass.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return RetailerDataClass(
      id: serializer.fromJson<int>(json['id']),
      pinNo: serializer.fromJson<String>(json['pinNo']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      pic: serializer.fromJson<String?>(json['pic']),
      distributors:
          serializer.fromJson<List<DistributorsModel>?>(json['distributors']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pinNo': serializer.toJson<String>(pinNo),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'pic': serializer.toJson<String?>(pic),
      'distributors': serializer.toJson<List<DistributorsModel>?>(distributors),
    };
  }

  RetailerDataClass copyWith(
          {int? id,
          String? pinNo,
          String? name,
          String? phone,
          String? email,
          String? pic,
          List<DistributorsModel>? distributors}) =>
      RetailerDataClass(
        id: id ?? this.id,
        pinNo: pinNo ?? this.pinNo,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        pic: pic ?? this.pic,
        distributors: distributors ?? this.distributors,
      );
  @override
  String toString() {
    return (StringBuffer('RetailerDataClass(')
          ..write('id: $id, ')
          ..write('pinNo: $pinNo, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('pic: $pic, ')
          ..write('distributors: $distributors')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          pinNo.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  phone.hashCode,
                  $mrjc(email.hashCode,
                      $mrjc(pic.hashCode, distributors.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetailerDataClass &&
          other.id == this.id &&
          other.pinNo == this.pinNo &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.pic == this.pic &&
          other.distributors == this.distributors);
}

class RetailetTableCompanion extends UpdateCompanion<RetailerDataClass> {
  final Value<int> id;
  final Value<String> pinNo;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> pic;
  final Value<List<DistributorsModel>?> distributors;
  const RetailetTableCompanion({
    this.id = const Value.absent(),
    this.pinNo = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.pic = const Value.absent(),
    this.distributors = const Value.absent(),
  });
  RetailetTableCompanion.insert({
    this.id = const Value.absent(),
    required String pinNo,
    required String name,
    required String phone,
    required String email,
    this.pic = const Value.absent(),
    this.distributors = const Value.absent(),
  })  : pinNo = Value(pinNo),
        name = Value(name),
        phone = Value(phone),
        email = Value(email);
  static Insertable<RetailerDataClass> custom({
    Expression<int>? id,
    Expression<String>? pinNo,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String?>? pic,
    Expression<List<DistributorsModel>?>? distributors,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pinNo != null) 'pin_no': pinNo,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (pic != null) 'pic': pic,
      if (distributors != null) 'distributors': distributors,
    });
  }

  RetailetTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? pinNo,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? email,
      Value<String?>? pic,
      Value<List<DistributorsModel>?>? distributors}) {
    return RetailetTableCompanion(
      id: id ?? this.id,
      pinNo: pinNo ?? this.pinNo,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      pic: pic ?? this.pic,
      distributors: distributors ?? this.distributors,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pinNo.present) {
      map['pin_no'] = Variable<String>(pinNo.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String?>(pic.value);
    }
    if (distributors.present) {
      final converter = $RetailetTableTable.$converter0;
      map['distributors'] =
          Variable<String?>(converter.mapToSql(distributors.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RetailetTableCompanion(')
          ..write('id: $id, ')
          ..write('pinNo: $pinNo, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('pic: $pic, ')
          ..write('distributors: $distributors')
          ..write(')'))
        .toString();
  }
}

class $RetailetTableTable extends RetailetTable
    with TableInfo<$RetailetTableTable, RetailerDataClass> {
  final GeneratedDatabase _db;
  final String? _alias;
  $RetailetTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _pinNoMeta = const VerificationMeta('pinNo');
  late final GeneratedColumn<String?> pinNo = GeneratedColumn<String?>(
      'pin_no', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _phoneMeta = const VerificationMeta('phone');
  late final GeneratedColumn<String?> phone = GeneratedColumn<String?>(
      'phone', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _picMeta = const VerificationMeta('pic');
  late final GeneratedColumn<String?> pic = GeneratedColumn<String?>(
      'pic', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _distributorsMeta =
      const VerificationMeta('distributors');
  late final GeneratedColumnWithTypeConverter<List<DistributorsModel>, String?>
      distributors = GeneratedColumn<String?>('distributors', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<List<DistributorsModel>>(
              $RetailetTableTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pinNo, name, phone, email, pic, distributors];
  @override
  String get aliasedName => _alias ?? 'retailet_table';
  @override
  String get actualTableName => 'retailet_table';
  @override
  VerificationContext validateIntegrity(Insertable<RetailerDataClass> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pin_no')) {
      context.handle(
          _pinNoMeta, pinNo.isAcceptableOrUnknown(data['pin_no']!, _pinNoMeta));
    } else if (isInserting) {
      context.missing(_pinNoMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('pic')) {
      context.handle(
          _picMeta, pic.isAcceptableOrUnknown(data['pic']!, _picMeta));
    }
    context.handle(_distributorsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RetailerDataClass map(Map<String, dynamic> data, {String? tablePrefix}) {
    return RetailerDataClass.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RetailetTableTable createAlias(String alias) {
    return $RetailetTableTable(_db, alias);
  }

  static TypeConverter<List<DistributorsModel>, String> $converter0 =
      const DistributorModelConverter();
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $RetailSalesmanTableTable retailSalesmanTable =
      $RetailSalesmanTableTable(this);
  late final $ProductTableTable productTable = $ProductTableTable(this);
  late final $OfferTableTable offerTable = $OfferTableTable(this);
  late final $BannerTableTable bannerTable = $BannerTableTable(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $CartTableTable cartTable = $CartTableTable(this);
  late final $RetailetTableTable retailetTable = $RetailetTableTable(this);
  late final RetailSalesmanDao retailSalesmanDao =
      RetailSalesmanDao(this as AppDatabase);
  late final ProductDao productDao = ProductDao(this as AppDatabase);
  late final OfferDao offerDao = OfferDao(this as AppDatabase);
  late final BannerDao bannerDao = BannerDao(this as AppDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final CartDao cartDao = CartDao(this as AppDatabase);
  late final RetailerDao retailerDao = RetailerDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        retailSalesmanTable,
        productTable,
        offerTable,
        bannerTable,
        categoryTable,
        cartTable,
        retailetTable
      ];
}
