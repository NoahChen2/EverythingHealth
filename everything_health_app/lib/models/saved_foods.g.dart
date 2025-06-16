// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_foods.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedFoodCollection on Isar {
  IsarCollection<SavedFood> get savedFoods => this.collection();
}

const SavedFoodSchema = CollectionSchema(
  name: r'SavedFood',
  id: 5511834726110923322,
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
    r'name': PropertySchema(
      id: 10,
      name: r'name',
      type: IsarType.string,
    ),
    r'normalized_name': PropertySchema(
      id: 11,
      name: r'normalized_name',
      type: IsarType.string,
    ),
    r'protein': PropertySchema(
      id: 12,
      name: r'protein',
      type: IsarType.double,
    ),
    r'serving_size': PropertySchema(
      id: 13,
      name: r'serving_size',
      type: IsarType.string,
    ),
    r'servings': PropertySchema(
      id: 14,
      name: r'servings',
      type: IsarType.double,
    ),
    r'sugar': PropertySchema(
      id: 15,
      name: r'sugar',
      type: IsarType.double,
    )
  },
  estimateSize: _savedFoodEstimateSize,
  serialize: _savedFoodSerialize,
  deserialize: _savedFoodDeserialize,
  deserializeProp: _savedFoodDeserializeProp,
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
  getId: _savedFoodGetId,
  getLinks: _savedFoodGetLinks,
  attach: _savedFoodAttach,
  version: '3.1.0+1',
);

int _savedFoodEstimateSize(
  SavedFood object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.image_small_url.length * 3;
  bytesCount += 3 + object.img_url.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.normalized_name.length * 3;
  bytesCount += 3 + object.serving_size.length * 3;
  return bytesCount;
}

void _savedFoodSerialize(
  SavedFood object,
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
  writer.writeString(offsets[10], object.name);
  writer.writeString(offsets[11], object.normalized_name);
  writer.writeDouble(offsets[12], object.protein);
  writer.writeString(offsets[13], object.serving_size);
  writer.writeDouble(offsets[14], object.servings);
  writer.writeDouble(offsets[15], object.sugar);
}

SavedFood _savedFoodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedFood(
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
    name: reader.readString(offsets[10]),
    normalized_name: reader.readString(offsets[11]),
    protein: reader.readDouble(offsets[12]),
    serving_size: reader.readString(offsets[13]),
    servings: reader.readDoubleOrNull(offsets[14]) ?? 1.0,
    sugar: reader.readDouble(offsets[15]),
  );
  object.id = id;
  return object;
}

P _savedFoodDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset) ?? 1.0) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedFoodGetId(SavedFood object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedFoodGetLinks(SavedFood object) {
  return [];
}

void _savedFoodAttach(IsarCollection<dynamic> col, Id id, SavedFood object) {
  object.id = id;
}

extension SavedFoodQueryWhereSort
    on QueryBuilder<SavedFood, SavedFood, QWhere> {
  QueryBuilder<SavedFood, SavedFood, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhere> anyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'code'),
      );
    });
  }
}

extension SavedFoodQueryWhere
    on QueryBuilder<SavedFood, SavedFood, QWhereClause> {
  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> idBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> normalized_nameEqualTo(
      String normalized_name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'normalized_name',
        value: [normalized_name],
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause>
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> codeEqualTo(int code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> codeNotEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> codeGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> codeLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterWhereClause> codeBetween(
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

extension SavedFoodQueryFilter
    on QueryBuilder<SavedFood, SavedFood, QFilterCondition> {
  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> caloriesEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> caloriesGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> caloriesLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> caloriesBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> carbsEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> carbsGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> carbsLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> carbsBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> codeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> codeGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> codeLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> codeBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> colorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> colorGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> colorLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> colorBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> densityEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> densityGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> densityLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> densityBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      densityRequiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'densityRequired',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> fatsEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> fatsGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> fatsLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> fatsBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> gramsEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> gramsGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> gramsLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> gramsBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      image_small_urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'image_small_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      image_small_urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'image_small_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      image_small_urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image_small_url',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      image_small_urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'image_small_url',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlStartsWith(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlEndsWith(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlContains(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlMatches(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> img_urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'img_url',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      img_urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'img_url',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameContains(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      normalized_nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'normalized_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      normalized_nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'normalized_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      normalized_nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalized_name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      normalized_nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'normalized_name',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> proteinEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> proteinGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> proteinLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> proteinBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> serving_sizeEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> serving_sizeBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      serving_sizeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serving_size',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> serving_sizeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serving_size',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      serving_sizeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serving_size',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition>
      serving_sizeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serving_size',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> servingsEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> servingsGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> servingsLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> servingsBetween(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> sugarEqualTo(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> sugarGreaterThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> sugarLessThan(
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

  QueryBuilder<SavedFood, SavedFood, QAfterFilterCondition> sugarBetween(
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
}

extension SavedFoodQueryObject
    on QueryBuilder<SavedFood, SavedFood, QFilterCondition> {}

extension SavedFoodQueryLinks
    on QueryBuilder<SavedFood, SavedFood, QFilterCondition> {}

extension SavedFoodQuerySortBy on QueryBuilder<SavedFood, SavedFood, QSortBy> {
  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByDensityRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByGramsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByImage_small_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByImage_small_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByImg_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByImg_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByNormalized_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByNormalized_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByServing_size() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByServing_sizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortByServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> sortBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }
}

extension SavedFoodQuerySortThenBy
    on QueryBuilder<SavedFood, SavedFood, QSortThenBy> {
  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByDensityRequiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'densityRequired', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByGramsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grams', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByImage_small_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByImage_small_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image_small_url', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByImg_url() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByImg_urlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img_url', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByNormalized_name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByNormalized_nameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalized_name', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByServing_size() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByServing_sizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serving_size', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenByServingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'servings', Sort.desc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QAfterSortBy> thenBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }
}

extension SavedFoodQueryWhereDistinct
    on QueryBuilder<SavedFood, SavedFood, QDistinct> {
  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'density');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByDensityRequired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'densityRequired');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fats');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByGrams() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grams');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByImage_small_url(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'image_small_url',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByImg_url(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'img_url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByNormalized_name(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'normalized_name',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByServing_size(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serving_size', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctByServings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'servings');
    });
  }

  QueryBuilder<SavedFood, SavedFood, QDistinct> distinctBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugar');
    });
  }
}

extension SavedFoodQueryProperty
    on QueryBuilder<SavedFood, SavedFood, QQueryProperty> {
  QueryBuilder<SavedFood, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> carbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs');
    });
  }

  QueryBuilder<SavedFood, int, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<SavedFood, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> densityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'density');
    });
  }

  QueryBuilder<SavedFood, bool, QQueryOperations> densityRequiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'densityRequired');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> fatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fats');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> gramsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grams');
    });
  }

  QueryBuilder<SavedFood, String, QQueryOperations> image_small_urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'image_small_url');
    });
  }

  QueryBuilder<SavedFood, String, QQueryOperations> img_urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'img_url');
    });
  }

  QueryBuilder<SavedFood, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SavedFood, String, QQueryOperations> normalized_nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'normalized_name');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<SavedFood, String, QQueryOperations> serving_sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serving_size');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> servingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'servings');
    });
  }

  QueryBuilder<SavedFood, double, QQueryOperations> sugarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugar');
    });
  }
}
