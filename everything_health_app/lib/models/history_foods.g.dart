// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_foods.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryFoodCollection on Isar {
  IsarCollection<HistoryFood> get historyFoods => this.collection();
}

const HistoryFoodSchema = CollectionSchema(
  name: r'HistoryFood',
  id: 749614461059014392,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.double,
    ),
    r'carbs': PropertySchema(
      id: 1,
      name: r'carbs',
      type: IsarType.double,
    ),
    r'code': PropertySchema(
      id: 2,
      name: r'code',
      type: IsarType.long,
    ),
    r'color': PropertySchema(
      id: 3,
      name: r'color',
      type: IsarType.long,
    ),
    r'density': PropertySchema(
      id: 4,
      name: r'density',
      type: IsarType.double,
    ),
    r'densityRequired': PropertySchema(
      id: 5,
      name: r'densityRequired',
      type: IsarType.bool,
    ),
    r'fats': PropertySchema(
      id: 6,
      name: r'fats',
      type: IsarType.double,
    ),
    r'grams': PropertySchema(
      id: 7,
      name: r'grams',
      type: IsarType.double,
    ),
    r'image_small_url': PropertySchema(
      id: 8,
      name: r'image_small_url',
      type: IsarType.string,
    ),
    r'img_url': PropertySchema(
      id: 9,
      name: r'img_url',
      type: IsarType.string,
    ),
    r'meal': PropertySchema(
      id: 10,
      name: r'meal',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'normalized_name': PropertySchema(
      id: 12,
      name: r'normalized_name',
      type: IsarType.string,
    ),
    r'protein': PropertySchema(
      id: 13,
      name: r'protein',
      type: IsarType.double,
    ),
    r'serving_size': PropertySchema(
      id: 14,
      name: r'serving_size',
      type: IsarType.string,
    ),
    r'servings': PropertySchema(
      id: 15,
      name: r'servings',
      type: IsarType.double,
    ),
    r'sugar': PropertySchema(
      id: 16,
      name: r'sugar',
      type: IsarType.double,
    ),
    r'time': PropertySchema(
      id: 17,
      name: r'time',
      type: IsarType.long,
    )
  },
  estimateSize: _historyFoodEstimateSize,
  serialize: _historyFoodSerialize,
  deserialize: _historyFoodDeserialize,
  deserializeProp: _historyFoodDeserializeProp,
  idName: r'id',
  indexes: {
    r'normalized_name': IndexSchema(
      id: 2353165496058032691,
      name: r'normalized_name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'normalized_name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _historyFoodGetId,
  getLinks: _historyFoodGetLinks,
  attach: _historyFoodAttach,
  version: '3.1.0+1',
);

int _historyFoodEstimateSize(
  HistoryFood object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.image_small_url.length * 3;
  bytesCount += 3 + object.img_url.length * 3;
  bytesCount += 3 + object.meal.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.normalized_name.length * 3;
  bytesCount += 3 + object.serving_size.length * 3;
  return bytesCount;
}

void _historyFoodSerialize(
  HistoryFood object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.calories);
  writer.writeDouble(offsets[1], object.carbs);
  writer.writeLong(offsets[2], object.code);
  writer.writeLong(offsets[3], object.color);
  writer.writeDouble(offsets[4], object.density);
  writer.writeBool(offsets[5], object.densityRequired);
  writer.writeDouble(offsets[6], object.fats);
  writer.writeDouble(offsets[7], object.grams);
  writer.writeString(offsets[8], object.image_small_url);
  writer.writeString(offsets[9], object.img_url);
  writer.writeString(offsets[10], object.meal);
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.normalized_name);
  writer.writeDouble(offsets[13], object.protein);
  writer.writeString(offsets[14], object.serving_size);
  writer.writeDouble(offsets[15], object.servings);
  writer.writeDouble(offsets[16], object.sugar);
  writer.writeLong(offsets[17], object.time);
}

HistoryFood _historyFoodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryFood(
    calories: reader.readDouble(offsets[0]),
    carbs: reader.readDouble(offsets[1]),
    code: reader.readLongOrNull(offsets[2]) ?? -1,
    color: reader.readLong(offsets[3]),
    density: reader.readDoubleOrNull(offsets[4]) ?? 1.0,
    densityRequired: reader.readBoolOrNull(offsets[5]) ?? false,
    fats: reader.readDouble(offsets[6]),
    grams: reader.readDouble(offsets[7]),
    image_small_url: reader.readStringOrNull(offsets[8]) ?? "",
    img_url: reader.readStringOrNull(offsets[9]) ?? "",
    meal: reader.readStringOrNull(offsets[10]) ?? "",
    name: reader.readString(offsets[11]),
    normalized_name: reader.readString(offsets[12]),
    protein: reader.readDouble(offsets[13]),
    serving_size: reader.readString(offsets[14]),
    servings: reader.readDoubleOrNull(offsets[15]) ?? 1,
    sugar: reader.readDouble(offsets[16]),
    time: reader.readLong(offsets[17]),
  );
  object.id = id;
  return object;
}

P _historyFoodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? -1) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 1.0) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset) ?? 1) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _historyFoodGetId(HistoryFood object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyFoodGetLinks(HistoryFood object) {
  return [];
}

void _historyFoodAttach(
    IsarCollection<dynamic> col, Id id, HistoryFood object) {
  object.id = id;
}

extension HistoryFoodQueryWhereSort
    on QueryBuilder<HistoryFood, HistoryFood, QWhere> {
  QueryBuilder<HistoryFood, HistoryFood, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhere> anyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'code'),
      );
    });
  }
}

extension HistoryFoodQueryWhere
    on QueryBuilder<HistoryFood, HistoryFood, QWhereClause> {
  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause>
      normalized_nameEqualTo(String normalized_name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'normalized_name',
        value: [normalized_name],
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause>
      normalized_nameNotEqualTo(String normalized_name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalized_name',
              lower: [],
              upper: [normalized_name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalized_name',
              lower: [normalized_name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalized_name',
              lower: [normalized_name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalized_name',
              lower: [],
              upper: [normalized_name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> codeEqualTo(
      int code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> codeNotEqualTo(
      int code) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> codeGreaterThan(
    int code, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'code',
        lower: [code],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> codeLessThan(
    int code, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'code',
        lower: [],
        upper: [code],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterWhereClause> codeBetween(
    int lowerCode,
    int upperCode, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'code',
        lower: [lowerCode],
        includeLower: includeLower,
        upper: [upperCode],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryFoodQueryFilter
    on QueryBuilder<HistoryFood, HistoryFood, QFilterCondition> {
  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> caloriesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      caloriesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      caloriesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> caloriesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> carbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      carbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> carbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> carbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> codeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> codeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> codeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> codeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> colorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      colorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> colorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> densityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      densityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> densityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> densityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'density',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      densityRequiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'densityRequired',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> fatsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> fatsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> fatsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> fatsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> gramsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grams',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      gramsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grams',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> gramsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grams',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> gramsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grams',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'image_small_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'image_small_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image_small_url',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      image_small_urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'image_small_url',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      img_urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'img_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      img_urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'img_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> img_urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'img_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      img_urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'img_url',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      img_urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'img_url',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> mealIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meal',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      mealIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meal',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'normalized_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'normalized_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalized_name',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      normalized_nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'normalized_name',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> proteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      proteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> proteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> proteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serving_size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serving_size',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serving_size',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      serving_sizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serving_size',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> servingsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'servings',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      servingsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'servings',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      servingsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'servings',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> servingsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'servings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> sugarEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition>
      sugarGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> sugarLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> sugarBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sugar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> timeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> timeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> timeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterFilterCondition> timeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryFoodQueryObject
    on QueryBuilder<HistoryFood, HistoryFood, QFilterCondition> {}

extension HistoryFoodQueryLinks
    on QueryBuilder<HistoryFood, HistoryFood, QFilterCondition> {}

extension HistoryFoodQuerySortBy
    on QueryBuilder<HistoryFood, HistoryFood, QSortBy> {
  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      sortByDensityRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByGramsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByImage_small_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      sortByImage_small_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByImg_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByImg_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByNormalized_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      sortByNormalized_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByServing_size() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      sortByServing_sizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension HistoryFoodQuerySortThenBy
    on QueryBuilder<HistoryFood, HistoryFood, QSortThenBy> {
  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      thenByDensityRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByGramsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByImage_small_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      thenByImage_small_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByImg_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByImg_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByMeal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByMealDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meal', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByNormalized_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      thenByNormalized_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByServing_size() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy>
      thenByServing_sizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension HistoryFoodQueryWhereDistinct
    on QueryBuilder<HistoryFood, HistoryFood, QDistinct> {
  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'density');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct>
      distinctByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'densityRequired');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fats');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grams');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByImage_small_url(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'image_small_url',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByImg_url(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'img_url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByMeal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meal', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByNormalized_name(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'normalized_name',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByServing_size(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serving_size', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servings');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugar');
    });
  }

  QueryBuilder<HistoryFood, HistoryFood, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }
}

extension HistoryFoodQueryProperty
    on QueryBuilder<HistoryFood, HistoryFood, QQueryProperty> {
  QueryBuilder<HistoryFood, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> carbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs');
    });
  }

  QueryBuilder<HistoryFood, int, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<HistoryFood, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> densityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'density');
    });
  }

  QueryBuilder<HistoryFood, bool, QQueryOperations> densityRequiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'densityRequired');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> fatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fats');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> gramsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grams');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations>
      image_small_urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'image_small_url');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations> img_urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'img_url');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations> mealProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meal');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations>
      normalized_nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'normalized_name');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<HistoryFood, String, QQueryOperations> serving_sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serving_size');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> servingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servings');
    });
  }

  QueryBuilder<HistoryFood, double, QQueryOperations> sugarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugar');
    });
  }

  QueryBuilder<HistoryFood, int, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}
